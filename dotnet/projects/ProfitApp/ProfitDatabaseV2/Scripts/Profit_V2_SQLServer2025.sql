/*
================================================================================
 PROFIT V2 - SQL SERVER 2025
 ERP MULTI-COMPANY: SALES / PROCUREMENT / INVENTORY / FINANCE / HR
================================================================================
 Design principles:
   * Plural table names.
   * Functional schemas.
   * UTC datetime2.
   * decimal instead of money.
   * rowversion for optimistic concurrency.
   * Centralized Audit.AuditLog.
   * SQL Server session context for application identity.
   * Multi-company integrity through composite foreign keys.
   * Schema-based permissions and company-level Row-Level Security.
   * Posted financial documents are not physically deleted.

 IMPORTANT:
   1. Run this script as a SQL Server administrator.
   2. Set the SQLCMD variable ProfitAppPassword to a strong secret before
      production execution, or replace the placeholder in the CREATE LOGIN
      statement.
   3. The script creates a SQL login named ProfitApp. In production, consider
      using Microsoft Entra/Windows authentication instead.
================================================================================
*/

USE [master];
GO

IF DB_ID(N'Profit') IS NULL
BEGIN
    CREATE DATABASE [Profit];
END;
GO

ALTER DATABASE [Profit] SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;
GO

USE [Profit];
GO

/* ---------------------------------------------------------------------------
   Schemas
--------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Core')       EXEC(N'CREATE SCHEMA [Core]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'CRM')        EXEC(N'CREATE SCHEMA [CRM]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Sales')      EXEC(N'CREATE SCHEMA [Sales]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Procurement')EXEC(N'CREATE SCHEMA [Procurement]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Inventory')  EXEC(N'CREATE SCHEMA [Inventory]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Finance')   EXEC(N'CREATE SCHEMA [Finance]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'HR')        EXEC(N'CREATE SCHEMA [HR]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Security')  EXEC(N'CREATE SCHEMA [Security]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Reference') EXEC(N'CREATE SCHEMA [Reference]');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Audit')     EXEC(N'CREATE SCHEMA [Audit]');
GO

/* ---------------------------------------------------------------------------
   Server login / database user
   NOTE: Change this password before production use.
--------------------------------------------------------------------------- */
USE [master];
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'ProfitApp')
BEGIN
    CREATE LOGIN [ProfitApp]
        WITH PASSWORD = N'ChangeThis_ProfitV2_2026!9xQ#7mP',
             CHECK_POLICY = ON,
             CHECK_EXPIRATION = OFF,
             DEFAULT_DATABASE = [Profit];
END;
GO

USE [Profit];
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ProfitApp')
BEGIN
    CREATE USER [ProfitApp] FOR LOGIN [ProfitApp];
END;
GO

/* ---------------------------------------------------------------------------
   Database roles
--------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_ReadOnly') CREATE ROLE [ERP_ReadOnly];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_Sales') CREATE ROLE [ERP_Sales];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_Procurement') CREATE ROLE [ERP_Procurement];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_Inventory') CREATE ROLE [ERP_Inventory];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_Finance') CREATE ROLE [ERP_Finance];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_HR') CREATE ROLE [ERP_HR];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_Auditor') CREATE ROLE [ERP_Auditor];
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'ERP_Admin') CREATE ROLE [ERP_Admin];
GO

/* Do not make the application login db_owner. */
ALTER ROLE [ERP_ReadOnly] ADD MEMBER [ProfitApp];
GO

/* ---------------------------------------------------------------------------
   Security metadata
--------------------------------------------------------------------------- */
CREATE TABLE [Security].[Users]
(
    UserId              int IDENTITY(1,1) NOT NULL,
    UserName            nvarchar(100) NOT NULL,
    DisplayName         nvarchar(200) NULL,
    EmailAddress        nvarchar(320) NULL,
    IsActive             bit NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
    CreatedAt            datetime2(3) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt            datetime2(3) NULL,
    RowVersion           rowversion NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId),
    CONSTRAINT UQ_Users_UserName UNIQUE (UserName)
);
GO

CREATE TABLE [Core].[Countries]
(
    CountryId            int IDENTITY(1,1) NOT NULL,
    IsoCode              char(2) NOT NULL,
    Name                 nvarchar(100) NOT NULL,
    IsActive              bit NOT NULL CONSTRAINT DF_Countries_IsActive DEFAULT (1),
    RowVersion            rowversion NOT NULL,
    CONSTRAINT PK_Countries PRIMARY KEY CLUSTERED (CountryId),
    CONSTRAINT UQ_Countries_IsoCode UNIQUE (IsoCode),
    CONSTRAINT UQ_Countries_Name UNIQUE (Name)
);
GO

CREATE TABLE [Core].[States]
(
    StateId              int IDENTITY(1,1) NOT NULL,
    CountryId            int NOT NULL,
    Code                 nvarchar(20) NULL,
    Name                 nvarchar(100) NOT NULL,
    IsActive              bit NOT NULL CONSTRAINT DF_States_IsActive DEFAULT (1),
    RowVersion            rowversion NOT NULL,
    CONSTRAINT PK_States PRIMARY KEY CLUSTERED (StateId),
    CONSTRAINT UQ_States_Country_Name UNIQUE (CountryId, Name)
);
GO

CREATE TABLE [Core].[Currencies]
(
    CurrencyId           int IDENTITY(1,1) NOT NULL,
    IsoCode              char(3) NOT NULL,
    Name                 nvarchar(100) NOT NULL,
    Symbol               nvarchar(10) NULL,
    DecimalPlaces        tinyint NOT NULL CONSTRAINT DF_Currencies_DecimalPlaces DEFAULT (2),
    IsActive              bit NOT NULL CONSTRAINT DF_Currencies_IsActive DEFAULT (1),
    RowVersion            rowversion NOT NULL,
    CONSTRAINT PK_Currencies PRIMARY KEY CLUSTERED (CurrencyId),
    CONSTRAINT UQ_Currencies_IsoCode UNIQUE (IsoCode),
    CONSTRAINT CK_Currencies_DecimalPlaces CHECK (DecimalPlaces BETWEEN 0 AND 6)
);
GO

CREATE TABLE [Core].[Companies]
(
    CompanyId             int IDENTITY(1,1) NOT NULL,
    LegalName             nvarchar(200) NOT NULL,
    TradeName             nvarchar(200) NULL,
    TaxIdentificationNumber nvarchar(50) NULL,
    Address               nvarchar(300) NULL,
    City                  nvarchar(100) NULL,
    StateId               int NULL,
    CountryId             int NOT NULL,
    PostalCode            nvarchar(25) NULL,
    Phone                 nvarchar(40) NULL,
    Website               nvarchar(500) NULL,
    EmailAddress          nvarchar(320) NULL,
    BaseCurrencyId        int NOT NULL,
    CultureCode           nvarchar(20) NOT NULL CONSTRAINT DF_Companies_CultureCode DEFAULT (N'en-US'),
    TaxRate               decimal(9,4) NULL,
    DefaultDiscountRate   decimal(9,4) NULL,
    IsActive              bit NOT NULL CONSTRAINT DF_Companies_IsActive DEFAULT (1),
    RowVersion            rowversion NOT NULL,
    CONSTRAINT PK_Companies PRIMARY KEY CLUSTERED (CompanyId),
    CONSTRAINT UQ_Companies_TaxId UNIQUE (TaxIdentificationNumber),
    CONSTRAINT CK_Companies_TaxRate CHECK (TaxRate IS NULL OR TaxRate >= 0),
    CONSTRAINT CK_Companies_DiscountRate CHECK (DefaultDiscountRate IS NULL OR DefaultDiscountRate >= 0)
);
GO

CREATE TABLE [Core].[ExchangeRates]
(
    ExchangeRateId        bigint IDENTITY(1,1) NOT NULL,
    CompanyId             int NOT NULL,
    CurrencyId            int NOT NULL,
    EffectiveDate         date NOT NULL,
    Rate                  decimal(19,8) NOT NULL,
    Source                nvarchar(100) NULL,
    RowVersion            rowversion NOT NULL,
    CONSTRAINT PK_ExchangeRates PRIMARY KEY CLUSTERED (ExchangeRateId),
    CONSTRAINT UQ_ExchangeRates UNIQUE (CompanyId, CurrencyId, EffectiveDate),
    CONSTRAINT CK_ExchangeRates_Rate CHECK (Rate > 0)
);
GO

CREATE TABLE [Core].[FiscalYears]
(
    FiscalYearId          int IDENTITY(1,1) NOT NULL,
    CompanyId             int NOT NULL,
    FiscalYear            smallint NOT NULL,
    StartDate             date NOT NULL,
    EndDate               date NOT NULL,
    IsClosed              bit NOT NULL CONSTRAINT DF_FiscalYears_IsClosed DEFAULT (0),
    RowVersion            rowversion NOT NULL,
    CONSTRAINT PK_FiscalYears PRIMARY KEY CLUSTERED (FiscalYearId),
    CONSTRAINT UQ_FiscalYears UNIQUE (CompanyId, FiscalYear),
    CONSTRAINT CK_FiscalYears_Dates CHECK (EndDate >= StartDate)
);
GO

CREATE TABLE [Core].[AccountingPeriods]
(
    AccountingPeriodId    int IDENTITY(1,1) NOT NULL,
    CompanyId             int NOT NULL,
    FiscalYearId          int NOT NULL,
    PeriodNumber          tinyint NOT NULL,
    StartDate              date NOT NULL,
    EndDate                date NOT NULL,
    IsClosed               bit NOT NULL CONSTRAINT DF_AccountingPeriods_IsClosed DEFAULT (0),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_AccountingPeriods PRIMARY KEY CLUSTERED (AccountingPeriodId),
    CONSTRAINT UQ_AccountingPeriods UNIQUE (CompanyId, FiscalYearId, PeriodNumber),
    CONSTRAINT CK_AccountingPeriods_Number CHECK (PeriodNumber BETWEEN 1 AND 13),
    CONSTRAINT CK_AccountingPeriods_Dates CHECK (EndDate >= StartDate)
);
GO

/* ---------------------------------------------------------------------------
   Reference data
--------------------------------------------------------------------------- */
CREATE TABLE [Reference].[DocumentStatuses]
(
    DocumentStatusId      int IDENTITY(1,1) NOT NULL,
    CompanyId             int NOT NULL,
    Code                  nvarchar(30) NOT NULL,
    Name                  nvarchar(100) NOT NULL,
    IsPosted               bit NOT NULL CONSTRAINT DF_DocumentStatuses_IsPosted DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_DocumentStatuses_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_DocumentStatuses PRIMARY KEY CLUSTERED (DocumentStatusId),
    CONSTRAINT UQ_DocumentStatuses UNIQUE (CompanyId, Code)
);
GO

CREATE TABLE [Reference].[PaymentMethods]
(
    PaymentMethodId       int IDENTITY(1,1) NOT NULL,
    CompanyId             int NOT NULL,
    Code                  nvarchar(30) NOT NULL,
    Name                  nvarchar(100) NOT NULL,
    PaymentTermDays       int NOT NULL CONSTRAINT DF_PaymentMethods_Term DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_PaymentMethods_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_PaymentMethods PRIMARY KEY CLUSTERED (PaymentMethodId),
    CONSTRAINT UQ_PaymentMethods UNIQUE (CompanyId, Code),
    CONSTRAINT CK_PaymentMethods_Term CHECK (PaymentTermDays >= 0)
);
GO

CREATE TABLE [Reference].[TaxCodes]
(
    TaxCodeId             int IDENTITY(1,1) NOT NULL,
    CompanyId             int NOT NULL,
    Code                  nvarchar(30) NOT NULL,
    Name                  nvarchar(100) NOT NULL,
    Rate                  decimal(9,4) NOT NULL,
    IsRecoverable         bit NOT NULL CONSTRAINT DF_TaxCodes_Recoverable DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_TaxCodes_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_TaxCodes PRIMARY KEY CLUSTERED (TaxCodeId),
    CONSTRAINT UQ_TaxCodes UNIQUE (CompanyId, Code),
    CONSTRAINT CK_TaxCodes_Rate CHECK (Rate >= 0)
);
GO

/* ---------------------------------------------------------------------------
   CRM
--------------------------------------------------------------------------- */
CREATE TABLE [CRM].[Customers]
(
    CustomerId             int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    CustomerNumber         nvarchar(50) NOT NULL,
    LegalName              nvarchar(200) NOT NULL,
    TaxIdentificationNumber nvarchar(50) NULL,
    Address                nvarchar(300) NULL,
    City                   nvarchar(100) NULL,
    StateId                int NULL,
    CountryId              int NOT NULL,
    PostalCode             nvarchar(25) NULL,
    Phone                  nvarchar(40) NULL,
    MobilePhone            nvarchar(40) NULL,
    Website                nvarchar(500) NULL,
    EmailAddress           nvarchar(320) NULL,
    CreditLimit            decimal(19,4) NOT NULL CONSTRAINT DF_Customers_CreditLimit DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerId),
    CONSTRAINT UQ_Customers_Company_Number UNIQUE (CompanyId, CustomerId),
    CONSTRAINT UQ_Customers_Number UNIQUE (CompanyId, CustomerNumber),
    CONSTRAINT CK_Customers_CreditLimit CHECK (CreditLimit >= 0)
);
GO

CREATE TABLE [CRM].[CustomerContacts]
(
    CustomerContactId      int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    CustomerId             int NOT NULL,
    FirstName              nvarchar(100) NOT NULL,
    LastName               nvarchar(100) NOT NULL,
    JobTitle               nvarchar(100) NULL,
    TaxIdentificationNumber nvarchar(50) NULL,
    Address                nvarchar(300) NULL,
    City                   nvarchar(100) NULL,
    StateId                int NULL,
    CountryId              int NULL,
    Phone                  nvarchar(40) NULL,
    MobilePhone            nvarchar(40) NULL,
    EmailAddress           nvarchar(320) NULL,
    BirthDate              date NULL,
    IsPrimary              bit NOT NULL CONSTRAINT DF_CustomerContacts_IsPrimary DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_CustomerContacts_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_CustomerContacts PRIMARY KEY CLUSTERED (CustomerContactId),
    CONSTRAINT UQ_CustomerContacts_Company UNIQUE (CompanyId, CustomerContactId)
);
GO

CREATE UNIQUE INDEX UX_CustomerContacts_Primary
ON [CRM].[CustomerContacts](CustomerId)
WHERE IsPrimary = 1;
GO

/* ---------------------------------------------------------------------------
   HR
--------------------------------------------------------------------------- */
CREATE TABLE [HR].[Departments]
(
    DepartmentId           int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    Code                   nvarchar(30) NOT NULL,
    Name                   nvarchar(100) NOT NULL,
    Location               nvarchar(300) NULL,
    IsActive               bit NOT NULL CONSTRAINT DF_Departments_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_Departments PRIMARY KEY CLUSTERED (DepartmentId),
    CONSTRAINT UQ_Departments UNIQUE (CompanyId, Code)
);
GO

CREATE TABLE [HR].[EmployeeProfiles]
(
    EmployeeProfileId      int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    Code                   nvarchar(30) NOT NULL,
    Name                   nvarchar(100) NOT NULL,
    CommissionRate         decimal(9,4) NOT NULL CONSTRAINT DF_EmployeeProfiles_Commission DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_EmployeeProfiles_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_EmployeeProfiles PRIMARY KEY CLUSTERED (EmployeeProfileId),
    CONSTRAINT UQ_EmployeeProfiles UNIQUE (CompanyId, Code),
    CONSTRAINT CK_EmployeeProfiles_Commission CHECK (CommissionRate >= 0)
);
GO

