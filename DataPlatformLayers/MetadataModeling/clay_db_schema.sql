-- Applications Table
CREATE TABLE Applications (
  ApplicationID INTEGER PRIMARY KEY AUTOINCREMENT START 10000,
  CustomerID INTEGER,
  ProductID INTEGER,
  OfficerID INTEGER,
  ApplicationDate DATETIME,
  LoanAmount DECIMAL(15, 2),
  LoanPurpose TEXT,
  Status TEXT,
  ClosingDate DATE,
  ApplicationFee DECIMAL(10, 2),
  DTI DECIMAL(5, 2),
  PropertyValue DECIMAL(15, 2),
  LTV DECIMAL(5, 2),
  RateOffered DECIMAL(5, 3),
  TermOffered INTEGER,
  DenialReason TEXT
);

-- Audit Log Table
CREATE TABLE AuditLog (
  LogID INTEGER PRIMARY KEY AUTOINCREMENT,
  EntityType TEXT,
  EntityID INTEGER,
  ActionType TEXT,
  ActionDateTime DATETIME,
  UserID TEXT,
  OldValues TEXT,
  NewValues TEXT,
  IPAddress TEXT,
  ApplicationName TEXT
);

-- Capital Market Data Table
CREATE TABLE CapitalMarketData (
  MarketDataID INTEGER PRIMARY KEY AUTOINCREMENT,
  DataDate DATE,
  DataSource TEXT,
  Treasury10Y DECIMAL(5, 3),
  FedFundsRate DECIMAL(5, 3),
  LIBOR3M DECIMAL(5, 3),
  SOFR DECIMAL(5, 3),
  MBS30YRate DECIMAL(5, 3),
  Fannie30YRate DECIMAL(5, 3),
  Freddie30YRate DECIMAL(5, 3),
  EffectiveDateStart DATE,
  EffectiveDateEnd DATE
);

-- Customer Addresses Table
CREATE TABLE CustomerAddresses (
  AddressID INTEGER PRIMARY KEY AUTOINCREMENT,
  CustomerID INTEGER,
  AddressType TEXT,
  AddressLine1 TEXT,
  AddressLine2 TEXT,
  City TEXT,
  State TEXT,
  ZipCode TEXT,
  Country TEXT,
  StartDate DATE,
  EndDate DATE
);

-- Customers Table
CREATE TABLE Customers (
  CustomerID INTEGER PRIMARY KEY AUTOINCREMENT START 1000,
  FirstName TEXT,
  LastName TEXT,
  SSN TEXT,
  DateOfBirth DATE,
  Email TEXT,
  Phone TEXT,
  AnnualIncome DECIMAL(15, 2),
  EmploymentStatus TEXT,
  Employer TEXT,
  YearsEmployed INTEGER,
  CreditScore INTEGER,
  CreatedDate DATETIME,
  LastUpdatedDate DATETIME
);

-- Defaults and Foreclosures Table
CREATE TABLE DefaultsForeclosures (
  DefaultID INTEGER PRIMARY KEY AUTOINCREMENT,
  LoanID INTEGER,
  DefaultDate DATE,
  Stage TEXT,
  ReasonCode TEXT,
  ResolutionType TEXT,
  ResolutionDate DATE,
  LossAmount DECIMAL(15, 2),
  CollectionAgency TEXT,
  LegalFilingDate DATE,
  LegalCaseNumber TEXT,
  Notes TEXT
);

-- Documents Registry Table
CREATE TABLE DocumentsRegistry (
  DocumentID INTEGER PRIMARY KEY AUTOINCREMENT,
  ApplicationID INTEGER,
  DocumentType TEXT,
  FileName TEXT,
  FileLocation TEXT,
  UploadDate DATETIME,
  RequiredFlag BOOLEAN,
  ReceivedFlag BOOLEAN,
  ApprovalStatus TEXT,
  ApprovalDate DATETIME,
  ApprovedBy TEXT,
  Notes TEXT
);

