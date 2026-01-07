# Meta Data Modeling - Clay Database

## XYZ Financials & Securities System

### Overview

This document provides comprehensive metadata modeling documentation for the XYZ Financials & Securities Clay database. The database supports mortgage lending operations, loan servicing, securities management, and financial reporting.

---

## Table of Contents

- [Database Schema Overview](#database-schema-overview)
- [Entity Relationship Model](#entity-relationship-model)
- [Core Domains](#core-domains)
- [Table Metadata](#table-metadata)
- [Data Dictionary](#data-dictionary)
- [Business Rules & Constraints](#business-rules--constraints)
- [Data Lineage](#data-lineage)
- [Performance Considerations](#performance-considerations)

---

## Database Schema Overview

The XYZ Financials database consists of **26 tables** organized into the following functional domains:

| Domain | Tables | Purpose |
|--------|--------|---------|
| **Customer Management** | Customers, CustomerAddresses | Customer information and contact details |
| **Loan Origination** | Applications, MortgageProducts, DocumentsRegistry | Loan application and underwriting process |
| **Loan Servicing** | Loans, Payments, EscrowAccounts, EscrowTransactions | Active loan management and payment processing |
| **Risk & Compliance** | RiskAssessments, DefaultsForeclosures, LoanTermModifications | Risk evaluation and loan modifications |
| **Securities & Capital Markets** | Securities, ServicingRights, CapitalMarketData, FINRA_FI | Secondary market and securities management |
| **Property Management** | PropertyDetails | Real estate collateral information |
| **Organization** | LoanOfficers | Staff and organizational structure |
| **Reference Data** | InterestType, ProductSubtype | Code tables and reference data |
| **System Management** | AuditLog | Audit trail and system logging |

---

## Entity Relationship Model

### Primary Relationships

```
Customers (1) ─────< (N) Applications
    │                       │
    │                       │
    └─────< (N) CustomerAddresses
    │
    └─────< (N) Loans
                │
                ├─────< (N) Payments
                ├─────< (N) EscrowAccounts
                │              │
                │              └─────< (N) EscrowTransactions
                ├─────< (N) DefaultsForeclosures
                ├─────< (N) LoanTermModifications
                └─────< (N) ServicingRights

Applications (1) ─────< (1) Loans
    │
    └─────< (N) DocumentsRegistry
    │
    └─────< (1) RiskAssessments

PropertyDetails (1) ─────< (N) Loans

MortgageProducts (1) ─────< (N) Applications
                 │
                 └─────< (N) Loans

LoanOfficers (1) ─────< (N) Applications

Securities (1) ─────< (N) Loans
```

### Key Foreign Key Relationships

| Parent Table | Child Table | Relationship Type | Cardinality |
|--------------|-------------|-------------------|-------------|
| Customers | Applications | One-to-Many | 1:N |
| Customers | Loans | One-to-Many | 1:N |
| Customers | CustomerAddresses | One-to-Many | 1:N |
| Applications | Loans | One-to-One | 1:1 |
| Applications | DocumentsRegistry | One-to-Many | 1:N |
| Applications | RiskAssessments | One-to-One | 1:1 |
| Loans | Payments | One-to-Many | 1:N |
| Loans | EscrowAccounts | One-to-One | 1:1 |
| Loans | DefaultsForeclosures | One-to-Many | 1:N |
| EscrowAccounts | EscrowTransactions | One-to-Many | 1:N |
| PropertyDetails | Loans | One-to-Many | 1:N |
| MortgageProducts | Applications | One-to-Many | 1:N |
| Securities | Loans | One-to-Many | 1:N |

---

## Core Domains

### 1. Customer Management Domain

**Purpose**: Manage customer information, demographics, and contact details.

**Tables**:
- `Customers`: Core customer profile and financial information
- `CustomerAddresses`: Physical and mailing addresses with temporal tracking

**Key Attributes**:
- Customer identification (SSN, CustomerID)
- Financial profile (AnnualIncome, CreditScore, EmploymentStatus)
- Temporal tracking (CreatedDate, LastUpdatedDate)

**Business Rules**:
- SSN must be unique and formatted as XXX-XX-XXXX
- Email must be valid format
- Credit scores range from 300-850
- Customer must have at least one active address

---

### 2. Loan Origination Domain

**Purpose**: Handle the complete loan application and approval workflow.

**Tables**:
- `Applications`: Loan application records
- `MortgageProducts`: Available loan products and their parameters
- `DocumentsRegistry`: Required and submitted documentation
- `RiskAssessments`: Underwriting risk analysis

**Application Lifecycle**:
```
Submitted → Under Review → Documentation → Underwriting → Approved/Denied → Closed
```

**Key Metrics**:
- Debt-to-Income Ratio (DTI)
- Loan-to-Value Ratio (LTV)
- Application turnaround time
- Approval/denial rates

---

### 3. Loan Servicing Domain

**Purpose**: Manage active loans, payments, and escrow accounts.

**Tables**:
- `Loans`: Active loan portfolio
- `Payments`: Payment history and transactions
- `EscrowAccounts`: Tax and insurance escrow management
- `EscrowTransactions`: Escrow payment details

**Payment Hierarchy**:
```
Payment Amount
├── Principal Amount
├── Interest Amount
├── Escrow Amount
│   ├── Property Tax
│   ├── Property Insurance
│   └── PMI (Private Mortgage Insurance)
└── Late Fee Amount
```

**Loan Status Values**:
- `Active`: Currently servicing
- `Current`: Payments up to date
- `Delinquent`: Past due
- `Paid Off`: Loan satisfied
- `Foreclosure`: In default proceedings
- `Refinanced`: Replaced by new loan

---

### 4. Risk & Compliance Domain

**Purpose**: Track risk metrics, defaults, and loan modifications.

**Tables**:
- `RiskAssessments`: Credit and risk evaluations
- `DefaultsForeclosures`: Default tracking and foreclosure process
- `LoanTermModifications`: Loan restructuring history

**Risk Classifications**:
- Low Risk
- Medium Risk
- High Risk
- Subprime

**Default Stages**:
```
30 Days Past Due → 60 Days Past Due → 90+ Days Past Due → Default → Foreclosure → Resolution
```

---

### 5. Securities & Capital Markets Domain

**Purpose**: Manage securitization, secondary market sales, and market data.

**Tables**:
- `Securities`: Mortgage-backed securities
- `ServicingRights`: MSR (Mortgage Servicing Rights) transfers
- `CapitalMarketData`: Market interest rates and benchmarks
- `FINRA_FI`: FINRA fixed income security details

**Key Concepts**:
- **Securitization**: Pooling loans into securities
- **MSR**: Rights to service loans sold to investors
- **Secondary Market**: Sale of loan portfolios

---

## Table Metadata

### Applications

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| ApplicationID | Unique application identifier | INTEGER | PK, AUTO_INCREMENT(10000) | System-generated |
| CustomerID | Reference to customer | INTEGER | FK → Customers | Required |
| ProductID | Loan product applied for | INTEGER | FK → MortgageProducts | Required |
| OfficerID | Assigned loan officer | INTEGER | FK → LoanOfficers | Required |
| ApplicationDate | Date application submitted | DATETIME | NOT NULL | System timestamp |
| LoanAmount | Requested loan amount | DECIMAL(15,2) | > 0 | Must be within product limits |
| LoanPurpose | Purpose of loan | TEXT | NOT NULL | Purchase, Refinance, Cash-Out |
| Status | Current application status | TEXT | NOT NULL | See Application Lifecycle |
| ClosingDate | Expected/actual closing date | DATE | NULL | NULL until approved |
| ApplicationFee | Fee charged for application | DECIMAL(10,2) | >= 0 | Default varies by product |
| DTI | Debt-to-Income ratio | DECIMAL(5,2) | 0-100 | Calculated: (Monthly Debt / Monthly Income) × 100 |
| PropertyValue | Appraised property value | DECIMAL(15,2) | > 0 | From appraisal |
| LTV | Loan-to-Value ratio | DECIMAL(5,2) | 0-100 | Calculated: (Loan Amount / Property Value) × 100 |
| RateOffered | Interest rate offered | DECIMAL(5,3) | > 0 | Based on risk profile |
| TermOffered | Loan term in months | INTEGER | > 0 | Common: 180, 360 |
| DenialReason | Reason if denied | TEXT | NULL | Required if Status = 'Denied' |

**Business Rules**:
- DTI typically must be ≤ 43% for qualified mortgages
- LTV typically must be ≤ 80% to avoid PMI (or ≤ 97% with PMI)
- Application fee is non-refundable

---

### Customers

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| CustomerID | Unique customer identifier | INTEGER | PK, AUTO_INCREMENT(1000) | System-generated |
| FirstName | Customer first name | TEXT | NOT NULL | |
| LastName | Customer last name | TEXT | NOT NULL | |
| SSN | Social Security Number | TEXT | UNIQUE, NOT NULL | Format: XXX-XX-XXXX |
| DateOfBirth | Date of birth | DATE | NOT NULL | Must be 18+ years old |
| Email | Email address | TEXT | UNIQUE | Valid email format |
| Phone | Phone number | TEXT | | Format: (XXX) XXX-XXXX |
| AnnualIncome | Gross annual income | DECIMAL(15,2) | >= 0 | Used in DTI calculation |
| EmploymentStatus | Current employment status | TEXT | | Employed, Self-Employed, Retired, Unemployed |
| Employer | Current employer name | TEXT | | Required if EmploymentStatus = 'Employed' |
| YearsEmployed | Years with current employer | INTEGER | >= 0 | Used in stability assessment |
| CreditScore | FICO credit score | INTEGER | 300-850 | Most recent score |
| CreatedDate | Record creation timestamp | DATETIME | NOT NULL | System-generated |
| LastUpdatedDate | Last modification timestamp | DATETIME | | System-maintained |

**Business Rules**:
- SSN must be validated for format and uniqueness
- Credit score must be refreshed every 90 days for active applications
- Minimum 2 years employment history preferred

---

### Loans

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| LoanID | Unique loan identifier | INTEGER | PK, AUTO_INCREMENT(100000) | System-generated |
| ApplicationID | Source application | INTEGER | FK → Applications, UNIQUE | One loan per application |
| CustomerID | Borrower | INTEGER | FK → Customers | Required |
| PropertyID | Collateral property | INTEGER | FK → PropertyDetails | Required |
| ProductID | Loan product type | INTEGER | FK → MortgageProducts | Required |
| LoanAmount | Principal loan amount | DECIMAL(15,2) | > 0 | From approved application |
| InterestRate | Annual interest rate | DECIMAL(5,3) | > 0 | Fixed or adjustable |
| Term | Loan term in months | INTEGER | > 0 | Common: 180, 360 |
| OriginationDate | Loan funding date | DATE | NOT NULL | Closing date |
| MaturityDate | Final payment date | DATE | NOT NULL | Calculated from Term |
| MonthlyPayment | P&I payment amount | DECIMAL(12,2) | > 0 | Calculated via amortization |
| RemainingBalance | Current outstanding balance | DECIMAL(15,2) | >= 0 | Updated with each payment |
| Status | Current loan status | TEXT | NOT NULL | See Loan Status Values |
| EscrowRequired | Escrow account required | BOOLEAN | NOT NULL | Default TRUE for LTV > 80% |
| PMIRequired | PMI required | BOOLEAN | NOT NULL | TRUE if LTV > 80% |
| PMIAmount | Monthly PMI payment | DECIMAL(10,2) | >= 0 | NULL if PMIRequired = FALSE |
| FirstPaymentDate | Date of first payment | DATE | NOT NULL | Typically 30-45 days after closing |
| NextPaymentDate | Next scheduled payment | DATE | | Updated after each payment |
| PaymentFrequency | Payment schedule | TEXT | NOT NULL | Monthly, Biweekly |
| SecurityID | Associated security | INTEGER | FK → Securities | NULL if not securitized |
| LastUpdatedDate | Last modification date | DATE | | System-maintained |

**Business Rules**:
- Monthly payment calculated using standard amortization formula
- PMI automatically removed when LTV reaches 78%
- Late fees applied after 15-day grace period
- Escrow analysis performed annually

---

### Payments

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| PaymentID | Unique payment identifier | INTEGER | PK, AUTO_INCREMENT | System-generated |
| LoanID | Associated loan | INTEGER | FK → Loans | Required |
| PaymentDate | Date payment received | DATE | NOT NULL | Transaction date |
| PaymentAmount | Total payment amount | DECIMAL(12,2) | > 0 | Total received |
| PrincipalAmount | Amount to principal | DECIMAL(12,2) | >= 0 | Per amortization schedule |
| InterestAmount | Amount to interest | DECIMAL(12,2) | >= 0 | Per amortization schedule |
| EscrowAmount | Amount to escrow | DECIMAL(12,2) | >= 0 | If escrow account exists |
| LateFeeAmount | Late fee charged | DECIMAL(10,2) | >= 0 | Applied per policy |
| PaymentMethod | Method of payment | TEXT | NOT NULL | ACH, Check, Wire, Online |
| TransactionID | External transaction ref | TEXT | UNIQUE | From payment processor |
| PaymentStatus | Payment processing status | TEXT | NOT NULL | Pending, Cleared, Returned, Failed |
| ProcessedDate | Date payment processed | DATETIME | | System timestamp |

**Payment Allocation Logic**:
1. Late fees (if any)
2. Interest for the period
3. Principal
4. Escrow (if applicable)

---

### PropertyDetails

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| PropertyID | Unique property identifier | INTEGER | PK, AUTO_INCREMENT | System-generated |
| AddressLine1 | Street address | TEXT | NOT NULL | |
| AddressLine2 | Apt/Suite/Unit | TEXT | | |
| City | City | TEXT | NOT NULL | |
| State | State code | TEXT | NOT NULL | 2-character code |
| ZipCode | ZIP/Postal code | TEXT | NOT NULL | Format: XXXXX or XXXXX-XXXX |
| Country | Country | TEXT | DEFAULT 'USA' | |
| PropertyType | Type of property | TEXT | NOT NULL | Single Family, Condo, Townhouse, Multi-Family |
| YearBuilt | Year constructed | INTEGER | > 1800 | |
| SquareFeet | Livable square footage | INTEGER | > 0 | |
| Bedrooms | Number of bedrooms | INTEGER | >= 0 | |
| Bathrooms | Number of bathrooms | DECIMAL(3,1) | >= 0 | Includes half baths (0.5) |
| PurchasePrice | Original purchase price | DECIMAL(15,2) | > 0 | Historical |
| CurrentValue | Current market value | DECIMAL(15,2) | > 0 | Estimated or appraised |
| LastAppraisalDate | Date of last appraisal | DATE | | |
| LastAppraisalValue | Last appraised value | DECIMAL(15,2) | > 0 | From certified appraiser |
| TaxAssessmentValue | Tax assessment value | DECIMAL(15,2) | >= 0 | From county assessor |
| AnnualTaxAmount | Annual property taxes | DECIMAL(10,2) | >= 0 | Used for escrow calculation |
| HOAFees | Monthly HOA fees | DECIMAL(10,2) | >= 0 | If applicable |
| FloodZone | FEMA flood zone | TEXT | | A, AE, X, etc. |
| PropertyTaxID | Tax parcel ID | TEXT | | County identifier |
| Latitude | GPS latitude | DECIMAL(9,6) | | For mapping |
| Longitude | GPS longitude | DECIMAL(9,6) | | For mapping |

**Business Rules**:
- Appraisal must be < 120 days old for loan approval
- Flood insurance required for zones A, AE, AO, AH, A1-A30
- Property tax escrow = AnnualTaxAmount / 12

---

### EscrowAccounts

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| EscrowID | Unique escrow identifier | INTEGER | PK, AUTO_INCREMENT | System-generated |
| LoanID | Associated loan | INTEGER | FK → Loans, UNIQUE | One escrow per loan |
| CurrentBalance | Current escrow balance | DECIMAL(12,2) | >= 0 | Updated with transactions |
| PropertyTaxAmount | Monthly tax portion | DECIMAL(12,2) | >= 0 | Annual tax / 12 |
| PropertyInsuranceAmount | Monthly insurance portion | DECIMAL(12,2) | >= 0 | Annual premium / 12 |
| PMIAmount | Monthly PMI portion | DECIMAL(12,2) | >= 0 | If applicable |
| CushionAmount | Required cushion/reserve | DECIMAL(12,2) | >= 0 | Typically 2 months expenses |
| LastAnalysisDate | Date of last escrow analysis | DATE | | Annual review required |
| NextAnalysisDate | Next scheduled analysis | DATE | | 12 months from last |
| MonthlyContribution | Total monthly escrow payment | DECIMAL(12,2) | >= 0 | Sum of all portions |
| ShortageAmount | Current shortage | DECIMAL(12,2) | >= 0 | If balance insufficient |

**Escrow Analysis Rules**:
- Performed annually per RESPA requirements
- Minimum balance = 1/6 of annual disbursements
- Shortage spread over 12 months if > $50
- Surplus refunded if > $50

---

### Securities

| Attribute | Description | Data Type | Constraints | Business Logic |
|-----------|-------------|-----------|-------------|----------------|
| SecurityID | Unique security identifier | INTEGER | PK, AUTO_INCREMENT | System-generated |
| SecurityName | Security name/description | TEXT | NOT NULL | |
| SecurityType | Type of security | TEXT | NOT NULL | MBS, CMO, Pass-Through, ABS |
| CUSIP | CUSIP identifier | TEXT | UNIQUE | 9-character identifier |
| IssueDate | Date security issued | DATE | NOT NULL | |
| MaturityDate | Maturity date | DATE | NOT NULL | |
| CouponRate | Interest rate | DECIMAL(5,3) | >= 0 | Annual rate |
| FaceValue | Original principal value | DECIMAL(15,2) | > 0 | Par value |
| CurrentBalance | Current outstanding balance | DECIMAL(15,2) | >= 0 | Decreases with prepayments |
| Issuer | Issuing entity | TEXT | NOT NULL | Fannie Mae, Freddie Mac, Ginnie Mae, Private |
| Rating | Credit rating | TEXT | | AAA, AA, A, BBB, etc. |
| Status | Security status | TEXT | NOT NULL | Active, Matured, Called |
| LastTradeDate | Last transaction date | DATE | | |
| LastTradePrice | Last traded price | DECIMAL(10,3) | | Percentage of par |

**Security Valuation**:
- Market value = Current Balance × (Last Trade Price / 100)
- Prepayment risk impacts pricing
- Interest rate sensitivity (duration)

---

## Data Dictionary

### Status Enumerations

#### Application.Status
- `Submitted` - Initial application received
- `Under Review` - Being reviewed by loan officer
- `Documentation` - Awaiting additional documents
- `Underwriting` - In underwriting process
- `Approved` - Approved for funding
- `Denied` - Application denied
- `Withdrawn` - Withdrawn by applicant
- `Closed` - Loan funded or application expired

#### Loan.Status
- `Active` - Currently being serviced
- `Current` - Payments up to date
- `Delinquent` - Past due
- `Default` - In default status
- `Foreclosure` - Foreclosure proceedings
- `Paid Off` - Fully satisfied
- `Refinanced` - Replaced by new loan
- `Sold` - Sold to another servicer

#### Payment.Status
- `Pending` - Payment initiated
- `Cleared` - Payment successfully processed
- `Returned` - Payment returned (NSF)
- `Failed` - Payment processing failed
- `Reversed` - Payment reversed

### Property Types
- `Single Family` - Detached single-family home
- `Condo` - Condominium unit
- `Townhouse` - Attached townhouse
- `Multi-Family` - 2-4 unit property
- `PUD` - Planned Unit Development
- `Co-op` - Cooperative housing

### Employment Status
- `Employed` - W-2 employee
- `Self-Employed` - 1099/Business owner
- `Retired` - Retired with pension/investments
- `Unemployed` - Currently unemployed
- `Student` - Full-time student
- `Disability` - Receiving disability benefits

### Address Types
- `Primary` - Primary residence
- `Mailing` - Mailing address
- `Work` - Business address
- `Previous` - Former address

### Payment Methods
- `ACH` - Electronic bank transfer
- `Check` - Paper check
- `Wire` - Wire transfer
- `Online` - Online payment portal
- `Auto Pay` - Automatic payment
- `Cash` - Cash payment

---

## Business Rules & Constraints

### Loan Origination Rules

1. **Qualifying Ratios**
   - Front-end ratio (Housing / Income): ≤ 28%
   - Back-end ratio (Total Debt / Income): ≤ 43%
   - Exceptions allowed with compensating factors

2. **Down Payment Requirements**
   - Conventional: Minimum 3% down
   - FHA: Minimum 3.5% down
   - VA: 0% down for qualified veterans
   - Jumbo: Minimum 10-20% down

3. **Credit Score Requirements**
   | Product Type | Minimum Score |
   |--------------|---------------|
   | Conventional | 620 |
   | FHA | 580 |
   | VA | 580 |
   | Jumbo | 700 |

4. **Documentation Requirements**
   - Pay stubs (last 2 months)
   - W-2s (last 2 years)
   - Tax returns (last 2 years for self-employed)
   - Bank statements (last 2 months)
   - Credit report (< 90 days old)
   - Appraisal (< 120 days old)

### Payment Processing Rules

1. **Payment Application Order**
   ```
   1. Late fees and charges
   2. Escrow shortage
   3. Interest (current period)
   4. Principal
   5. Escrow (current month)
   ```

2. **Grace Period**: 15 days from due date
3. **Late Fee**: Lesser of 5% of payment or $50
4. **Returned Payment Fee**: $25-35

### Escrow Rules (RESPA Compliance)

1. **Initial Escrow Deposit**
   - Up to 2 months of property taxes
   - Up to 2 months of insurance premiums
   - Cannot exceed minimum balance + 1 month cushion

2. **Annual Escrow Analysis**
   - Required within 30 days of anniversary
   - Surplus > $50: Refund to borrower
   - Shortage: Spread over 12 months or lump sum option

3. **Cushion Limits**
   - Maximum: 2 months of escrow payments
   - Minimum: 1/6 of annual disbursements

---

## Data Lineage

### Source to Target Mappings

#### Loan Origination Flow
```
Application Entry
    ↓
Customer Creation (if new)
    ↓
Risk Assessment
    ↓
Document Collection
    ↓
Underwriting Decision
    ↓
Loan Creation (if approved)
    ↓
First Payment Setup
```

#### Payment Processing Flow
```
Payment Receipt
    ↓
Payment Record Creation
    ↓
Balance Update (Loans.RemainingBalance)
    ↓
Escrow Transaction (if applicable)
    ↓
Next Payment Date Calculation
```

#### Securitization Flow
```
Loan Pool Selection
    ↓
Security Creation
    ↓
Loan.SecurityID Assignment
    ↓
Servicing Rights Creation
    ↓
MSR Valuation
```

### Data Refresh Schedules

| Entity | Frequency | Source | Method |
|--------|-----------|--------|--------|
| Credit Scores | Every 90 days | Credit Bureaus | API pull |
| Property Values | Quarterly | AVMs/CMAs | Batch update |
| Market Rates | Daily | CapitalMarketData | Feed import |
| Escrow Balances | Real-time | Payment processing | Transaction-based |
| Security Prices | Daily | Market data vendors | File import |

---

## Performance Considerations

### Recommended Indexes

```sql
-- Customer lookups
CREATE INDEX idx_customers_ssn ON Customers(SSN);
CREATE INDEX idx_customers_email ON Customers(Email);

-- Application searches
CREATE INDEX idx_applications_customer ON Applications(CustomerID);
CREATE INDEX idx_applications_status ON Applications(Status);
CREATE INDEX idx_applications_date ON Applications(ApplicationDate);

-- Loan portfolio queries
CREATE INDEX idx_loans_customer ON Loans(CustomerID);
CREATE INDEX idx_loans_status ON Loans(Status);
CREATE INDEX idx_loans_nextpayment ON Loans(NextPaymentDate);
CREATE INDEX idx_loans_security ON Loans(SecurityID);

-- Payment history
CREATE INDEX idx_payments_loan ON Payments(LoanID);
CREATE INDEX idx_payments_date ON Payments(PaymentDate);
CREATE INDEX idx_payments_status ON Payments(PaymentStatus);

-- Property searches
CREATE INDEX idx_property_zipcode ON PropertyDetails(ZipCode);
CREATE INDEX idx_property_city_state ON PropertyDetails(City, State);

-- Escrow processing
CREATE INDEX idx_escrow_loan ON EscrowAccounts(LoanID);
CREATE INDEX idx_escrow_transactions_date ON EscrowTransactions(TransactionDate);

-- Securities
CREATE INDEX idx_securities_cusip ON Securities(CUSIP);
CREATE INDEX idx_securities_type ON Securities(SecurityType);
```

### Query Optimization Tips

1. **Use covering indexes** for frequently accessed column combinations
2. **Partition large tables** (Payments, AuditLog) by date ranges
3. **Implement read replicas** for reporting queries
4. **Cache reference data** (Products, InterestType) in application layer
5. **Archive historical data** older than 7 years per retention policy

### Table Size Estimates

| Table | Annual Growth | 5-Year Volume | Storage |
|-------|---------------|---------------|---------|
| Applications | 10,000 rows | 50,000 | 50 MB |
| Loans | 7,000 rows | 35,000 | 75 MB |
| Payments | 300,000 rows | 1,500,000 | 500 MB |
| AuditLog | 500,000 rows | 2,500,000 | 2 GB |

---

## Data Governance

### Data Retention Policy

| Data Category | Retention Period | Archive Method |
|---------------|------------------|----------------|
| Active loans | Duration + 7 years | Online |
| Paid-off loans | 7 years | Cold storage |
| Applications (denied) | 3 years | Cold storage |
| Payment history | Loan duration + 7 years | Online → Archive |
| Audit logs | 7 years | Compressed archive |
| Customer PII | 7 years after last activity | Encrypted storage |

### Data Security Classification

| Classification | Tables | Protection |
|----------------|--------|-----------|
| **Highly Sensitive** | Customers (SSN), AuditLog | Encryption at rest & transit, Audit all access |
| **Sensitive** | Applications, Loans, Payments | Encryption at rest, Role-based access |
| **Internal** | PropertyDetails, EscrowAccounts | Role-based access |
| **Public** | MortgageProducts, CapitalMarketData | Standard access controls |

### PII Fields Requiring Protection

- Customers.SSN (encrypt)
- Customers.DateOfBirth (encrypt)
- CustomerAddresses.* (mask in non-prod)
- PropertyDetails.AddressLine1 (mask in non-prod)
- AuditLog.IPAddress (hash)

---

## Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-07 | Data Team | Initial metadata documentation |

---

## References

- [Clay Database Documentation](https://clay.run/docs)
- RESPA Guidelines (12 CFR Part 1024)
- TILA Requirements (15 U.S.C. §1601)
- FINRA Fixed Income Reference
- Mortgage Industry Standards Maintenance Organization (MISMO)

---

## Contact

For questions about this database schema or metadata:
- **Data Architecture Team**: data-architecture@xyzfinancials.com
- **Database Administration**: dba@xyzfinancials.com
- **Business Analysts**: business-analysis@xyzfinancials.com