CREATE TABLE [HR].[Employees]
(
    EmployeeId             int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    EmployeeNumber         nvarchar(50) NOT NULL,
    DepartmentId           int NOT NULL,
    EmployeeProfileId      int NULL,
    FirstName              nvarchar(100) NOT NULL,
    LastName               nvarchar(100) NOT NULL,
    JobTitle               nvarchar(100) NULL,
    TaxIdentificationNumber nvarchar(50) NULL,
    Address                nvarchar(300) NULL,
    City                   nvarchar(100) NULL,
    StateId                int NULL,
    CountryId              int NULL,
    Gender                 nvarchar(20) NULL,
    PostalCode             nvarchar(25) NULL,
    Phone                  nvarchar(40) NULL,
    MobilePhone            nvarchar(40) NULL,
    EmailAddress           nvarchar(320) NULL,
    BirthDate              date NULL,
    HireDate               date NULL,
    TerminationDate        date NULL,
    MaritalStatus          nvarchar(30) NULL,
    Salary                 decimal(19,4) NULL,
    Deductions             decimal(19,4) NULL,
    EmergencyContactName   nvarchar(200) NULL,
    EmergencyContactPhone  nvarchar(40) NULL,
    IsActive               bit NOT NULL CONSTRAINT DF_Employees_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_Employees PRIMARY KEY CLUSTERED (EmployeeId),
    CONSTRAINT UQ_Employees_Company_Number UNIQUE (CompanyId, EmployeeNumber),
    CONSTRAINT CK_Employees_Salary CHECK (Salary IS NULL OR Salary >= 0),
    CONSTRAINT CK_Employees_Deductions CHECK (Deductions IS NULL OR Deductions >= 0)
);
GO

/* ---------------------------------------------------------------------------
   Procurement
--------------------------------------------------------------------------- */
CREATE TABLE [Procurement].[Vendors]
(
    VendorId               int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorNumber           nvarchar(50) NOT NULL,
    LegalName              nvarchar(200) NOT NULL,
    TaxIdentificationNumber nvarchar(50) NULL,
    Address                nvarchar(300) NULL,
    City                   nvarchar(100) NULL,
    StateId                int NULL,
    CountryId              int NOT NULL,
    PostalCode             nvarchar(25) NULL,
    Phone                  nvarchar(40) NULL,
    MobilePhone            nvarchar(40) NULL,
    Website                nvarchar(500) NULL,
    EmailAddress           nvarchar(320) NULL,
    CreditLimit            decimal(19,4) NOT NULL CONSTRAINT DF_Vendors_CreditLimit DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_Vendors_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_Vendors PRIMARY KEY CLUSTERED (VendorId),
    CONSTRAINT UQ_Vendors_Company_Number UNIQUE (CompanyId, VendorId),
    CONSTRAINT UQ_Vendors_Number UNIQUE (CompanyId, VendorNumber),
    CONSTRAINT CK_Vendors_CreditLimit CHECK (CreditLimit >= 0)
);
GO

CREATE TABLE [Procurement].[VendorContacts]
(
    VendorContactId        int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorId               int NOT NULL,
    FirstName              nvarchar(100) NOT NULL,
    LastName               nvarchar(100) NOT NULL,
    JobTitle               nvarchar(100) NULL,
    TaxIdentificationNumber nvarchar(50) NULL,
    Address                nvarchar(300) NULL,
    City                   nvarchar(100) NULL,
    StateId                int NULL,
    CountryId              int NULL,
    Phone                  nvarchar(40) NULL,
    MobilePhone            nvarchar(40) NULL,
    EmailAddress           nvarchar(320) NULL,
    IsPrimary              bit NOT NULL CONSTRAINT DF_VendorContacts_IsPrimary DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_VendorContacts_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_VendorContacts PRIMARY KEY CLUSTERED (VendorContactId),
    CONSTRAINT UQ_VendorContacts_Company UNIQUE (CompanyId, VendorContactId)
);
GO

CREATE UNIQUE INDEX UX_VendorContacts_Primary
ON [Procurement].[VendorContacts](VendorId)
WHERE IsPrimary = 1;
GO

CREATE TABLE [Procurement].[PurchaseOrders]
(
    PurchaseOrderId        bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorId               int NOT NULL,
    EmployeeId             int NULL,
    CurrencyId             int NOT NULL,
    PaymentMethodId        int NULL,
    OrderNumber            nvarchar(50) NOT NULL,
    OrderDate              date NOT NULL,
    StatusCode             nvarchar(30) NOT NULL,
    ExpectedDate            date NULL,
    Subtotal               decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrders_Subtotal DEFAULT (0),
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrders_Discount DEFAULT (0),
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrders_Tax DEFAULT (0),
    OtherCharges           decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrders_OtherCharges DEFAULT (0),
    TotalAmount            decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrders_Total DEFAULT (0),
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_PurchaseOrders_ExchangeRate DEFAULT (1),
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_PurchaseOrders PRIMARY KEY CLUSTERED (PurchaseOrderId),
    CONSTRAINT UQ_PurchaseOrders_Number UNIQUE (CompanyId, OrderNumber),
    CONSTRAINT CK_PurchaseOrders_Amounts CHECK (Subtotal >= 0 AND DiscountAmount >= 0 AND TaxAmount >= 0 AND OtherCharges >= 0 AND TotalAmount >= 0),
    CONSTRAINT CK_PurchaseOrders_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Procurement].[PurchaseOrderLines]
(
    PurchaseOrderLineId    bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    PurchaseOrderId        bigint NOT NULL,
    LineNumber             int NOT NULL,
    ProductId              int NULL,
    Description            nvarchar(500) NOT NULL,
    Quantity               decimal(19,6) NOT NULL,
    UnitPrice              decimal(19,4) NOT NULL,
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrderLines_Discount DEFAULT (0),
    TaxCodeId              int NULL,
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_PurchaseOrderLines_Tax DEFAULT (0),
    LineTotal               decimal(19,4) NOT NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_PurchaseOrderLines PRIMARY KEY CLUSTERED (PurchaseOrderLineId),
    CONSTRAINT UQ_PurchaseOrderLines_Line UNIQUE (PurchaseOrderId, LineNumber),
    CONSTRAINT CK_PurchaseOrderLines_Qty CHECK (Quantity > 0),
    CONSTRAINT CK_PurchaseOrderLines_Price CHECK (UnitPrice >= 0),
    CONSTRAINT CK_PurchaseOrderLines_Discount CHECK (DiscountAmount >= 0)
);
GO

CREATE TABLE [Procurement].[VendorInvoices]
(
    VendorInvoiceId        bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorId               int NOT NULL,
    PurchaseOrderId        bigint NULL,
    CurrencyId             int NOT NULL,
    PaymentMethodId        int NULL,
    InvoiceNumber          nvarchar(80) NOT NULL,
    InvoiceDate            date NOT NULL,
    DueDate                date NULL,
    StatusCode             nvarchar(30) NOT NULL,
    Subtotal               decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoices_Subtotal DEFAULT (0),
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoices_Discount DEFAULT (0),
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoices_Tax DEFAULT (0),
    OtherCharges           decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoices_OtherCharges DEFAULT (0),
    TotalAmount            decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoices_Total DEFAULT (0),
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_VendorInvoices_ExchangeRate DEFAULT (1),
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_VendorInvoices PRIMARY KEY CLUSTERED (VendorInvoiceId),
    CONSTRAINT UQ_VendorInvoices_Number UNIQUE (CompanyId, VendorInvoiceId),
    CONSTRAINT UQ_VendorInvoices_VendorNumber UNIQUE (CompanyId, VendorId, InvoiceNumber),
    CONSTRAINT CK_VendorInvoices_Amounts CHECK (Subtotal >= 0 AND DiscountAmount >= 0 AND TaxAmount >= 0 AND OtherCharges >= 0 AND TotalAmount >= 0),
    CONSTRAINT CK_VendorInvoices_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Procurement].[VendorInvoiceLines]
(
    VendorInvoiceLineId    bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorInvoiceId        bigint NOT NULL,
    LineNumber             int NOT NULL,
    ProductId              int NULL,
    Description            nvarchar(500) NOT NULL,
    Quantity               decimal(19,6) NOT NULL,
    UnitPrice              decimal(19,4) NOT NULL,
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoiceLines_Discount DEFAULT (0),
    TaxCodeId              int NULL,
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_VendorInvoiceLines_Tax DEFAULT (0),
    LineTotal               decimal(19,4) NOT NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_VendorInvoiceLines PRIMARY KEY CLUSTERED (VendorInvoiceLineId),
    CONSTRAINT UQ_VendorInvoiceLines_Line UNIQUE (VendorInvoiceId, LineNumber),
    CONSTRAINT CK_VendorInvoiceLines_Qty CHECK (Quantity > 0),
    CONSTRAINT CK_VendorInvoiceLines_Price CHECK (UnitPrice >= 0),
    CONSTRAINT CK_VendorInvoiceLines_Discount CHECK (DiscountAmount >= 0)
);
GO

CREATE TABLE [Procurement].[VendorPayments]
(
    VendorPaymentId        bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorId               int NOT NULL,
    CurrencyId             int NOT NULL,
    PaymentMethodId        int NOT NULL,
    PaymentDate            datetime2(3) NOT NULL,
    Amount                 decimal(19,4) NOT NULL,
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_VendorPayments_ExchangeRate DEFAULT (1),
    ReferenceNumber        nvarchar(100) NULL,
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_VendorPayments PRIMARY KEY CLUSTERED (VendorPaymentId),
    CONSTRAINT CK_VendorPayments_Amount CHECK (Amount > 0),
    CONSTRAINT CK_VendorPayments_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

/* ---------------------------------------------------------------------------
   Inventory
--------------------------------------------------------------------------- */
CREATE TABLE [Inventory].[ProductCategories]
(
    ProductCategoryId      int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    Code                   nvarchar(30) NOT NULL,
    Name                   nvarchar(100) NOT NULL,
    IsActive               bit NOT NULL CONSTRAINT DF_ProductCategories_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_ProductCategories PRIMARY KEY CLUSTERED (ProductCategoryId),
    CONSTRAINT UQ_ProductCategories UNIQUE (CompanyId, Code)
);
GO

CREATE TABLE [Inventory].[Warehouses]
(
    WarehouseId            int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    Code                   nvarchar(30) NOT NULL,
    Name                   nvarchar(100) NOT NULL,
    Address                nvarchar(300) NULL,
    City                   nvarchar(100) NULL,
    StateId                int NULL,
    CountryId              int NULL,
    IsActive               bit NOT NULL CONSTRAINT DF_Warehouses_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_Warehouses PRIMARY KEY CLUSTERED (WarehouseId),
    CONSTRAINT UQ_Warehouses UNIQUE (CompanyId, Code)
);
GO

CREATE TABLE [Inventory].[Products]
(
    ProductId              int IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    ProductCategoryId      int NULL,
    PreferredVendorId      int NULL,
    SKU                    nvarchar(80) NOT NULL,
    Name                   nvarchar(200) NOT NULL,
    Description            nvarchar(1000) NULL,
    UnitOfMeasure           nvarchar(20) NOT NULL CONSTRAINT DF_Products_UOM DEFAULT (N'EA'),
    UnitPrice              decimal(19,4) NOT NULL CONSTRAINT DF_Products_UnitPrice DEFAULT (0),
    StandardCost            decimal(19,4) NULL,
    TaxCodeId              int NULL,
    IsStockItem             bit NOT NULL CONSTRAINT DF_Products_IsStockItem DEFAULT (1),
    IsActive                bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT (1),
    RowVersion              rowversion NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ProductId),
    CONSTRAINT UQ_Products_Company_Number UNIQUE (CompanyId, ProductId),
    CONSTRAINT UQ_Products_SKU UNIQUE (CompanyId, SKU),
    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT CK_Products_StandardCost CHECK (StandardCost IS NULL OR StandardCost >= 0)
);
GO

CREATE TABLE [Inventory].[InventoryBalances]
(
    InventoryBalanceId     bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    ProductId              int NOT NULL,
    WarehouseId            int NOT NULL,
    QuantityOnHand         decimal(19,6) NOT NULL CONSTRAINT DF_InventoryBalances_OnHand DEFAULT (0),
    QuantityReserved       decimal(19,6) NOT NULL CONSTRAINT DF_InventoryBalances_Reserved DEFAULT (0),
    AverageCost            decimal(19,8) NOT NULL CONSTRAINT DF_InventoryBalances_AverageCost DEFAULT (0),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_InventoryBalances PRIMARY KEY CLUSTERED (InventoryBalanceId),
    CONSTRAINT UQ_InventoryBalances UNIQUE (CompanyId, ProductId, WarehouseId),
    CONSTRAINT CK_InventoryBalances_Reserved CHECK (QuantityReserved >= 0),
    CONSTRAINT CK_InventoryBalances_AverageCost CHECK (AverageCost >= 0)
);
GO

CREATE TABLE [Inventory].[InventoryTransactions]
(
    InventoryTransactionId bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    ProductId              int NOT NULL,
    WarehouseId            int NOT NULL,
    TransactionDate        datetime2(3) NOT NULL CONSTRAINT DF_InventoryTransactions_Date DEFAULT SYSUTCDATETIME(),
    TransactionType        nvarchar(40) NOT NULL,
    Quantity               decimal(19,6) NOT NULL,
    UnitCost               decimal(19,8) NULL,
    ReferenceType          nvarchar(50) NULL,
    ReferenceId            bigint NULL,
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_InventoryTransactions PRIMARY KEY CLUSTERED (InventoryTransactionId),
    CONSTRAINT CK_InventoryTransactions_Qty CHECK (Quantity <> 0),
    CONSTRAINT CK_InventoryTransactions_Cost CHECK (UnitCost IS NULL OR UnitCost >= 0)
);
GO

CREATE TABLE [Inventory].[InventoryTransfers]
(
    InventoryTransferId    bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    TransferNumber         nvarchar(50) NOT NULL,
    FromWarehouseId        int NOT NULL,
    ToWarehouseId          int NOT NULL,
    TransferDate           date NOT NULL,
    StatusCode             nvarchar(30) NOT NULL,
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_InventoryTransfers PRIMARY KEY CLUSTERED (InventoryTransferId),
    CONSTRAINT UQ_InventoryTransfers_Number UNIQUE (CompanyId, TransferNumber),
    CONSTRAINT CK_InventoryTransfers_Warehouses CHECK (FromWarehouseId <> ToWarehouseId)
);
GO

CREATE TABLE [Inventory].[InventoryTransferLines]
(
    InventoryTransferLineId bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    InventoryTransferId    bigint NOT NULL,
    LineNumber             int NOT NULL,
    ProductId              int NOT NULL,
    Quantity               decimal(19,6) NOT NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_InventoryTransferLines PRIMARY KEY CLUSTERED (InventoryTransferLineId),
    CONSTRAINT UQ_InventoryTransferLines_Line UNIQUE (InventoryTransferId, LineNumber),
    CONSTRAINT CK_InventoryTransferLines_Qty CHECK (Quantity > 0)
);
GO