-- Escrow Accounts Table
CREATE TABLE EscrowAccounts (
  EscrowID INTEGER PRIMARY KEY AUTOINCREMENT,
  LoanID INTEGER,
  CurrentBalance DECIMAL(12, 2),
  PropertyTaxAmount DECIMAL(12, 2),
  PropertyInsuranceAmount DECIMAL(12, 2),
  PMIAmount DECIMAL(12, 2),
  CushionAmount DECIMAL(12, 2),
  LastAnalysisDate DATE,
  NextAnalysisDate DATE,
  MonthlyContribution DECIMAL(12, 2),
  ShortageAmount DECIMAL(12, 2)
);

-- Escrow Transactions Table
CREATE TABLE EscrowTransactions (
  TransactionID INTEGER PRIMARY KEY AUTOINCREMENT,
  EscrowID INTEGER,
  TransactionDate DATE,
  TransactionType TEXT,
  Amount DECIMAL(12, 2),
  Description TEXT,
  Reference TEXT
);

-- FINRA Fixed Income Table
CREATE TABLE FINRA_FI (
  PKID INTEGER PRIMARY KEY,
  Symbol TEXT,
  IssuerName TEXT,
  CouponType TEXT,
  CouponRate REAL,
  MaturityDate DATE,
  DealID TEXT,
  TrancheID TEXT,
  IssueDescription TEXT,
  InterestType TEXT,
  I44A BOOLEAN,
  CUSIP TEXT,
  SubProdType TEXT,
  ProdSubtype TEXT,
  ProdType TEXT,
  IssuingAgency TEXT,
  Convertible TEXT
);

-- Interest Type Table
CREATE TABLE InterestType (
  ITID INTEGER PRIMARY KEY,
  InterestTypeID TEXT,
  InterestTypeDesc TEXT
);

-- Loan Officers Table
CREATE TABLE LoanOfficers (
  OfficerID INTEGER PRIMARY KEY AUTOINCREMENT,
  FirstName TEXT,
  LastName TEXT,
  Email TEXT,
  Phone TEXT,
  BranchID INTEGER,
  HireDate DATE,
  CommissionRate DECIMAL(5, 2),
  Status TEXT
);

-- Loans Table
CREATE TABLE Loans (
  LoanID INTEGER PRIMARY KEY AUTOINCREMENT START 100000,
  ApplicationID INTEGER,
  CustomerID INTEGER,
  PropertyID INTEGER,
  ProductID INTEGER,
  LoanAmount DECIMAL(15, 2),
  InterestRate DECIMAL(5, 3),
  Term INTEGER,
  OriginationDate DATE,
  MaturityDate DATE,
  MonthlyPayment DECIMAL(12, 2),
  RemainingBalance DECIMAL(15, 2),
  Status TEXT,
  EscrowRequired BOOLEAN,
  PMIRequired BOOLEAN,
  PMIAmount DECIMAL(10, 2),
  FirstPaymentDate DATE,
  NextPaymentDate DATE,
  PaymentFrequency TEXT,
  SecurityID INTEGER,
  LastUpdatedDate DATE
);

-- Loan Term Modifications Table
CREATE TABLE LoanTermModifications (
  ModificationID INTEGER PRIMARY KEY AUTOINCREMENT,
  LoanID INTEGER,
  ModificationDate DATE,
  ModificationType TEXT,
  PreviousInterestRate DECIMAL(5, 3),
  NewInterestRate DECIMAL(5, 3),
  PreviousTerm INTEGER,
  NewTerm INTEGER,
  PreviousPayment DECIMAL(12, 2),
  NewPayment DECIMAL(12, 2),
  ModificationFee DECIMAL(10, 2),
  RequiredDocuments TEXT,
  ApprovalStatus TEXT,
  ApprovedBy TEXT,
  Notes TEXT
);

