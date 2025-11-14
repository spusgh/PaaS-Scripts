"""Terraform Action Handler"""

import subprocess
import json
import logging
import asyncio

logger = logging.getLogger(__name__)

class TerraformHandler:
    def __init__(self, workspace_dir, workspace_name="default"):
        self.workspace_dir = workspace_dir
        self.workspace_name = workspace_name
        self.state_lock = asyncio.Lock()
    
    async def execute_action(self, action):
        async with self.state_lock:
            if action.action_type.value == "terraform_apply":
                return await self.apply_changes(
                    action.parameters.get("changes"),
                    action.parameters.get("auto_approve", False)
                )
            else:
                raise ValueError(f"Unknown action: {action.action_type}")
    
    async def apply_changes(self, changes, auto_approve=False):
        logger.info(f"Applying Terraform changes")
        
        await self._run_command(["init"])
        await self._run_command(["workspace", "select", self.workspace_name])
        
        plan_output = await self._run_command(["plan", "-out=remediation.tfplan"])
        plan_json = await self._run_command(["show", "-json", "remediation.tfplan"])
        plan_data = json.loads(plan_json)
        
        if not self._validate_plan(plan_data):
            raise ValueError("Plan validation failed")
        
        if auto_approve:
            await self._run_command(["apply", "-auto-approve", "remediation.tfplan"])
        
        return {"status": "success", "changes": changes}
    
    def _validate_plan(self, plan_data):
        if not plan_data.get("resource_changes"):
            return True
        
        for change in plan_data["resource_changes"]:
            actions = change.get("change", {}).get("actions", [])
            if "delete" in actions:
                resource_type = change.get("type")
                if resource_type in ["aws_db_instance", "aws_s3_bucket"]:
                    return False
        
        return True
    
    async def _run_command(self, args):
        cmd = ["terraform"] + args
        process = await asyncio.create_subprocess_exec(
            *cmd,
            cwd=self.workspace_dir,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        stdout, stderr = await process.communicate()
        
        if process.returncode != 0:
            raise RuntimeError(f"Terraform error: {stderr.decode()}")
        
        return stdout.decode()