/* ---------------------------------------------------------------------------
   Sales
--------------------------------------------------------------------------- */
CREATE TABLE [Sales].[SalesOrders]
(
    SalesOrderId           bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    CustomerId             int NOT NULL,
    EmployeeId             int NULL,
    CurrencyId             int NOT NULL,
    PaymentMethodId        int NULL,
    OrderNumber            nvarchar(50) NOT NULL,
    OrderDate              date NOT NULL,
    StatusCode             nvarchar(30) NOT NULL,
    RequestedDate          date NULL,
    Subtotal               decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrders_Subtotal DEFAULT (0),
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrders_Discount DEFAULT (0),
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrders_Tax DEFAULT (0),
    OtherCharges           decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrders_OtherCharges DEFAULT (0),
    TotalAmount            decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrders_Total DEFAULT (0),
    ExchangeRate           decimal(19,8) NOT NULL CONSTRAINT DF_SalesOrders_ExchangeRate DEFAULT (1),
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_SalesOrders PRIMARY KEY CLUSTERED (SalesOrderId),
    CONSTRAINT UQ_SalesOrders_Number UNIQUE (CompanyId, OrderNumber),
    CONSTRAINT CK_SalesOrders_Amounts CHECK (Subtotal >= 0 AND DiscountAmount >= 0 AND TaxAmount >= 0 AND OtherCharges >= 0 AND TotalAmount >= 0),
    CONSTRAINT CK_SalesOrders_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Sales].[SalesOrderLines]
(
    SalesOrderLineId       bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    SalesOrderId           bigint NOT NULL,
    LineNumber             int NOT NULL,
    ProductId              int NULL,
    Description            nvarchar(500) NOT NULL,
    Quantity               decimal(19,6) NOT NULL,
    UnitPrice              decimal(19,4) NOT NULL,
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrderLines_Discount DEFAULT (0),
    TaxCodeId              int NULL,
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_SalesOrderLines_Tax DEFAULT (0),
    LineTotal               decimal(19,4) NOT NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_SalesOrderLines PRIMARY KEY CLUSTERED (SalesOrderLineId),
    CONSTRAINT UQ_SalesOrderLines_Line UNIQUE (SalesOrderId, LineNumber),
    CONSTRAINT CK_SalesOrderLines_Qty CHECK (Quantity > 0),
    CONSTRAINT CK_SalesOrderLines_Price CHECK (UnitPrice >= 0),
    CONSTRAINT CK_SalesOrderLines_Discount CHECK (DiscountAmount >= 0)
);
GO

CREATE TABLE [Sales].[SalesInvoices]
(
    SalesInvoiceId         bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    CustomerId             int NOT NULL,
    SalesOrderId           bigint NULL,
    EmployeeId             int NULL,
    CurrencyId             int NOT NULL,
    PaymentMethodId        int NULL,
    InvoiceNumber          nvarchar(80) NOT NULL,
    InvoiceDate            date NOT NULL,
    DueDate                date NULL,
    StatusCode             nvarchar(30) NOT NULL,
    Subtotal               decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoices_Subtotal DEFAULT (0),
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoices_Discount DEFAULT (0),
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoices_Tax DEFAULT (0),
    OtherCharges           decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoices_OtherCharges DEFAULT (0),
    TotalAmount            decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoices_Total DEFAULT (0),
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_SalesInvoices_ExchangeRate DEFAULT (1),
    Remarks                nvarchar(1000) NULL,
    RowVersion              rowversion NOT NULL,
    CONSTRAINT PK_SalesInvoices PRIMARY KEY CLUSTERED (SalesInvoiceId),
    CONSTRAINT UQ_SalesInvoices_Company_Number UNIQUE (CompanyId, InvoiceNumber),
    CONSTRAINT CK_SalesInvoices_Amounts CHECK (Subtotal >= 0 AND DiscountAmount >= 0 AND TaxAmount >= 0 AND OtherCharges >= 0 AND TotalAmount >= 0),
    CONSTRAINT CK_SalesInvoices_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Sales].[SalesInvoiceLines]
(
    SalesInvoiceLineId     bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    SalesInvoiceId         bigint NOT NULL,
    LineNumber             int NOT NULL,
    ProductId              int NULL,
    Description            nvarchar(500) NOT NULL,
    Quantity               decimal(19,6) NOT NULL,
    UnitPrice              decimal(19,4) NOT NULL,
    DiscountAmount         decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoiceLines_Discount DEFAULT (0),
    TaxCodeId              int NULL,
    TaxAmount              decimal(19,4) NOT NULL CONSTRAINT DF_SalesInvoiceLines_Tax DEFAULT (0),
    LineTotal               decimal(19,4) NOT NULL,
    RowVersion              rowversion NOT NULL,
    CONSTRAINT PK_SalesInvoiceLines PRIMARY KEY CLUSTERED (SalesInvoiceLineId),
    CONSTRAINT UQ_SalesInvoiceLines_Line UNIQUE (SalesInvoiceId, LineNumber),
    CONSTRAINT CK_SalesInvoiceLines_Qty CHECK (Quantity > 0),
    CONSTRAINT CK_SalesInvoiceLines_Price CHECK (UnitPrice >= 0),
    CONSTRAINT CK_SalesInvoiceLines_Discount CHECK (DiscountAmount >= 0)
);
GO

CREATE TABLE [Sales].[CustomerPayments]
(
    CustomerPaymentId      bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    CustomerId             int NOT NULL,
    CurrencyId             int NOT NULL,
    PaymentMethodId        int NOT NULL,
    PaymentDate            datetime2(3) NOT NULL,
    Amount                 decimal(19,4) NOT NULL,
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_CustomerPayments_ExchangeRate DEFAULT (1),
    ReferenceNumber        nvarchar(100) NULL,
    Remarks                nvarchar(1000) NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_CustomerPayments PRIMARY KEY CLUSTERED (CustomerPaymentId),
    CONSTRAINT CK_CustomerPayments_Amount CHECK (Amount > 0),
    CONSTRAINT CK_CustomerPayments_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Sales].[SalesCommissions]
(
    SalesCommissionId      bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    EmployeeId             int NOT NULL,
    SalesInvoiceId         bigint NOT NULL,
    CommissionDate         date NOT NULL,
    Amount                 decimal(19,4) NOT NULL,
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_SalesCommissions_ExchangeRate DEFAULT (1),
    IsPaid                 bit NOT NULL CONSTRAINT DF_SalesCommissions_IsPaid DEFAULT (0),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_SalesCommissions PRIMARY KEY CLUSTERED (SalesCommissionId),
    CONSTRAINT CK_SalesCommissions_Amount CHECK (Amount >= 0),
    CONSTRAINT CK_SalesCommissions_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

/* ---------------------------------------------------------------------------
   Finance
--------------------------------------------------------------------------- */
CREATE TABLE [Finance].[ChartOfAccounts]
(
    AccountId              bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    AccountCode            nvarchar(50) NOT NULL,
    AccountName            nvarchar(200) NOT NULL,
    AccountType            nvarchar(30) NOT NULL,
    ParentAccountId        bigint NULL,
    NormalBalance          char(1) NOT NULL,
    IsControlAccount       bit NOT NULL CONSTRAINT DF_ChartOfAccounts_Control DEFAULT (0),
    IsActive               bit NOT NULL CONSTRAINT DF_ChartOfAccounts_IsActive DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_ChartOfAccounts PRIMARY KEY CLUSTERED (AccountId),
    CONSTRAINT UQ_ChartOfAccounts_Code UNIQUE (CompanyId, AccountCode),
    CONSTRAINT CK_ChartOfAccounts_Type CHECK (AccountType IN (N'ASSET',N'LIABILITY',N'EQUITY',N'REVENUE',N'EXPENSE')),
    CONSTRAINT CK_ChartOfAccounts_NormalBalance CHECK (NormalBalance IN ('D','C'))
);
GO

CREATE TABLE [Finance].[JournalEntries]
(
    JournalEntryId         bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    AccountingPeriodId     int NOT NULL,
    EntryNumber            nvarchar(50) NOT NULL,
    EntryDate              date NOT NULL,
    SourceModule           nvarchar(40) NOT NULL,
    SourceType             nvarchar(60) NULL,
    SourceId               bigint NULL,
    Description            nvarchar(1000) NULL,
    StatusCode             nvarchar(30) NOT NULL,
    CurrencyId             int NOT NULL,
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_JournalEntries_ExchangeRate DEFAULT (1),
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_JournalEntries PRIMARY KEY CLUSTERED (JournalEntryId),
    CONSTRAINT UQ_JournalEntries_Number UNIQUE (CompanyId, EntryNumber),
    CONSTRAINT CK_JournalEntries_ExchangeRate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Finance].[JournalEntryLines]
(
    JournalEntryLineId     bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    JournalEntryId         bigint NOT NULL,
    LineNumber             int NOT NULL,
    AccountId              bigint NOT NULL,
    Description            nvarchar(500) NULL,
    DebitAmount            decimal(19,4) NOT NULL CONSTRAINT DF_JournalEntryLines_Debit DEFAULT (0),
    CreditAmount           decimal(19,4) NOT NULL CONSTRAINT DF_JournalEntryLines_Credit DEFAULT (0),
    TaxCodeId              int NULL,
    CustomerId             int NULL,
    VendorId               int NULL,
    EmployeeId             int NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_JournalEntryLines PRIMARY KEY CLUSTERED (JournalEntryLineId),
    CONSTRAINT UQ_JournalEntryLines_Line UNIQUE (JournalEntryId, LineNumber),
    CONSTRAINT CK_JournalEntryLines_Amounts CHECK (
        DebitAmount >= 0 AND CreditAmount >= 0 AND
        ((DebitAmount > 0 AND CreditAmount = 0) OR
         (CreditAmount > 0 AND DebitAmount = 0))
    )
);
GO

CREATE TABLE [Finance].[AccountsReceivable]
(
    ReceivableId           bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    CustomerId             int NOT NULL,
    SalesInvoiceId         bigint NULL,
    TransactionDate        date NOT NULL,
    DueDate                date NULL,
    DebitAmount            decimal(19,4) NOT NULL CONSTRAINT DF_AR_Debit DEFAULT (0),
    CreditAmount           decimal(19,4) NOT NULL CONSTRAINT DF_AR_Credit DEFAULT (0),
    CurrencyId             int NOT NULL,
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_AR_Rate DEFAULT (1),
    ReferenceType          nvarchar(50) NULL,
    ReferenceId            bigint NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_AccountsReceivable PRIMARY KEY CLUSTERED (ReceivableId),
    CONSTRAINT CK_AR_Amounts CHECK ((DebitAmount > 0 AND CreditAmount = 0) OR (CreditAmount > 0 AND DebitAmount = 0)),
    CONSTRAINT CK_AR_Rate CHECK (ExchangeRate > 0)
);
GO

CREATE TABLE [Finance].[AccountsPayable]
(
    PayableId              bigint IDENTITY(1,1) NOT NULL,
    CompanyId              int NOT NULL,
    VendorId               int NOT NULL,
    VendorInvoiceId        bigint NULL,
    TransactionDate        date NOT NULL,
    DueDate                date NULL,
    DebitAmount            decimal(19,4) NOT NULL CONSTRAINT DF_AP_Debit DEFAULT (0),
    CreditAmount           decimal(19,4) NOT NULL CONSTRAINT DF_AP_Credit DEFAULT (0),
    CurrencyId             int NOT NULL,
    ExchangeRate            decimal(19,8) NOT NULL CONSTRAINT DF_AP_Rate DEFAULT (1),
    ReferenceType          nvarchar(50) NULL,
    ReferenceId            bigint NULL,
    RowVersion             rowversion NOT NULL,
    CONSTRAINT PK_AccountsPayable PRIMARY KEY CLUSTERED (PayableId),
    CONSTRAINT CK_AP_Amounts CHECK ((DebitAmount > 0 AND CreditAmount = 0) OR (CreditAmount > 0 AND DebitAmount = 0)),
    CONSTRAINT CK_AP_Rate CHECK (ExchangeRate > 0)
);
GO

/* ---------------------------------------------------------------------------
   Security: user-company assignments and application session context
--------------------------------------------------------------------------- */
CREATE TABLE [Security].[UserCompanies]
(
    UserId                int NOT NULL,
    CompanyId             int NOT NULL,
    IsDefault              bit NOT NULL CONSTRAINT DF_UserCompanies_IsDefault DEFAULT (0),
    CONSTRAINT PK_UserCompanies PRIMARY KEY CLUSTERED (UserId, CompanyId)
);
GO

/* ---------------------------------------------------------------------------
   Audit
--------------------------------------------------------------------------- */
CREATE TABLE [Audit].[AuditLog]
(
    AuditLogId             bigint IDENTITY(1,1) NOT NULL,
    AuditDate              datetime2(3) NOT NULL CONSTRAINT DF_AuditLog_AuditDate DEFAULT SYSUTCDATETIME(),
    ActionType             varchar(10) NOT NULL,
    SchemaName             sysname NOT NULL,
    TableName              sysname NOT NULL,
    RecordId               bigint NULL,
    CompanyId              int NULL,
    UserId                 int NULL,
    ApplicationUser        nvarchar(256) NULL,
    ApplicationName        nvarchar(128) NULL,
    HostName               nvarchar(128) NULL,
    IpAddress              varchar(48) NULL,
    SessionId              int NULL,
    CorrelationId          uniqueidentifier NULL,
    OldValues              nvarchar(max) NULL,
    NewValues              nvarchar(max) NULL,
    ChangedColumns         nvarchar(max) NULL,
    CONSTRAINT PK_AuditLog PRIMARY KEY CLUSTERED (AuditLogId),
    CONSTRAINT CK_AuditLog_Action CHECK (ActionType IN ('INSERT','UPDATE','DELETE')),
    CONSTRAINT CK_AuditLog_OldJson CHECK (OldValues IS NULL OR ISJSON(OldValues) = 1),
    CONSTRAINT CK_AuditLog_NewJson CHECK (NewValues IS NULL OR ISJSON(NewValues) = 1),
    CONSTRAINT CK_AuditLog_ChangedJson CHECK (ChangedColumns IS NULL OR ISJSON(ChangedColumns) = 1)
);
GO


/* Composite parent keys enforce same-company foreign key integrity. */
ALTER TABLE [HR].[Departments] ADD CONSTRAINT UQ_Departments_Company_Id UNIQUE (CompanyId, DepartmentId);
ALTER TABLE [HR].[EmployeeProfiles] ADD CONSTRAINT UQ_EmployeeProfiles_Company_Id UNIQUE (CompanyId, EmployeeProfileId);
ALTER TABLE [HR].[Employees] ADD CONSTRAINT UQ_Employees_Company_Id UNIQUE (CompanyId, EmployeeId);

ALTER TABLE [Procurement].[Vendors] ADD CONSTRAINT UQ_Vendors_Company_Id UNIQUE (CompanyId, VendorId);
ALTER TABLE [Procurement].[PurchaseOrders] ADD CONSTRAINT UQ_PurchaseOrders_Company_Id UNIQUE (CompanyId, PurchaseOrderId);
ALTER TABLE [Procurement].[VendorInvoices] ADD CONSTRAINT UQ_VendorInvoices_Company_Id UNIQUE (CompanyId, VendorInvoiceId);

ALTER TABLE [Inventory].[ProductCategories] ADD CONSTRAINT UQ_ProductCategories_Company_Id UNIQUE (CompanyId, ProductCategoryId);
ALTER TABLE [Inventory].[Warehouses] ADD CONSTRAINT UQ_Warehouses_Company_Id UNIQUE (CompanyId, WarehouseId);
ALTER TABLE [Inventory].[Products] ADD CONSTRAINT UQ_Products_Company_Id UNIQUE (CompanyId, ProductId);
ALTER TABLE [Inventory].[InventoryTransfers] ADD CONSTRAINT UQ_InventoryTransfers_Company_Id UNIQUE (CompanyId, InventoryTransferId);

ALTER TABLE [Sales].[SalesOrders] ADD CONSTRAINT UQ_SalesOrders_Company_Id UNIQUE (CompanyId, SalesOrderId);
ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT UQ_SalesInvoices_Company_Id UNIQUE (CompanyId, SalesInvoiceId);

ALTER TABLE [Finance].[JournalEntries] ADD CONSTRAINT UQ_JournalEntries_Company_Id UNIQUE (CompanyId, JournalEntryId);

/* Composite candidate keys required by company-scoped foreign keys. */
ALTER TABLE [Reference].[PaymentMethods]
    ADD CONSTRAINT UQ_PaymentMethods_Company_Id UNIQUE (CompanyId, PaymentMethodId);
ALTER TABLE [Reference].[TaxCodes]
    ADD CONSTRAINT UQ_TaxCodes_Company_Id UNIQUE (CompanyId, TaxCodeId);
ALTER TABLE [Core].[AccountingPeriods]
    ADD CONSTRAINT UQ_AccountingPeriods_Company_Id UNIQUE (CompanyId, AccountingPeriodId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - reference/core
--------------------------------------------------------------------------- */
ALTER TABLE [Core].[States] ADD CONSTRAINT FK_States_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [Core].[Companies] ADD CONSTRAINT FK_Companies_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [Core].[Companies] ADD CONSTRAINT FK_Companies_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);
ALTER TABLE [Core].[Companies] ADD CONSTRAINT FK_Companies_Currencies
    FOREIGN KEY (BaseCurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Core].[ExchangeRates] ADD CONSTRAINT FK_ExchangeRates_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Core].[ExchangeRates] ADD CONSTRAINT FK_ExchangeRates_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Core].[FiscalYears] ADD CONSTRAINT FK_FiscalYears_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Core].[AccountingPeriods] ADD CONSTRAINT FK_AccountingPeriods_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Core].[AccountingPeriods] ADD CONSTRAINT FK_AccountingPeriods_FiscalYears
    FOREIGN KEY (FiscalYearId) REFERENCES [Core].[FiscalYears](FiscalYearId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - reference
--------------------------------------------------------------------------- */
ALTER TABLE [Reference].[DocumentStatuses] ADD CONSTRAINT FK_DocumentStatuses_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Reference].[PaymentMethods] ADD CONSTRAINT FK_PaymentMethods_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Reference].[TaxCodes] ADD CONSTRAINT FK_TaxCodes_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - CRM
--------------------------------------------------------------------------- */
ALTER TABLE [CRM].[Customers] ADD CONSTRAINT FK_Customers_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [CRM].[Customers] ADD CONSTRAINT FK_Customers_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [CRM].[Customers] ADD CONSTRAINT FK_Customers_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);
ALTER TABLE [CRM].[CustomerContacts] ADD CONSTRAINT FK_CustomerContacts_Customers
    FOREIGN KEY (CompanyId, CustomerId) REFERENCES [CRM].[Customers](CompanyId, CustomerId);
