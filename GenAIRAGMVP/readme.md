# GenAI RAG MVP

A production-ready Retrieval-Augmented Generation (RAG) application powered by Claude AI, featuring semantic search, document management, and intelligent chat capabilities.

## 🚀 Features

- **Intelligent Chat Interface**: Conversational AI powered by Claude Sonnet 4
- **RAG Pipeline**: Semantic search with vector embeddings for context-aware responses
- **Document Management**: Upload, process, and index documents for knowledge retrieval
- **Vector Search**: pgvector-powered similarity search for relevant context retrieval
- **Scalable Architecture**: Modular design with FastAPI backend and React frontend
- **CI/CD Ready**: GitHub Actions workflows for automated testing and deployment
- **Docker Support**: Complete containerization with Docker Compose

## 📋 Architecture

```
┌─────────────────┐
│  React Frontend │
│   (Port 5173)   │
└────────┬────────┘
         │
         │ HTTP/REST API
         ▼
┌─────────────────┐
│  FastAPI Backend│
│   (Port 8000)   │
└────────┬────────┘
         │
         ├──────────► Anthropic Claude API
         │
         ├──────────► PostgreSQL + pgvector
         │            (Port 5432)
         │
         └──────────► Redis Cache
                      (Port 6379)
```

## 🛠️ Tech Stack

### Backend
- **Framework**: FastAPI (Python 3.11+)
- **LLM**: Anthropic Claude Sonnet 4
- **Database**: PostgreSQL 16 with pgvector extension
- **Caching**: Redis
- **Vector Store**: pgvector for semantic search

### Frontend
- **Framework**: React 18
- **Styling**: Tailwind CSS
- **Icons**: Lucide React
- **HTTP Client**: Fetch API

### DevOps
- **Containerization**: Docker & Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus (optional)
---

## 📦 Prerequisites

- Python 3.11+
- Node.js 18+
- PostgreSQL 16 with pgvector
- Docker & Docker Compose (optional)
- Anthropic API Key


## 🗄️ Database Schema

### Key Tables

- **documents**: Stores uploaded documents and metadata
- **document_chunks**: Text chunks for efficient retrieval
- **embeddings**: Vector embeddings for semantic search
- **conversations**: Chat conversation history
- **messages**: Individual messages with RAG context
- **rag_context**: Links between messages and retrieved documents

---

## 🧪 Testing

- Backend Tests
- Frontend Tests
- CI/CD Integration Tests
- Load Testing
- Security Testing
- API Contract Testing
- End-to-End Testing
- Mocking External Services

---

## 🔧 Configuration

- Chunking Strategy
- Vector Search Parameters
- LLM Configuration
- Monitoring
- Health Check
- Metrics (Prometheus)
- Deployment 
    - Docker Production Build 
    - AWS ECS Deployment

---

## 🔐 Security

- API keys stored in environment variables
- CORS configured for allowed origins
- Rate limiting enabled on all endpoints
- SQL injection prevention via parameterized queries
- Input validation with Pydantic models

---

## 📈 Performance Optimization

- **Caching**: Redis for embedding and query caching
- **Connection Pooling**: SQLAlchemy async sessions
- **Batch Processing**: Bulk document uploads
- **Vector Indexing**: HNSW index for fast similarity search

---

## 🙏 Acknowledgments

- Anthropic for Claude API
- pgvector for PostgreSQL vector extension
- FastAPI framework team
- React and Tailwind CSS communities

---

## Service Models Categorization 
Based on the architecture and capabilities of this GenAI RAG MVP, It can categorize it across multiple service models:
Primary Classification: 
### PaaS (Platform as a Service)
This MVP is predominantly a PaaS solution because:<br/>
✅ PaaS Characteristics Present:
- Development Platform: Provides a complete platform for building RAG-powered applications
- APIs & SDKs: Offers RESTful APIs (/api/chat, /api/documents/upload, /api/search/vector)
- Managed Infrastructure: Handles database (PostgreSQL + pgvector), vector storage, embedding generation
- Middleware Services: Manages document processing, chunking, embedding pipeline
- Abstraction Layer: Developers don't manage servers, just integrate via APIs
- Multi-tenant Ready: User management system for multiple organizations

### AIaaS (AI as a Service) 
Secondary Characteristics:<br/>
✅ AIaaS Elements:
Claude AI integration for intelligent responses
- Vector embedding generation
- Semantic search capabilities
- RAG pipeline as a service
- Document intelligence and summarization

###  SaaS (Software as a Service)
✅ SaaS Potential:
 Complete chat interface (ready for end-users)
- Document management UI
- User authentication and management
- Analytics dashboard
- ⚠️ Would need multi-tenant isolation, billing, subscription management

Built with ❤️ using Claude, FastAPI, and React