-- Mortgage Products Table
CREATE TABLE MortgageProducts (
  ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
  ProductName TEXT,
  ProductType TEXT,
  Term INTEGER,
  BaseInterestRate DECIMAL(5, 3),
  MinCreditScore INTEGER,
  MaxLTV DECIMAL(5, 2),
  MinLoanAmount DECIMAL(15, 2),
  MaxLoanAmount DECIMAL(15, 2),
  OriginationFee DECIMAL(5, 2),
  IsActive BOOLEAN
);

-- Payments Table
CREATE TABLE Payments (
  PaymentID INTEGER PRIMARY KEY AUTOINCREMENT,
  LoanID INTEGER,
  PaymentDate DATE,
  PaymentAmount DECIMAL(12, 2),
  PrincipalAmount DECIMAL(12, 2),
  InterestAmount DECIMAL(12, 2),
  EscrowAmount DECIMAL(12, 2),
  LateFeeAmount DECIMAL(10, 2),
  PaymentMethod TEXT,
  TransactionID TEXT,
  PaymentStatus TEXT,
  ProcessedDate DATETIME
);

-- Product Subtype Table
CREATE TABLE ProductSubtype (
  PTID INTEGER PRIMARY KEY,
  ProdType TEXT,
  ProdSubType TEXT,
  PSTDesc TEXT
);

-- Property Details Table
CREATE TABLE PropertyDetails (
  PropertyID INTEGER PRIMARY KEY AUTOINCREMENT,
  AddressLine1 TEXT,
  AddressLine2 TEXT,
  City TEXT,
  State TEXT,
  ZipCode TEXT,
  Country TEXT,
  PropertyType TEXT,
  YearBuilt INTEGER,
  SquareFeet INTEGER,
  Bedrooms INTEGER,
  Bathrooms DECIMAL(3, 1),
  PurchasePrice DECIMAL(15, 2),
  CurrentValue DECIMAL(15, 2),
  LastAppraisalDate DATE,
  LastAppraisalValue DECIMAL(15, 2),
  TaxAssessmentValue DECIMAL(15, 2),
  AnnualTaxAmount DECIMAL(10, 2),
  HOAFees DECIMAL(10, 2),
  FloodZone TEXT,
  PropertyTaxID TEXT,
  Latitude DECIMAL(9, 6),
  Longitude DECIMAL(9, 6)
);

-- Risk Assessments Table
CREATE TABLE RiskAssessments (
  AssessmentID INTEGER PRIMARY KEY AUTOINCREMENT,
  CustomerID INTEGER,
  ApplicationID INTEGER,
  AssessmentDate DATETIME,
  CreditScore INTEGER,
  DTI DECIMAL(5, 2),
  LTV DECIMAL(5, 2),
  FICOScoreSource TEXT,
  RiskClassification TEXT,
  RecommendedAction TEXT,
  Notes TEXT
);

-- Securities Table
CREATE TABLE Securities (
  SecurityID INTEGER PRIMARY KEY AUTOINCREMENT,
  SecurityName TEXT,
  SecurityType TEXT,
  CUSIP TEXT,
  IssueDate DATE,
  MaturityDate DATE,
  CouponRate DECIMAL(5, 3),
  FaceValue DECIMAL(15, 2),
  CurrentBalance DECIMAL(15, 2),
  Issuer TEXT,
  Rating TEXT,
  Status TEXT,
  LastTradeDate DATE,
  LastTradePrice DECIMAL(10, 3)
);

-- Servicing Rights Table
CREATE TABLE ServicingRights (
  ServicingID INTEGER PRIMARY KEY AUTOINCREMENT,
  LoanID INTEGER,
  ServicerName TEXT,
  ServicerID INTEGER,
  TransferDate DATE,
  MSRValue DECIMAL(15, 2),
  ServicingFee DECIMAL(5, 3),
  SubservicerName TEXT,
  TransferReason TEXT
);