ALTER TABLE [CRM].[CustomerContacts] ADD CONSTRAINT FK_CustomerContacts_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [CRM].[CustomerContacts] ADD CONSTRAINT FK_CustomerContacts_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - HR
--------------------------------------------------------------------------- */
ALTER TABLE [HR].[Departments] ADD CONSTRAINT FK_Departments_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [HR].[EmployeeProfiles] ADD CONSTRAINT FK_EmployeeProfiles_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [HR].[Employees] ADD CONSTRAINT FK_Employees_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [HR].[Employees] ADD CONSTRAINT FK_Employees_Departments
    FOREIGN KEY (CompanyId, DepartmentId) REFERENCES [HR].[Departments](CompanyId, DepartmentId);
ALTER TABLE [HR].[Employees] ADD CONSTRAINT FK_Employees_Profiles
    FOREIGN KEY (CompanyId, EmployeeProfileId) REFERENCES [HR].[EmployeeProfiles](CompanyId, EmployeeProfileId);
ALTER TABLE [HR].[Employees] ADD CONSTRAINT FK_Employees_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [HR].[Employees] ADD CONSTRAINT FK_Employees_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - Procurement
--------------------------------------------------------------------------- */
ALTER TABLE [Procurement].[Vendors] ADD CONSTRAINT FK_Vendors_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Procurement].[Vendors] ADD CONSTRAINT FK_Vendors_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [Procurement].[Vendors] ADD CONSTRAINT FK_Vendors_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);
ALTER TABLE [Procurement].[VendorContacts] ADD CONSTRAINT FK_VendorContacts_Vendors
    FOREIGN KEY (CompanyId, VendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Procurement].[VendorContacts] ADD CONSTRAINT FK_VendorContacts_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [Procurement].[VendorContacts] ADD CONSTRAINT FK_VendorContacts_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);

ALTER TABLE [Procurement].[PurchaseOrders] ADD CONSTRAINT FK_PurchaseOrders_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Procurement].[PurchaseOrders] ADD CONSTRAINT FK_PurchaseOrders_Vendors
    FOREIGN KEY (CompanyId, VendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Procurement].[PurchaseOrders] ADD CONSTRAINT FK_PurchaseOrders_Employees
    FOREIGN KEY (CompanyId, EmployeeId) REFERENCES [HR].[Employees](CompanyId, EmployeeId);
ALTER TABLE [Procurement].[PurchaseOrders] ADD CONSTRAINT FK_PurchaseOrders_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Procurement].[PurchaseOrders] ADD CONSTRAINT FK_PurchaseOrders_PaymentMethods
    FOREIGN KEY (CompanyId, PaymentMethodId) REFERENCES [Reference].[PaymentMethods](CompanyId, PaymentMethodId);

ALTER TABLE [Procurement].[PurchaseOrderLines] ADD CONSTRAINT FK_PurchaseOrderLines_Orders
    FOREIGN KEY (CompanyId, PurchaseOrderId) REFERENCES [Procurement].[PurchaseOrders](CompanyId, PurchaseOrderId);
ALTER TABLE [Procurement].[PurchaseOrderLines] ADD CONSTRAINT FK_PurchaseOrderLines_TaxCodes
    FOREIGN KEY (CompanyId, TaxCodeId) REFERENCES [Reference].[TaxCodes](CompanyId, TaxCodeId);
ALTER TABLE [Procurement].[PurchaseOrderLines] ADD CONSTRAINT FK_PurchaseOrderLines_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);

ALTER TABLE [Procurement].[VendorInvoices] ADD CONSTRAINT FK_VendorInvoices_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Procurement].[VendorInvoices] ADD CONSTRAINT FK_VendorInvoices_Vendors
    FOREIGN KEY (CompanyId, VendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Procurement].[VendorInvoices] ADD CONSTRAINT FK_VendorInvoices_Orders
    FOREIGN KEY (CompanyId, PurchaseOrderId) REFERENCES [Procurement].[PurchaseOrders](CompanyId, PurchaseOrderId);
ALTER TABLE [Procurement].[VendorInvoices] ADD CONSTRAINT FK_VendorInvoices_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Procurement].[VendorInvoices] ADD CONSTRAINT FK_VendorInvoices_PaymentMethods
    FOREIGN KEY (CompanyId, PaymentMethodId) REFERENCES [Reference].[PaymentMethods](CompanyId, PaymentMethodId);

ALTER TABLE [Procurement].[VendorInvoiceLines] ADD CONSTRAINT FK_VendorInvoiceLines_Invoices
    FOREIGN KEY (CompanyId, VendorInvoiceId) REFERENCES [Procurement].[VendorInvoices](CompanyId, VendorInvoiceId);
ALTER TABLE [Procurement].[VendorInvoiceLines] ADD CONSTRAINT FK_VendorInvoiceLines_TaxCodes
    FOREIGN KEY (CompanyId, TaxCodeId) REFERENCES [Reference].[TaxCodes](CompanyId, TaxCodeId);
ALTER TABLE [Procurement].[VendorInvoiceLines] ADD CONSTRAINT FK_VendorInvoiceLines_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);

ALTER TABLE [Procurement].[VendorPayments] ADD CONSTRAINT FK_VendorPayments_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Procurement].[VendorPayments] ADD CONSTRAINT FK_VendorPayments_Vendors
    FOREIGN KEY (CompanyId, VendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Procurement].[VendorPayments] ADD CONSTRAINT FK_VendorPayments_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Procurement].[VendorPayments] ADD CONSTRAINT FK_VendorPayments_PaymentMethods
    FOREIGN KEY (CompanyId, PaymentMethodId) REFERENCES [Reference].[PaymentMethods](CompanyId, PaymentMethodId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - Inventory
--------------------------------------------------------------------------- */
ALTER TABLE [Inventory].[ProductCategories] ADD CONSTRAINT FK_ProductCategories_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Inventory].[Warehouses] ADD CONSTRAINT FK_Warehouses_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Inventory].[Warehouses] ADD CONSTRAINT FK_Warehouses_Countries
    FOREIGN KEY (CountryId) REFERENCES [Core].[Countries](CountryId);
ALTER TABLE [Inventory].[Warehouses] ADD CONSTRAINT FK_Warehouses_States
    FOREIGN KEY (StateId) REFERENCES [Core].[States](StateId);
ALTER TABLE [Inventory].[Products] ADD CONSTRAINT FK_Products_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Inventory].[Products] ADD CONSTRAINT FK_Products_Categories
    FOREIGN KEY (CompanyId, ProductCategoryId) REFERENCES [Inventory].[ProductCategories](CompanyId, ProductCategoryId);
ALTER TABLE [Inventory].[Products] ADD CONSTRAINT FK_Products_Vendors
    FOREIGN KEY (CompanyId, PreferredVendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Inventory].[Products] ADD CONSTRAINT FK_Products_TaxCodes
    FOREIGN KEY (CompanyId, TaxCodeId) REFERENCES [Reference].[TaxCodes](CompanyId, TaxCodeId);

ALTER TABLE [Inventory].[InventoryBalances] ADD CONSTRAINT FK_InventoryBalances_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Inventory].[InventoryBalances] ADD CONSTRAINT FK_InventoryBalances_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);
ALTER TABLE [Inventory].[InventoryBalances] ADD CONSTRAINT FK_InventoryBalances_Warehouses
    FOREIGN KEY (CompanyId, WarehouseId) REFERENCES [Inventory].[Warehouses](CompanyId, WarehouseId);

ALTER TABLE [Inventory].[InventoryTransactions] ADD CONSTRAINT FK_InventoryTransactions_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Inventory].[InventoryTransactions] ADD CONSTRAINT FK_InventoryTransactions_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);
ALTER TABLE [Inventory].[InventoryTransactions] ADD CONSTRAINT FK_InventoryTransactions_Warehouses
    FOREIGN KEY (CompanyId, WarehouseId) REFERENCES [Inventory].[Warehouses](CompanyId, WarehouseId);

ALTER TABLE [Inventory].[InventoryTransfers] ADD CONSTRAINT FK_InventoryTransfers_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Inventory].[InventoryTransfers] ADD CONSTRAINT FK_InventoryTransfers_FromWarehouse
    FOREIGN KEY (CompanyId, FromWarehouseId) REFERENCES [Inventory].[Warehouses](CompanyId, WarehouseId);
ALTER TABLE [Inventory].[InventoryTransfers] ADD CONSTRAINT FK_InventoryTransfers_ToWarehouse
    FOREIGN KEY (CompanyId, ToWarehouseId) REFERENCES [Inventory].[Warehouses](CompanyId, WarehouseId);

ALTER TABLE [Inventory].[InventoryTransferLines] ADD CONSTRAINT FK_InventoryTransferLines_Transfers
    FOREIGN KEY (CompanyId, InventoryTransferId) REFERENCES [Inventory].[InventoryTransfers](CompanyId, InventoryTransferId);
ALTER TABLE [Inventory].[InventoryTransferLines] ADD CONSTRAINT FK_InventoryTransferLines_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - Sales
--------------------------------------------------------------------------- */
ALTER TABLE [Sales].[SalesOrders] ADD CONSTRAINT FK_SalesOrders_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Sales].[SalesOrders] ADD CONSTRAINT FK_SalesOrders_Customers
    FOREIGN KEY (CompanyId, CustomerId) REFERENCES [CRM].[Customers](CompanyId, CustomerId);
ALTER TABLE [Sales].[SalesOrders] ADD CONSTRAINT FK_SalesOrders_Employees
    FOREIGN KEY (CompanyId, EmployeeId) REFERENCES [HR].[Employees](CompanyId, EmployeeId);
ALTER TABLE [Sales].[SalesOrders] ADD CONSTRAINT FK_SalesOrders_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Sales].[SalesOrders] ADD CONSTRAINT FK_SalesOrders_PaymentMethods
    FOREIGN KEY (CompanyId, PaymentMethodId) REFERENCES [Reference].[PaymentMethods](CompanyId, PaymentMethodId);

ALTER TABLE [Sales].[SalesOrderLines] ADD CONSTRAINT FK_SalesOrderLines_Orders
    FOREIGN KEY (CompanyId, SalesOrderId) REFERENCES [Sales].[SalesOrders](CompanyId, SalesOrderId);
ALTER TABLE [Sales].[SalesOrderLines] ADD CONSTRAINT FK_SalesOrderLines_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);
ALTER TABLE [Sales].[SalesOrderLines] ADD CONSTRAINT FK_SalesOrderLines_TaxCodes
    FOREIGN KEY (CompanyId, TaxCodeId) REFERENCES [Reference].[TaxCodes](CompanyId, TaxCodeId);

ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT FK_SalesInvoices_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT FK_SalesInvoices_Customers
    FOREIGN KEY (CompanyId, CustomerId) REFERENCES [CRM].[Customers](CompanyId, CustomerId);
ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT FK_SalesInvoices_Orders
    FOREIGN KEY (CompanyId, SalesOrderId) REFERENCES [Sales].[SalesOrders](CompanyId, SalesOrderId);
ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT FK_SalesInvoices_Employees
    FOREIGN KEY (CompanyId, EmployeeId) REFERENCES [HR].[Employees](CompanyId, EmployeeId);
ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT FK_SalesInvoices_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Sales].[SalesInvoices] ADD CONSTRAINT FK_SalesInvoices_PaymentMethods
    FOREIGN KEY (CompanyId, PaymentMethodId) REFERENCES [Reference].[PaymentMethods](CompanyId, PaymentMethodId);

ALTER TABLE [Sales].[SalesInvoiceLines] ADD CONSTRAINT FK_SalesInvoiceLines_Invoices
    FOREIGN KEY (CompanyId, SalesInvoiceId) REFERENCES [Sales].[SalesInvoices](CompanyId, SalesInvoiceId);
ALTER TABLE [Sales].[SalesInvoiceLines] ADD CONSTRAINT FK_SalesInvoiceLines_Products
    FOREIGN KEY (CompanyId, ProductId) REFERENCES [Inventory].[Products](CompanyId, ProductId);
ALTER TABLE [Sales].[SalesInvoiceLines] ADD CONSTRAINT FK_SalesInvoiceLines_TaxCodes
    FOREIGN KEY (CompanyId, TaxCodeId) REFERENCES [Reference].[TaxCodes](CompanyId, TaxCodeId);

ALTER TABLE [Sales].[CustomerPayments] ADD CONSTRAINT FK_CustomerPayments_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Sales].[CustomerPayments] ADD CONSTRAINT FK_CustomerPayments_Customers
    FOREIGN KEY (CompanyId, CustomerId) REFERENCES [CRM].[Customers](CompanyId, CustomerId);
ALTER TABLE [Sales].[CustomerPayments] ADD CONSTRAINT FK_CustomerPayments_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
ALTER TABLE [Sales].[CustomerPayments] ADD CONSTRAINT FK_CustomerPayments_PaymentMethods
    FOREIGN KEY (CompanyId, PaymentMethodId) REFERENCES [Reference].[PaymentMethods](CompanyId, PaymentMethodId);

ALTER TABLE [Sales].[SalesCommissions] ADD CONSTRAINT FK_SalesCommissions_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Sales].[SalesCommissions] ADD CONSTRAINT FK_SalesCommissions_Employees
    FOREIGN KEY (CompanyId, EmployeeId) REFERENCES [HR].[Employees](CompanyId, EmployeeId);
ALTER TABLE [Sales].[SalesCommissions] ADD CONSTRAINT FK_SalesCommissions_Invoices
    FOREIGN KEY (CompanyId, SalesInvoiceId) REFERENCES [Sales].[SalesInvoices](CompanyId, SalesInvoiceId);
GO

/* ---------------------------------------------------------------------------
   Foreign keys - Finance
--------------------------------------------------------------------------- */
ALTER TABLE [Finance].[ChartOfAccounts] ADD CONSTRAINT UQ_ChartOfAccounts_Company_Id UNIQUE (CompanyId, AccountId);
ALTER TABLE [Finance].[ChartOfAccounts] ADD CONSTRAINT FK_ChartOfAccounts_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Finance].[ChartOfAccounts] ADD CONSTRAINT FK_ChartOfAccounts_Parent
    FOREIGN KEY (ParentAccountId) REFERENCES [Finance].[ChartOfAccounts](AccountId);

ALTER TABLE [Finance].[JournalEntries] ADD CONSTRAINT FK_JournalEntries_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Finance].[JournalEntries] ADD CONSTRAINT FK_JournalEntries_Periods
    FOREIGN KEY (CompanyId, AccountingPeriodId) REFERENCES [Core].[AccountingPeriods](CompanyId, AccountingPeriodId);
ALTER TABLE [Finance].[JournalEntries] ADD CONSTRAINT FK_JournalEntries_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);

ALTER TABLE [Finance].[JournalEntryLines] ADD CONSTRAINT FK_JournalEntryLines_Entries
    FOREIGN KEY (CompanyId, JournalEntryId) REFERENCES [Finance].[JournalEntries](CompanyId, JournalEntryId);
ALTER TABLE [Finance].[JournalEntryLines] ADD CONSTRAINT FK_JournalEntryLines_Accounts
    FOREIGN KEY (CompanyId, AccountId) REFERENCES [Finance].[ChartOfAccounts](CompanyId, AccountId);
ALTER TABLE [Finance].[JournalEntryLines] ADD CONSTRAINT FK_JournalEntryLines_TaxCodes
    FOREIGN KEY (CompanyId, TaxCodeId) REFERENCES [Reference].[TaxCodes](CompanyId, TaxCodeId);
ALTER TABLE [Finance].[JournalEntryLines] ADD CONSTRAINT FK_JournalEntryLines_Customers
    FOREIGN KEY (CompanyId, CustomerId) REFERENCES [CRM].[Customers](CompanyId, CustomerId);
ALTER TABLE [Finance].[JournalEntryLines] ADD CONSTRAINT FK_JournalEntryLines_Vendors
    FOREIGN KEY (CompanyId, VendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Finance].[JournalEntryLines] ADD CONSTRAINT FK_JournalEntryLines_Employees
    FOREIGN KEY (CompanyId, EmployeeId) REFERENCES [HR].[Employees](CompanyId, EmployeeId);

ALTER TABLE [Finance].[AccountsReceivable] ADD CONSTRAINT FK_AR_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Finance].[AccountsReceivable] ADD CONSTRAINT FK_AR_Customers
    FOREIGN KEY (CompanyId, CustomerId) REFERENCES [CRM].[Customers](CompanyId, CustomerId);
ALTER TABLE [Finance].[AccountsReceivable] ADD CONSTRAINT FK_AR_Invoices
    FOREIGN KEY (CompanyId, SalesInvoiceId) REFERENCES [Sales].[SalesInvoices](CompanyId, SalesInvoiceId);
ALTER TABLE [Finance].[AccountsReceivable] ADD CONSTRAINT FK_AR_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);

ALTER TABLE [Finance].[AccountsPayable] ADD CONSTRAINT FK_AP_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
ALTER TABLE [Finance].[AccountsPayable] ADD CONSTRAINT FK_AP_Vendors
    FOREIGN KEY (CompanyId, VendorId) REFERENCES [Procurement].[Vendors](CompanyId, VendorId);
ALTER TABLE [Finance].[AccountsPayable] ADD CONSTRAINT FK_AP_Invoices
    FOREIGN KEY (CompanyId, VendorInvoiceId) REFERENCES [Procurement].[VendorInvoices](CompanyId, VendorInvoiceId);
ALTER TABLE [Finance].[AccountsPayable] ADD CONSTRAINT FK_AP_Currencies
    FOREIGN KEY (CurrencyId) REFERENCES [Core].[Currencies](CurrencyId);
GO

/* ---------------------------------------------------------------------------
   Security foreign keys
--------------------------------------------------------------------------- */
ALTER TABLE [Security].[UserCompanies] ADD CONSTRAINT FK_UserCompanies_Users
    FOREIGN KEY (UserId) REFERENCES [Security].[Users](UserId);
ALTER TABLE [Security].[UserCompanies] ADD CONSTRAINT FK_UserCompanies_Companies
    FOREIGN KEY (CompanyId) REFERENCES [Core].[Companies](CompanyId);
GO

/* ---------------------------------------------------------------------------
   Performance indexes
--------------------------------------------------------------------------- */
CREATE INDEX IX_Customers_Company_Name
    ON [CRM].[Customers](CompanyId, LegalName)
    INCLUDE (CustomerNumber, IsActive);

CREATE INDEX IX_Customers_Company_TaxId
    ON [CRM].[Customers](CompanyId, TaxIdentificationNumber)
    WHERE TaxIdentificationNumber IS NOT NULL;

CREATE INDEX IX_Vendors_Company_Name
    ON [Procurement].[Vendors](CompanyId, LegalName)
    INCLUDE (VendorNumber, IsActive);

CREATE INDEX IX_Vendors_Company_TaxId
    ON [Procurement].[Vendors](CompanyId, TaxIdentificationNumber)
    WHERE TaxIdentificationNumber IS NOT NULL;

CREATE INDEX IX_Products_Company_Name
    ON [Inventory].[Products](CompanyId, Name)
    INCLUDE (SKU, UnitPrice, IsActive);

CREATE INDEX IX_Products_Company_Category
    ON [Inventory].[Products](CompanyId, ProductCategoryId)
    INCLUDE (SKU, Name, IsActive);

CREATE INDEX IX_SalesInvoices_Customer_Date
    ON [Sales].[SalesInvoices](CompanyId, CustomerId, InvoiceDate DESC)
    INCLUDE (InvoiceNumber, StatusCode, TotalAmount, DueDate);

CREATE INDEX IX_SalesInvoices_Status_Date
    ON [Sales].[SalesInvoices](CompanyId, StatusCode, InvoiceDate DESC)
    INCLUDE (CustomerId, TotalAmount);

CREATE INDEX IX_SalesInvoiceLines_Product
    ON [Sales].[SalesInvoiceLines](CompanyId, ProductId, SalesInvoiceId)
    INCLUDE (Quantity, LineTotal);

CREATE INDEX IX_CustomerPayments_Customer_Date
    ON [Sales].[CustomerPayments](CompanyId, CustomerId, PaymentDate DESC)
    INCLUDE (Amount, CurrencyId, ReferenceNumber);

CREATE INDEX IX_VendorInvoices_Vendor_Date
    ON [Procurement].[VendorInvoices](CompanyId, VendorId, InvoiceDate DESC)
    INCLUDE (InvoiceNumber, StatusCode, TotalAmount, DueDate);

CREATE INDEX IX_VendorInvoiceLines_Product
    ON [Procurement].[VendorInvoiceLines](CompanyId, ProductId, VendorInvoiceId)
    INCLUDE (Quantity, LineTotal);

CREATE INDEX IX_VendorPayments_Vendor_Date
    ON [Procurement].[VendorPayments](CompanyId, VendorId, PaymentDate DESC)
    INCLUDE (Amount, CurrencyId, ReferenceNumber);

CREATE INDEX IX_InventoryTransactions_Product_Warehouse_Date
    ON [Inventory].[InventoryTransactions](CompanyId, ProductId, WarehouseId, TransactionDate DESC)
    INCLUDE (Quantity, UnitCost, TransactionType, ReferenceType, ReferenceId);

CREATE INDEX IX_InventoryTransactions_Reference
    ON [Inventory].[InventoryTransactions](CompanyId, ReferenceType, ReferenceId);

CREATE INDEX IX_InventoryBalances_Product
    ON [Inventory].[InventoryBalances](CompanyId, ProductId)
    INCLUDE (WarehouseId, QuantityOnHand, QuantityReserved, AverageCost);

CREATE INDEX IX_JournalEntries_Date
    ON [Finance].[JournalEntries](CompanyId, EntryDate DESC)
    INCLUDE (EntryNumber, StatusCode, SourceModule, SourceType, SourceId);

CREATE INDEX IX_JournalEntries_Source
    ON [Finance].[JournalEntries](CompanyId, SourceModule, SourceType, SourceId);

CREATE INDEX IX_JournalEntryLines_Account
    ON [Finance].[JournalEntryLines](CompanyId, AccountId, JournalEntryId)
    INCLUDE (DebitAmount, CreditAmount);

CREATE INDEX IX_AR_Customer_DueDate
    ON [Finance].[AccountsReceivable](CompanyId, CustomerId, DueDate)
    INCLUDE (DebitAmount, CreditAmount, SalesInvoiceId);

CREATE INDEX IX_AP_Vendor_DueDate
    ON [Finance].[AccountsPayable](CompanyId, VendorId, DueDate)
    INCLUDE (DebitAmount, CreditAmount, VendorInvoiceId);

CREATE INDEX IX_AuditLog_Record
    ON [Audit].[AuditLog](SchemaName, TableName, RecordId, AuditDate DESC)
    INCLUDE (ActionType, CompanyId, UserId);

CREATE INDEX IX_AuditLog_Company_Date
    ON [Audit].[AuditLog](CompanyId, AuditDate DESC)
    INCLUDE (SchemaName, TableName, RecordId, ActionType, UserId);

CREATE INDEX IX_AuditLog_User_Date
    ON [Audit].[AuditLog](UserId, AuditDate DESC)
    INCLUDE (SchemaName, TableName, RecordId, ActionType, CompanyId);
GO

/* ---------------------------------------------------------------------------
   Application session context
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Security].[SetSessionContext]
    @UserId int,
    @CompanyId int,
    @ApplicationName nvarchar(128) = NULL,
    @CorrelationId uniqueidentifier = NULL
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Security].[Users] U
        INNER JOIN [Security].[UserCompanies] UC ON UC.UserId = U.UserId
        WHERE U.UserId = @UserId
          AND UC.CompanyId = @CompanyId
          AND U.IsActive = 1
    )
        THROW 51000, 'The user is not authorized for the selected company.', 1;

    EXEC sys.sp_set_session_context @key = N'UserId', @value = @UserId;
    EXEC sys.sp_set_session_context @key = N'CompanyId', @value = @CompanyId;
    EXEC sys.sp_set_session_context @key = N'ApplicationName', @value = @ApplicationName;
    EXEC sys.sp_set_session_context @key = N'CorrelationId', @value = @CorrelationId;
END;
GO
GRANT EXECUTE ON [Security].[SetSessionContext] TO [ProfitApp];
GO

/* ---------------------------------------------------------------------------
   Security administration helpers
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Security].[CreateApplicationUser]
    @UserName nvarchar(100),
    @DisplayName nvarchar(200) = NULL,
    @EmailAddress nvarchar(320) = NULL,
    @UserId int OUTPUT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    INSERT [Security].[Users](UserName, DisplayName, EmailAddress)
    VALUES (@UserName, @DisplayName, @EmailAddress);

    SET @UserId = CONVERT(int, SCOPE_IDENTITY());
END;
GO

CREATE OR ALTER PROCEDURE [Security].[GrantUserCompany]
    @UserId int,
    @CompanyId int,
    @IsDefault bit = 0
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [Security].[Users] WHERE UserId=@UserId AND IsActive=1)
        THROW 51003, 'Application user does not exist or is inactive.', 1;

    IF NOT EXISTS (SELECT 1 FROM [Core].[Companies] WHERE CompanyId=@CompanyId)
        THROW 51004, 'Company does not exist.', 1;

    IF @IsDefault = 1
        UPDATE [Security].[UserCompanies] SET IsDefault=0 WHERE UserId=@UserId;

    IF EXISTS (SELECT 1 FROM [Security].[UserCompanies] WHERE UserId=@UserId AND CompanyId=@CompanyId)
        UPDATE [Security].[UserCompanies] SET IsDefault=@IsDefault WHERE UserId=@UserId AND CompanyId=@CompanyId;
    ELSE
        INSERT [Security].[UserCompanies](UserId,CompanyId,IsDefault)
        VALUES (@UserId,@CompanyId,@IsDefault);
END;
GO

GRANT EXECUTE ON [Security].[CreateApplicationUser] TO [ERP_Admin];
GRANT EXECUTE ON [Security].[GrantUserCompany] TO [ERP_Admin];
GO

CREATE OR ALTER PROCEDURE [Security].[GrantApplicationRole]
    @UserName sysname,
    @RoleName sysname
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=@UserName AND type IN ('S','U','E','X'))
        THROW 51005, 'Database principal does not exist.', 1;
    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name=@RoleName AND type='R')
        THROW 51006, 'Database role does not exist.', 1;
    DECLARE @sql nvarchar(500) =
        N'ALTER ROLE ' + QUOTENAME(@RoleName) + N' ADD MEMBER ' + QUOTENAME(@UserName) + N';';
    EXEC sys.sp_executesql @sql;
END;
GO
GRANT EXECUTE ON [Security].[GrantApplicationRole] TO [ERP_Admin];
GO


/* ---------------------------------------------------------------------------
   Generic optimistic-concurrency helper
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Core].[TouchUpdatedAt]
    @TableName sysname,
    @IdColumn sysname,
    @IdValue bigint
AS
BEGIN
    SET NOCOUNT ON;
    /* Intentionally restricted: application tables should use rowversion.
       This procedure is retained only as a controlled extension point. */
    THROW 51001, 'Use rowversion-based updates instead of manually touching audit timestamps.', 1;
END;
GO

/* ---------------------------------------------------------------------------
   Core CRUD procedures
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [CRM].[CustomerCreate]
    @CompanyId int,
    @CustomerNumber nvarchar(50),
    @LegalName nvarchar(200),
    @TaxIdentificationNumber nvarchar(50) = NULL,
    @CountryId int,
    @StateId int = NULL,
    @EmailAddress nvarchar(320) = NULL,
    @CreditLimit decimal(19,4) = 0,
    @CustomerId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    INSERT [CRM].[Customers]
        (CompanyId, CustomerNumber, LegalName, TaxIdentificationNumber,
         CountryId, StateId, EmailAddress, CreditLimit)
    VALUES
        (@CompanyId, @CustomerNumber, @LegalName, @TaxIdentificationNumber,
         @CountryId, @StateId, @EmailAddress, @CreditLimit);

    SET @CustomerId = CONVERT(int, SCOPE_IDENTITY());
END;
GO

CREATE OR ALTER PROCEDURE [CRM].[CustomerUpdate]
    @CustomerId int,
    @CompanyId int,
    @LegalName nvarchar(200),
    @EmailAddress nvarchar(320) = NULL,
    @CreditLimit decimal(19,4),
    @IsActive bit,
    @RowVersion binary(8)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    UPDATE C
       SET LegalName = @LegalName,
           EmailAddress = @EmailAddress,
           CreditLimit = @CreditLimit,
           IsActive = @IsActive
    FROM [CRM].[Customers] C
    WHERE C.CustomerId = @CustomerId
      AND C.CompanyId = @CompanyId
      AND C.RowVersion = @RowVersion;

    IF @@ROWCOUNT = 0
        THROW 51002, 'Customer was not found or was changed by another transaction.', 1;
END;
GO

CREATE OR ALTER PROCEDURE [CRM].[CustomerGet]
    @CompanyId int,
    @CustomerId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM [CRM].[Customers]
    WHERE CompanyId = @CompanyId
      AND CustomerId = @CustomerId;
END;
GO

CREATE OR ALTER PROCEDURE [Procurement].[VendorCreate]
    @CompanyId int,
    @VendorNumber nvarchar(50),
    @LegalName nvarchar(200),
    @TaxIdentificationNumber nvarchar(50) = NULL,
    @CountryId int,
    @StateId int = NULL,
    @EmailAddress nvarchar(320) = NULL,
    @CreditLimit decimal(19,4) = 0,
    @VendorId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    INSERT [Procurement].[Vendors]
        (CompanyId, VendorNumber, LegalName, TaxIdentificationNumber,
         CountryId, StateId, EmailAddress, CreditLimit)
    VALUES
        (@CompanyId, @VendorNumber, @LegalName, @TaxIdentificationNumber,
         @CountryId, @StateId, @EmailAddress, @CreditLimit);

    SET @VendorId = CONVERT(int, SCOPE_IDENTITY());
END;
GO

CREATE OR ALTER PROCEDURE [Procurement].[VendorGet]
    @CompanyId int,
    @VendorId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM [Procurement].[Vendors]
    WHERE CompanyId = @CompanyId
      AND VendorId = @VendorId;
END;
GO

/* ---------------------------------------------------------------------------
   Sales invoice posting - transactionally creates AR and inventory movement.
   The procedure expects invoice lines to already exist.
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Sales].[PostSalesInvoice]
    @CompanyId int,
    @SalesInvoiceId bigint
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Status nvarchar(30);

    BEGIN TRANSACTION;

    SELECT @Status = StatusCode
    FROM [Sales].[SalesInvoices] WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId
      AND SalesInvoiceId = @SalesInvoiceId;

    IF @Status IS NULL
        THROW 51010, 'Sales invoice not found.', 1;

    IF @Status = N'POSTED'
    BEGIN
        COMMIT;
        RETURN;
    END;

    IF @Status <> N'DRAFT'
        THROW 51011, 'Only DRAFT sales invoices can be posted.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Sales].[SalesInvoiceLines]
        WHERE CompanyId = @CompanyId
          AND SalesInvoiceId = @SalesInvoiceId
    )
        THROW 51012, 'Sales invoice must contain at least one line.', 1;

    UPDATE [Sales].[SalesInvoices]
       SET StatusCode = N'POSTED'
     WHERE CompanyId = @CompanyId
       AND SalesInvoiceId = @SalesInvoiceId;

    INSERT [Finance].[AccountsReceivable]
        (CompanyId, CustomerId, SalesInvoiceId, TransactionDate, DueDate,
         DebitAmount, CreditAmount, CurrencyId, ExchangeRate,
         ReferenceType, ReferenceId)
    SELECT CompanyId, CustomerId, SalesInvoiceId, InvoiceDate, DueDate,
           TotalAmount, 0, CurrencyId, ExchangeRate,
           N'SalesInvoice', SalesInvoiceId
    FROM [Sales].[SalesInvoices]
    WHERE CompanyId = @CompanyId
      AND SalesInvoiceId = @SalesInvoiceId;

    COMMIT;
END;
GO

/* ---------------------------------------------------------------------------
   Purchase invoice posting
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Procurement].[PostVendorInvoice]
    @CompanyId int,
    @VendorInvoiceId bigint
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Status nvarchar(30);

    BEGIN TRANSACTION;

    SELECT @Status = StatusCode
    FROM [Procurement].[VendorInvoices] WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId
      AND VendorInvoiceId = @VendorInvoiceId;

    IF @Status IS NULL
        THROW 51020, 'Vendor invoice not found.', 1;

    IF @Status = N'POSTED'
    BEGIN
        COMMIT;
        RETURN;
    END;

    IF @Status <> N'DRAFT'
        THROW 51021, 'Only DRAFT vendor invoices can be posted.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Procurement].[VendorInvoiceLines]
        WHERE CompanyId = @CompanyId
          AND VendorInvoiceId = @VendorInvoiceId
    )
        THROW 51022, 'Vendor invoice must contain at least one line.', 1;

    UPDATE [Procurement].[VendorInvoices]
       SET StatusCode = N'POSTED'
     WHERE CompanyId = @CompanyId
       AND VendorInvoiceId = @VendorInvoiceId;

    INSERT [Finance].[AccountsPayable]
        (CompanyId, VendorId, VendorInvoiceId, TransactionDate, DueDate,
         DebitAmount, CreditAmount, CurrencyId, ExchangeRate,
         ReferenceType, ReferenceId)
    SELECT CompanyId, VendorId, VendorInvoiceId, InvoiceDate, DueDate,
           0, TotalAmount, CurrencyId, ExchangeRate,
           N'VendorInvoice', VendorInvoiceId
    FROM [Procurement].[VendorInvoices]
    WHERE CompanyId = @CompanyId
      AND VendorInvoiceId = @VendorInvoiceId;

    COMMIT;
END;
GO

/* ---------------------------------------------------------------------------
   Journal validation / posting
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Finance].[PostJournalEntry]
    @CompanyId int,
    @JournalEntryId bigint
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Debit decimal(19,4), @Credit decimal(19,4), @Status nvarchar(30);

    BEGIN TRANSACTION;

    SELECT @Status = StatusCode
    FROM [Finance].[JournalEntries] WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId
      AND JournalEntryId = @JournalEntryId;

    IF @Status IS NULL
        THROW 51030, 'Journal entry not found.', 1;

    IF @Status = N'POSTED'
    BEGIN
        COMMIT;
        RETURN;
    END;

    SELECT
        @Debit = SUM(DebitAmount),
        @Credit = SUM(CreditAmount)
    FROM [Finance].[JournalEntryLines]
    WHERE CompanyId = @CompanyId
      AND JournalEntryId = @JournalEntryId;

    IF ISNULL(@Debit,0) = 0 OR ISNULL(@Debit,0) <> ISNULL(@Credit,0)
        THROW 51031, 'Journal entry is not balanced.', 1;

    UPDATE [Finance].[JournalEntries]
       SET StatusCode = N'POSTED'
     WHERE CompanyId = @CompanyId
       AND JournalEntryId = @JournalEntryId;

    COMMIT;
END;
GO

/* ---------------------------------------------------------------------------
   Inventory movement procedure
--------------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE [Inventory].[PostInventoryTransaction]
    @CompanyId int,
    @ProductId int,
    @WarehouseId int,
    @Quantity decimal(19,6),
    @TransactionType nvarchar(40),
    @UnitCost decimal(19,8) = NULL,
    @ReferenceType nvarchar(50) = NULL,
    @ReferenceId bigint = NULL,
    @Remarks nvarchar(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @Quantity = 0
        THROW 51040, 'Inventory quantity cannot be zero.', 1;

    BEGIN TRANSACTION;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Inventory].[InventoryBalances] WITH (UPDLOCK, HOLDLOCK)
        WHERE CompanyId = @CompanyId
          AND ProductId = @ProductId
          AND WarehouseId = @WarehouseId
    )
    BEGIN
        INSERT [Inventory].[InventoryBalances]
            (CompanyId, ProductId, WarehouseId)
        VALUES
            (@CompanyId, @ProductId, @WarehouseId);
    END;

    INSERT [Inventory].[InventoryTransactions]
        (CompanyId, ProductId, WarehouseId, Quantity, UnitCost,
         TransactionType, ReferenceType, ReferenceId, Remarks)
    VALUES
        (@CompanyId, @ProductId, @WarehouseId, @Quantity, @UnitCost,
         @TransactionType, @ReferenceType, @ReferenceId, @Remarks);

    UPDATE B
       SET QuantityOnHand = QuantityOnHand + @Quantity,
           AverageCost =
             CASE
               WHEN @UnitCost IS NULL THEN AverageCost
               WHEN QuantityOnHand + @Quantity <= 0 THEN @UnitCost
               ELSE ((QuantityOnHand * AverageCost) + (@Quantity * @UnitCost))
                    / NULLIF(QuantityOnHand + @Quantity, 0)
             END
    FROM [Inventory].[InventoryBalances] B
    WHERE CompanyId = @CompanyId
      AND ProductId = @ProductId
      AND WarehouseId = @WarehouseId;

    COMMIT;
END;
GO

/* ---------------------------------------------------------------------------
   Centralized AuditLog triggers
   One audit row is written for each affected row. OldValues/NewValues contain
   the complete row image as JSON. ChangedColumns is reserved for a future
   column-diff optimization; full row images are authoritative.
--------------------------------------------------------------------------- */

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_Companies]
ON [Core].[Companies]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[CompanyId] IS NULL THEN 'DELETE'
             WHEN d.[CompanyId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'Companies',
        COALESCE(CONVERT(bigint, i.[CompanyId]), CONVERT(bigint, d.[CompanyId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CompanyId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CompanyId] = COALESCE(i.[CompanyId], d.[CompanyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CompanyId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CompanyId] = COALESCE(i.[CompanyId], d.[CompanyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CompanyId] = d.[CompanyId];
END;
GO

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_ExchangeRates]
ON [Core].[ExchangeRates]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[ExchangeRateId] IS NULL THEN 'DELETE'
             WHEN d.[ExchangeRateId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'ExchangeRates',
        COALESCE(CONVERT(bigint, i.[ExchangeRateId]), CONVERT(bigint, d.[ExchangeRateId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ExchangeRateId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ExchangeRateId] = COALESCE(i.[ExchangeRateId], d.[ExchangeRateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ExchangeRateId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ExchangeRateId] = COALESCE(i.[ExchangeRateId], d.[ExchangeRateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ExchangeRateId] = d.[ExchangeRateId];
END;
GO

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_FiscalYears]
ON [Core].[FiscalYears]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[FiscalYearId] IS NULL THEN 'DELETE'
             WHEN d.[FiscalYearId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'FiscalYears',
        COALESCE(CONVERT(bigint, i.[FiscalYearId]), CONVERT(bigint, d.[FiscalYearId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[FiscalYearId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[FiscalYearId] = COALESCE(i.[FiscalYearId], d.[FiscalYearId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[FiscalYearId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[FiscalYearId] = COALESCE(i.[FiscalYearId], d.[FiscalYearId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[FiscalYearId] = d.[FiscalYearId];
END;
GO

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_AccountingPeriods]
ON [Core].[AccountingPeriods]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[AccountingPeriodId] IS NULL THEN 'DELETE'
             WHEN d.[AccountingPeriodId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'AccountingPeriods',
        COALESCE(CONVERT(bigint, i.[AccountingPeriodId]), CONVERT(bigint, d.[AccountingPeriodId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[AccountingPeriodId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[AccountingPeriodId] = COALESCE(i.[AccountingPeriodId], d.[AccountingPeriodId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[AccountingPeriodId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[AccountingPeriodId] = COALESCE(i.[AccountingPeriodId], d.[AccountingPeriodId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[AccountingPeriodId] = d.[AccountingPeriodId];
END;
GO

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_Currencies]
ON [Core].[Currencies]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[CurrencyId] IS NULL THEN 'DELETE'
             WHEN d.[CurrencyId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core', N'Currencies',
        COALESCE(CONVERT(bigint,i.[CurrencyId]),CONVERT(bigint,d.[CurrencyId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[CurrencyId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[CurrencyId]=COALESCE(i.[CurrencyId],d.[CurrencyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[CurrencyId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[CurrencyId]=COALESCE(i.[CurrencyId],d.[CurrencyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CurrencyId]=d.[CurrencyId];
END;
GO

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_Countries]
ON [Core].[Countries]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[CountryId] IS NULL THEN 'DELETE'
             WHEN d.[CountryId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core', N'Countries',
        COALESCE(CONVERT(bigint,i.[CountryId]),CONVERT(bigint,d.[CountryId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[CountryId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[CountryId]=COALESCE(i.[CountryId],d.[CountryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[CountryId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[CountryId]=COALESCE(i.[CountryId],d.[CountryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CountryId]=d.[CountryId];
END;
GO

CREATE OR ALTER TRIGGER [Core].[tr_Audit_Core_States]
ON [Core].[States]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[StateId] IS NULL THEN 'DELETE'
             WHEN d.[StateId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core', N'States',
        COALESCE(CONVERT(bigint,i.[StateId]),CONVERT(bigint,d.[StateId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[StateId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[StateId]=COALESCE(i.[StateId],d.[StateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[StateId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[StateId]=COALESCE(i.[StateId],d.[StateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[StateId]=d.[StateId];
END;
GO

CREATE OR ALTER TRIGGER [CRM].[tr_Audit_CRM_Customers]
ON [CRM].[Customers]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[CustomerId] IS NULL THEN 'DELETE'
             WHEN d.[CustomerId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'CRM',
        N'Customers',
        COALESCE(CONVERT(bigint, i.[CustomerId]), CONVERT(bigint, d.[CustomerId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CustomerId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CustomerId] = COALESCE(i.[CustomerId], d.[CustomerId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CustomerId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CustomerId] = COALESCE(i.[CustomerId], d.[CustomerId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CustomerId] = d.[CustomerId];
END;
GO

CREATE OR ALTER TRIGGER [CRM].[tr_Audit_CRM_CustomerContacts]
ON [CRM].[CustomerContacts]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[CustomerContactId] IS NULL THEN 'DELETE'
             WHEN d.[CustomerContactId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'CRM',
        N'CustomerContacts',
        COALESCE(CONVERT(bigint, i.[CustomerContactId]), CONVERT(bigint, d.[CustomerContactId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CustomerContactId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CustomerContactId] = COALESCE(i.[CustomerContactId], d.[CustomerContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CustomerContactId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CustomerContactId] = COALESCE(i.[CustomerContactId], d.[CustomerContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CustomerContactId] = d.[CustomerContactId];
END;
GO

CREATE OR ALTER TRIGGER [HR].[tr_Audit_HR_Departments]
ON [HR].[Departments]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[DepartmentId] IS NULL THEN 'DELETE'
             WHEN d.[DepartmentId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'HR',
        N'Departments',
        COALESCE(CONVERT(bigint, i.[DepartmentId]), CONVERT(bigint, d.[DepartmentId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[DepartmentId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[DepartmentId] = COALESCE(i.[DepartmentId], d.[DepartmentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[DepartmentId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[DepartmentId] = COALESCE(i.[DepartmentId], d.[DepartmentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[DepartmentId] = d.[DepartmentId];
END;
GO

CREATE OR ALTER TRIGGER [HR].[tr_Audit_HR_EmployeeProfiles]
ON [HR].[EmployeeProfiles]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[EmployeeProfileId] IS NULL THEN 'DELETE'
             WHEN d.[EmployeeProfileId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'HR',
        N'EmployeeProfiles',
        COALESCE(CONVERT(bigint, i.[EmployeeProfileId]), CONVERT(bigint, d.[EmployeeProfileId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[EmployeeProfileId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[EmployeeProfileId] = COALESCE(i.[EmployeeProfileId], d.[EmployeeProfileId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[EmployeeProfileId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[EmployeeProfileId] = COALESCE(i.[EmployeeProfileId], d.[EmployeeProfileId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[EmployeeProfileId] = d.[EmployeeProfileId];
END;
GO

CREATE OR ALTER TRIGGER [HR].[tr_Audit_HR_Employees]
ON [HR].[Employees]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[EmployeeId] IS NULL THEN 'DELETE'
             WHEN d.[EmployeeId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'HR',
        N'Employees',
        COALESCE(CONVERT(bigint, i.[EmployeeId]), CONVERT(bigint, d.[EmployeeId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[EmployeeId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[EmployeeId] = COALESCE(i.[EmployeeId], d.[EmployeeId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[EmployeeId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[EmployeeId] = COALESCE(i.[EmployeeId], d.[EmployeeId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[EmployeeId] = d.[EmployeeId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_Vendors]
ON [Procurement].[Vendors]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[VendorId] IS NULL THEN 'DELETE'
             WHEN d.[VendorId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'Vendors',
        COALESCE(CONVERT(bigint, i.[VendorId]), CONVERT(bigint, d.[VendorId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorId] = COALESCE(i.[VendorId], d.[VendorId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorId] = COALESCE(i.[VendorId], d.[VendorId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorId] = d.[VendorId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_VendorContacts]
ON [Procurement].[VendorContacts]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[VendorContactId] IS NULL THEN 'DELETE'
             WHEN d.[VendorContactId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorContacts',
        COALESCE(CONVERT(bigint, i.[VendorContactId]), CONVERT(bigint, d.[VendorContactId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorContactId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorContactId] = COALESCE(i.[VendorContactId], d.[VendorContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorContactId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorContactId] = COALESCE(i.[VendorContactId], d.[VendorContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorContactId] = d.[VendorContactId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_PurchaseOrders]
ON [Procurement].[PurchaseOrders]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[PurchaseOrderId] IS NULL THEN 'DELETE'
             WHEN d.[PurchaseOrderId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'PurchaseOrders',
        COALESCE(CONVERT(bigint, i.[PurchaseOrderId]), CONVERT(bigint, d.[PurchaseOrderId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[PurchaseOrderId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[PurchaseOrderId] = COALESCE(i.[PurchaseOrderId], d.[PurchaseOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[PurchaseOrderId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[PurchaseOrderId] = COALESCE(i.[PurchaseOrderId], d.[PurchaseOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[PurchaseOrderId] = d.[PurchaseOrderId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_PurchaseOrderLines]
ON [Procurement].[PurchaseOrderLines]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[PurchaseOrderLineId] IS NULL THEN 'DELETE'
             WHEN d.[PurchaseOrderLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'PurchaseOrderLines',
        COALESCE(CONVERT(bigint, i.[PurchaseOrderLineId]), CONVERT(bigint, d.[PurchaseOrderLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[PurchaseOrderLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[PurchaseOrderLineId] = COALESCE(i.[PurchaseOrderLineId], d.[PurchaseOrderLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[PurchaseOrderLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[PurchaseOrderLineId] = COALESCE(i.[PurchaseOrderLineId], d.[PurchaseOrderLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[PurchaseOrderLineId] = d.[PurchaseOrderLineId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_VendorInvoices]
ON [Procurement].[VendorInvoices]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[VendorInvoiceId] IS NULL THEN 'DELETE'
             WHEN d.[VendorInvoiceId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorInvoices',
        COALESCE(CONVERT(bigint, i.[VendorInvoiceId]), CONVERT(bigint, d.[VendorInvoiceId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorInvoiceId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorInvoiceId] = COALESCE(i.[VendorInvoiceId], d.[VendorInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorInvoiceId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorInvoiceId] = COALESCE(i.[VendorInvoiceId], d.[VendorInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorInvoiceId] = d.[VendorInvoiceId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_VendorInvoiceLines]
ON [Procurement].[VendorInvoiceLines]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[VendorInvoiceLineId] IS NULL THEN 'DELETE'
             WHEN d.[VendorInvoiceLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorInvoiceLines',
        COALESCE(CONVERT(bigint, i.[VendorInvoiceLineId]), CONVERT(bigint, d.[VendorInvoiceLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorInvoiceLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorInvoiceLineId] = COALESCE(i.[VendorInvoiceLineId], d.[VendorInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorInvoiceLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorInvoiceLineId] = COALESCE(i.[VendorInvoiceLineId], d.[VendorInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorInvoiceLineId] = d.[VendorInvoiceLineId];
END;
GO

CREATE OR ALTER TRIGGER [Procurement].[tr_Audit_Procurement_VendorPayments]
ON [Procurement].[VendorPayments]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[VendorPaymentId] IS NULL THEN 'DELETE'
             WHEN d.[VendorPaymentId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorPayments',
        COALESCE(CONVERT(bigint, i.[VendorPaymentId]), CONVERT(bigint, d.[VendorPaymentId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorPaymentId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorPaymentId] = COALESCE(i.[VendorPaymentId], d.[VendorPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorPaymentId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorPaymentId] = COALESCE(i.[VendorPaymentId], d.[VendorPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorPaymentId] = d.[VendorPaymentId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_ProductCategories]
ON [Inventory].[ProductCategories]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[ProductCategoryId] IS NULL THEN 'DELETE'
             WHEN d.[ProductCategoryId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'ProductCategories',
        COALESCE(CONVERT(bigint, i.[ProductCategoryId]), CONVERT(bigint, d.[ProductCategoryId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ProductCategoryId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ProductCategoryId] = COALESCE(i.[ProductCategoryId], d.[ProductCategoryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ProductCategoryId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ProductCategoryId] = COALESCE(i.[ProductCategoryId], d.[ProductCategoryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ProductCategoryId] = d.[ProductCategoryId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_Warehouses]
ON [Inventory].[Warehouses]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[WarehouseId] IS NULL THEN 'DELETE'
             WHEN d.[WarehouseId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'Warehouses',
        COALESCE(CONVERT(bigint, i.[WarehouseId]), CONVERT(bigint, d.[WarehouseId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[WarehouseId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[WarehouseId] = COALESCE(i.[WarehouseId], d.[WarehouseId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[WarehouseId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[WarehouseId] = COALESCE(i.[WarehouseId], d.[WarehouseId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[WarehouseId] = d.[WarehouseId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_Products]
ON [Inventory].[Products]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[ProductId] IS NULL THEN 'DELETE'
             WHEN d.[ProductId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'Products',
        COALESCE(CONVERT(bigint, i.[ProductId]), CONVERT(bigint, d.[ProductId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ProductId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ProductId] = COALESCE(i.[ProductId], d.[ProductId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ProductId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ProductId] = COALESCE(i.[ProductId], d.[ProductId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ProductId] = d.[ProductId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_InventoryBalances]
ON [Inventory].[InventoryBalances]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[InventoryBalanceId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryBalanceId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryBalances',
        COALESCE(CONVERT(bigint, i.[InventoryBalanceId]), CONVERT(bigint, d.[InventoryBalanceId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryBalanceId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryBalanceId] = COALESCE(i.[InventoryBalanceId], d.[InventoryBalanceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryBalanceId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryBalanceId] = COALESCE(i.[InventoryBalanceId], d.[InventoryBalanceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryBalanceId] = d.[InventoryBalanceId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_InventoryTransactions]
ON [Inventory].[InventoryTransactions]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[InventoryTransactionId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryTransactionId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryTransactions',
        COALESCE(CONVERT(bigint, i.[InventoryTransactionId]), CONVERT(bigint, d.[InventoryTransactionId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryTransactionId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryTransactionId] = COALESCE(i.[InventoryTransactionId], d.[InventoryTransactionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryTransactionId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryTransactionId] = COALESCE(i.[InventoryTransactionId], d.[InventoryTransactionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryTransactionId] = d.[InventoryTransactionId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_InventoryTransfers]
ON [Inventory].[InventoryTransfers]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[InventoryTransferId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryTransferId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryTransfers',
        COALESCE(CONVERT(bigint, i.[InventoryTransferId]), CONVERT(bigint, d.[InventoryTransferId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryTransferId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryTransferId] = COALESCE(i.[InventoryTransferId], d.[InventoryTransferId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryTransferId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryTransferId] = COALESCE(i.[InventoryTransferId], d.[InventoryTransferId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryTransferId] = d.[InventoryTransferId];
END;
GO

CREATE OR ALTER TRIGGER [Inventory].[tr_Audit_Inventory_InventoryTransferLines]
ON [Inventory].[InventoryTransferLines]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[InventoryTransferLineId] IS NULL THEN 'DELETE'
             WHEN d.[InventoryTransferLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Inventory',
        N'InventoryTransferLines',
        COALESCE(CONVERT(bigint, i.[InventoryTransferLineId]), CONVERT(bigint, d.[InventoryTransferLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[InventoryTransferLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[InventoryTransferLineId] = COALESCE(i.[InventoryTransferLineId], d.[InventoryTransferLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[InventoryTransferLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[InventoryTransferLineId] = COALESCE(i.[InventoryTransferLineId], d.[InventoryTransferLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[InventoryTransferLineId] = d.[InventoryTransferLineId];
END;
GO

CREATE OR ALTER TRIGGER [Sales].[tr_Audit_Sales_SalesOrders]
ON [Sales].[SalesOrders]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[SalesOrderId] IS NULL THEN 'DELETE'
             WHEN d.[SalesOrderId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesOrders',
        COALESCE(CONVERT(bigint, i.[SalesOrderId]), CONVERT(bigint, d.[SalesOrderId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesOrderId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesOrderId] = COALESCE(i.[SalesOrderId], d.[SalesOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesOrderId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesOrderId] = COALESCE(i.[SalesOrderId], d.[SalesOrderId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesOrderId] = d.[SalesOrderId];
END;
GO

CREATE OR ALTER TRIGGER [Sales].[tr_Audit_Sales_SalesOrderLines]
ON [Sales].[SalesOrderLines]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[SalesOrderLineId] IS NULL THEN 'DELETE'
             WHEN d.[SalesOrderLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesOrderLines',
        COALESCE(CONVERT(bigint, i.[SalesOrderLineId]), CONVERT(bigint, d.[SalesOrderLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesOrderLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesOrderLineId] = COALESCE(i.[SalesOrderLineId], d.[SalesOrderLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesOrderLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesOrderLineId] = COALESCE(i.[SalesOrderLineId], d.[SalesOrderLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesOrderLineId] = d.[SalesOrderLineId];
END;
GO

CREATE OR ALTER TRIGGER [Sales].[tr_Audit_Sales_SalesInvoices]
ON [Sales].[SalesInvoices]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[SalesInvoiceId] IS NULL THEN 'DELETE'
             WHEN d.[SalesInvoiceId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesInvoices',
        COALESCE(CONVERT(bigint, i.[SalesInvoiceId]), CONVERT(bigint, d.[SalesInvoiceId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesInvoiceId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesInvoiceId] = COALESCE(i.[SalesInvoiceId], d.[SalesInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesInvoiceId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesInvoiceId] = COALESCE(i.[SalesInvoiceId], d.[SalesInvoiceId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesInvoiceId] = d.[SalesInvoiceId];
END;
GO

CREATE OR ALTER TRIGGER [Sales].[tr_Audit_Sales_SalesInvoiceLines]
ON [Sales].[SalesInvoiceLines]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[SalesInvoiceLineId] IS NULL THEN 'DELETE'
             WHEN d.[SalesInvoiceLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesInvoiceLines',
        COALESCE(CONVERT(bigint, i.[SalesInvoiceLineId]), CONVERT(bigint, d.[SalesInvoiceLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesInvoiceLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesInvoiceLineId] = COALESCE(i.[SalesInvoiceLineId], d.[SalesInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesInvoiceLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesInvoiceLineId] = COALESCE(i.[SalesInvoiceLineId], d.[SalesInvoiceLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesInvoiceLineId] = d.[SalesInvoiceLineId];
END;
GO

CREATE OR ALTER TRIGGER [Sales].[tr_Audit_Sales_CustomerPayments]
ON [Sales].[CustomerPayments]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[CustomerPaymentId] IS NULL THEN 'DELETE'
             WHEN d.[CustomerPaymentId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'CustomerPayments',
        COALESCE(CONVERT(bigint, i.[CustomerPaymentId]), CONVERT(bigint, d.[CustomerPaymentId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CustomerPaymentId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CustomerPaymentId] = COALESCE(i.[CustomerPaymentId], d.[CustomerPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CustomerPaymentId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CustomerPaymentId] = COALESCE(i.[CustomerPaymentId], d.[CustomerPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CustomerPaymentId] = d.[CustomerPaymentId];
END;
GO

CREATE OR ALTER TRIGGER [Sales].[tr_Audit_Sales_SalesCommissions]
ON [Sales].[SalesCommissions]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[SalesCommissionId] IS NULL THEN 'DELETE'
             WHEN d.[SalesCommissionId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesCommissions',
        COALESCE(CONVERT(bigint, i.[SalesCommissionId]), CONVERT(bigint, d.[SalesCommissionId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesCommissionId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesCommissionId] = COALESCE(i.[SalesCommissionId], d.[SalesCommissionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesCommissionId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesCommissionId] = COALESCE(i.[SalesCommissionId], d.[SalesCommissionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesCommissionId] = d.[SalesCommissionId];
END;
GO

CREATE OR ALTER TRIGGER [Finance].[tr_Audit_Finance_ChartOfAccounts]
ON [Finance].[ChartOfAccounts]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[AccountId] IS NULL THEN 'DELETE'
             WHEN d.[AccountId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'ChartOfAccounts',
        COALESCE(CONVERT(bigint, i.[AccountId]), CONVERT(bigint, d.[AccountId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[AccountId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[AccountId] = COALESCE(i.[AccountId], d.[AccountId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[AccountId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[AccountId] = COALESCE(i.[AccountId], d.[AccountId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[AccountId] = d.[AccountId];
END;
GO

CREATE OR ALTER TRIGGER [Finance].[tr_Audit_Finance_JournalEntries]
ON [Finance].[JournalEntries]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[JournalEntryId] IS NULL THEN 'DELETE'
             WHEN d.[JournalEntryId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'JournalEntries',
        COALESCE(CONVERT(bigint, i.[JournalEntryId]), CONVERT(bigint, d.[JournalEntryId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[JournalEntryId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[JournalEntryId] = COALESCE(i.[JournalEntryId], d.[JournalEntryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[JournalEntryId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[JournalEntryId] = COALESCE(i.[JournalEntryId], d.[JournalEntryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[JournalEntryId] = d.[JournalEntryId];
END;
GO

CREATE OR ALTER TRIGGER [Finance].[tr_Audit_Finance_JournalEntryLines]
ON [Finance].[JournalEntryLines]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[JournalEntryLineId] IS NULL THEN 'DELETE'
             WHEN d.[JournalEntryLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'JournalEntryLines',
        COALESCE(CONVERT(bigint, i.[JournalEntryLineId]), CONVERT(bigint, d.[JournalEntryLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[JournalEntryLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[JournalEntryLineId] = COALESCE(i.[JournalEntryLineId], d.[JournalEntryLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[JournalEntryLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[JournalEntryLineId] = COALESCE(i.[JournalEntryLineId], d.[JournalEntryLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[JournalEntryLineId] = d.[JournalEntryLineId];
END;
GO

CREATE OR ALTER TRIGGER [Finance].[tr_Audit_Finance_AccountsReceivable]
ON [Finance].[AccountsReceivable]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[ReceivableId] IS NULL THEN 'DELETE'
             WHEN d.[ReceivableId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'AccountsReceivable',
        COALESCE(CONVERT(bigint, i.[ReceivableId]), CONVERT(bigint, d.[ReceivableId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ReceivableId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ReceivableId] = COALESCE(i.[ReceivableId], d.[ReceivableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ReceivableId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ReceivableId] = COALESCE(i.[ReceivableId], d.[ReceivableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ReceivableId] = d.[ReceivableId];
END;
GO

CREATE OR ALTER TRIGGER [Finance].[tr_Audit_Finance_AccountsPayable]
ON [Finance].[AccountsPayable]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[PayableId] IS NULL THEN 'DELETE'
             WHEN d.[PayableId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'AccountsPayable',
        COALESCE(CONVERT(bigint, i.[PayableId]), CONVERT(bigint, d.[PayableId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[PayableId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[PayableId] = COALESCE(i.[PayableId], d.[PayableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[PayableId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[PayableId] = COALESCE(i.[PayableId], d.[PayableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[PayableId] = d.[PayableId];
END;
GO

CREATE OR ALTER TRIGGER [Security].[tr_Audit_Security_Users]
ON [Security].[Users]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[UserId] IS NULL THEN 'DELETE'
             WHEN d.[UserId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Security', N'Users',
        COALESCE(CONVERT(bigint,i.[UserId]),CONVERT(bigint,d.[UserId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[UserId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[UserId]=COALESCE(i.[UserId],d.[UserId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[UserId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[UserId]=COALESCE(i.[UserId],d.[UserId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[UserId]=d.[UserId];
END;
GO

CREATE OR ALTER TRIGGER [Security].[tr_Audit_Security_UserCompanies]
ON [Security].[UserCompanies]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.UserId IS NULL THEN 'DELETE'
             WHEN d.UserId IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Security', N'UserCompanies',
        CONVERT(bigint, COALESCE(i.UserId,d.UserId)),
        COALESCE(i.CompanyId,d.CompanyId,@SessionCompanyId),
        @UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.UserId IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2
              WHERE d2.UserId=COALESCE(i.UserId,d.UserId)
                AND d2.CompanyId=COALESCE(i.CompanyId,d.CompanyId)
              FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.UserId IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2
              WHERE i2.UserId=COALESCE(i.UserId,d.UserId)
                AND i2.CompanyId=COALESCE(i.CompanyId,d.CompanyId)
              FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d
      ON i.UserId=d.UserId AND i.CompanyId=d.CompanyId;
END;
GO
/* ---------------------------------------------------------------------------
   Security grants
--------------------------------------------------------------------------- */
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_ReadOnly];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_Sales];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_Procurement];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_Inventory];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_Finance];
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_HR];

GRANT SELECT ON SCHEMA::[Core] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[Reference] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[CRM] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[Sales] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[Procurement] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[Inventory] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[Finance] TO [ERP_ReadOnly];
GRANT SELECT ON SCHEMA::[HR] TO [ERP_ReadOnly];

GRANT SELECT, INSERT, UPDATE ON SCHEMA::[CRM] TO [ERP_Sales];
GRANT SELECT, EXECUTE ON SCHEMA::[Sales] TO [ERP_Sales];
GRANT SELECT ON SCHEMA::[Inventory] TO [ERP_Sales];
GRANT SELECT ON SCHEMA::[Core] TO [ERP_Sales];
GRANT SELECT ON SCHEMA::[Reference] TO [ERP_Sales];

GRANT SELECT, INSERT, UPDATE ON SCHEMA::[Procurement] TO [ERP_Procurement];
GRANT SELECT, EXECUTE ON SCHEMA::[Inventory] TO [ERP_Procurement];
GRANT SELECT ON SCHEMA::[Core] TO [ERP_Procurement];
GRANT SELECT ON SCHEMA::[Reference] TO [ERP_Procurement];

GRANT SELECT, INSERT, UPDATE ON SCHEMA::[Inventory] TO [ERP_Inventory];
GRANT EXECUTE ON SCHEMA::[Inventory] TO [ERP_Inventory];
GRANT SELECT ON SCHEMA::[Core] TO [ERP_Inventory];
GRANT SELECT ON SCHEMA::[Reference] TO [ERP_Inventory];

GRANT SELECT, INSERT, UPDATE ON SCHEMA::[Finance] TO [ERP_Finance];
GRANT EXECUTE ON SCHEMA::[Finance] TO [ERP_Finance];
GRANT SELECT ON SCHEMA::[Core] TO [ERP_Finance];
GRANT SELECT ON SCHEMA::[Reference] TO [ERP_Finance];
GRANT SELECT ON SCHEMA::[CRM] TO [ERP_Finance];
GRANT SELECT ON SCHEMA::[Procurement] TO [ERP_Finance];

GRANT SELECT, INSERT, UPDATE ON SCHEMA::[HR] TO [ERP_HR];
GRANT SELECT ON SCHEMA::[Core] TO [ERP_HR];

GRANT SELECT ON SCHEMA::[Audit] TO [ERP_Auditor];
GRANT SELECT ON SCHEMA::[Core] TO [ERP_Auditor];
GRANT SELECT ON SCHEMA::[Finance] TO [ERP_Auditor];
GRANT SELECT ON SCHEMA::[Sales] TO [ERP_Auditor];
GRANT SELECT ON SCHEMA::[Procurement] TO [ERP_Auditor];
GRANT SELECT ON SCHEMA::[Inventory] TO [ERP_Auditor];
GO

/* Administrative role */
GRANT CONTROL ON DATABASE::[Profit] TO [ERP_Admin];
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[Audit] TO [ERP_Admin];
GRANT EXECUTE ON SCHEMA::[Audit] TO [ERP_Admin];
GO

/* ---------------------------------------------------------------------------
   Row-Level Security
   The application must execute Security.SetSessionContext first.
--------------------------------------------------------------------------- */
CREATE OR ALTER FUNCTION [Security].[fn_CompanyAccessPredicate]
(
    @CompanyId int
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 1 AS AccessResult
    WHERE
        IS_MEMBER(N'ERP_Admin') = 1
        OR
        EXISTS
        (
            SELECT 1
            FROM [Security].[UserCompanies] UC
            INNER JOIN [Security].[Users] U
                ON U.UserId = UC.UserId
            WHERE UC.CompanyId = @CompanyId
              AND UC.UserId = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'))
              AND U.IsActive = 1
        )
);
GO

CREATE SECURITY POLICY [Security].[CompanySecurityPolicy]
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId)
ON [Core].[Companies],
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId)
ON [Core].[ExchangeRates],
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId)
ON [Core].[FiscalYears],
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId)
ON [Core].[AccountingPeriods],
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [CRM].[Customers],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [CRM].[Customers] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [CRM].[CustomerContacts],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [CRM].[CustomerContacts] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [HR].[Departments],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [HR].[Departments] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [HR].[EmployeeProfiles],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [HR].[EmployeeProfiles] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [HR].[Employees],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [HR].[Employees] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[Vendors],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[Vendors] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorContacts],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorContacts] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[PurchaseOrders],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[PurchaseOrders] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[PurchaseOrderLines],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[PurchaseOrderLines] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorInvoices],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorInvoices] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorInvoiceLines],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorInvoiceLines] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorPayments],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Procurement].[VendorPayments] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[ProductCategories],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[ProductCategories] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[Warehouses],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[Warehouses] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[Products],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[Products] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryBalances],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryBalances] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryTransactions],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryTransactions] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryTransfers],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryTransfers] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryTransferLines],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Inventory].[InventoryTransferLines] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesOrders],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesOrders] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesOrderLines],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesOrderLines] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesInvoices],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesInvoices] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesInvoiceLines],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesInvoiceLines] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[CustomerPayments],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[CustomerPayments] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesCommissions],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Sales].[SalesCommissions] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[ChartOfAccounts],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[ChartOfAccounts] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[JournalEntries],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[JournalEntries] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[JournalEntryLines],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[JournalEntryLines] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[AccountsReceivable],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[AccountsReceivable] AFTER INSERT,
ADD FILTER PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[AccountsPayable],
ADD BLOCK PREDICATE [Security].[fn_CompanyAccessPredicate](CompanyId) ON [Finance].[AccountsPayable] AFTER INSERT
WITH (STATE = ON, SCHEMABINDING = ON);
GO

/* ---------------------------------------------------------------------------
   Initial reference data
--------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM [Core].[Currencies] WHERE IsoCode = 'USD')
    INSERT [Core].[Currencies](IsoCode,Name,Symbol) VALUES ('USD',N'US Dollar',N'$');

IF NOT EXISTS (SELECT 1 FROM [Core].[Currencies] WHERE IsoCode = 'CRC')
    INSERT [Core].[Currencies](IsoCode,Name,Symbol) VALUES ('CRC',N'Costa Rican Colón',N'₡');
GO

/* ---------------------------------------------------------------------------
   Recommended operational rule:
   Do not grant direct DELETE on accounting/sales/procurement data to
   application roles. Corrections should be modeled through reversals,
   credit notes, voids or adjustments.
--------------------------------------------------------------------------- */
DENY DELETE ON SCHEMA::[Sales] TO [ERP_Sales];
DENY DELETE ON SCHEMA::[Procurement] TO [ERP_Procurement];
DENY DELETE ON SCHEMA::[Finance] TO [ERP_Finance];
DENY DELETE ON SCHEMA::[Inventory] TO [ERP_Inventory];
GO

PRINT N'Profit V2 database structure, security, indexes, procedures, RLS and AuditLog created successfully.';
GO

/* ---------------------------------------------------------------------------
   Operational views
--------------------------------------------------------------------------- */
CREATE OR ALTER VIEW [Sales].[vSalesInvoiceBalances]
AS
SELECT
    I.CompanyId,
    I.SalesInvoiceId,
    I.InvoiceNumber,
    I.CustomerId,
    I.InvoiceDate,
    I.DueDate,
    I.TotalAmount,
    ISNULL(SUM(AR.CreditAmount - AR.DebitAmount), 0) AS AppliedAmount,
    I.TotalAmount - ISNULL(SUM(AR.CreditAmount - AR.DebitAmount), 0) AS OutstandingAmount,
    I.StatusCode
FROM [Sales].[SalesInvoices] I
LEFT JOIN [Finance].[AccountsReceivable] AR
    ON AR.CompanyId = I.CompanyId
   AND AR.SalesInvoiceId = I.SalesInvoiceId
GROUP BY
    I.CompanyId, I.SalesInvoiceId, I.InvoiceNumber, I.CustomerId,
    I.InvoiceDate, I.DueDate, I.TotalAmount, I.StatusCode;
GO

CREATE OR ALTER VIEW [Procurement].[vVendorInvoiceBalances]
AS
SELECT
    I.CompanyId,
    I.VendorInvoiceId,
    I.InvoiceNumber,
    I.VendorId,
    I.InvoiceDate,
    I.DueDate,
    I.TotalAmount,
    ISNULL(SUM(AP.DebitAmount - AP.CreditAmount), 0) AS AppliedAmount,
    I.TotalAmount - ISNULL(SUM(AP.DebitAmount - AP.CreditAmount), 0) AS OutstandingAmount,
    I.StatusCode
FROM [Procurement].[VendorInvoices] I
LEFT JOIN [Finance].[AccountsPayable] AP
    ON AP.CompanyId = I.CompanyId
   AND AP.VendorInvoiceId = I.VendorInvoiceId
GROUP BY
    I.CompanyId, I.VendorInvoiceId, I.InvoiceNumber, I.VendorId,
    I.InvoiceDate, I.DueDate, I.TotalAmount, I.StatusCode;
GO

CREATE OR ALTER VIEW [Inventory].[vStockOnHand]
AS
SELECT
    B.CompanyId,
    B.ProductId,
    P.SKU,
    P.Name AS ProductName,
    B.WarehouseId,
    W.Code AS WarehouseCode,
    W.Name AS WarehouseName,
    B.QuantityOnHand,
    B.QuantityReserved,
    B.QuantityOnHand - B.QuantityReserved AS QuantityAvailable,
    B.AverageCost
FROM [Inventory].[InventoryBalances] B
INNER JOIN [Inventory].[Products] P
    ON P.CompanyId = B.CompanyId AND P.ProductId = B.ProductId
INNER JOIN [Inventory].[Warehouses] W
    ON W.CompanyId = B.CompanyId AND W.WarehouseId = B.WarehouseId;
GO

GRANT SELECT ON [Sales].[vSalesInvoiceBalances] TO [ERP_ReadOnly], [ERP_Sales], [ERP_Finance], [ERP_Auditor];
GRANT SELECT ON [Procurement].[vVendorInvoiceBalances] TO [ERP_ReadOnly], [ERP_Procurement], [ERP_Finance], [ERP_Auditor];
GRANT SELECT ON [Inventory].[vStockOnHand] TO [ERP_ReadOnly], [ERP_Sales], [ERP_Procurement], [ERP_Inventory], [ERP_Finance], [ERP_Auditor];
GO

/* ---------------------------------------------------------------------------
   Installation validation
--------------------------------------------------------------------------- */
SELECT
    DB_NAME() AS DatabaseName,
    (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0) AS UserTables,
    (SELECT COUNT(*) FROM sys.triggers WHERE parent_class_desc = 'OBJECT_OR_COLUMN') AS ObjectTriggers,
    (SELECT COUNT(*) FROM sys.indexes WHERE is_hypothetical = 0 AND index_id > 0) AS Indexes,
    (SELECT COUNT(*) FROM sys.procedures WHERE is_ms_shipped = 0) AS StoredProcedures;
GO
