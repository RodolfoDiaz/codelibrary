# Profit ERP Database

> Technical reference for the Profit version 2.0 multi-company ERP database
> design.

## 1. Purpose and scope

`Profit` is a relational database foundation for a multi-company ERP
covering customer management, sales, procurement, inventory,
finance/accounting foundations, and employee records. This README
documents the objects defined in `./Scripts/Profit_V2_SQLServer2025.sql`.

### In scope

- SQL Server database creation and database options.
- Functional schemas and table structures.
- Foreign keys, company-scoped relationships, indexes and row-version
  columns where defined.
- Database roles and application database principal.
- Row-Level Security (RLS) based on company access.
- Central `Audit.AuditLog` and DML audit triggers.
- Stored procedures for security administration and selected business
  operations.
- Operational views for balances and stock-on-hand.

### Important limitations

- This is an ERP database foundation, **not a complete certified
  IFRS/NIIF accounting product**. Validate accounting policies, tax
  rules, document numbering, local statutory reporting, period close,
  multi-currency revaluation, and audit requirements with domain
  experts.
- RLS and session context depend on the application setting
  trustworthy identity/company context. Do not let clients directly
  choose arbitrary user IDs or company IDs.
- The script creates a SQL login named `ProfitApp` using a
  placeholder/default password mechanism. Replace the secret and
  prefer managed/Windows/Microsoft Entra authentication where
  appropriate before production.
- This V2 script is a redesign/build script, not a migration that
  preserves existing Profit database data.
- Audit triggers capture row changes, but the `ChangedColumns` field
  is not populated with a column-by-column diff in the current
  implementation; inspect the trigger body and `AuditLog` schema
  before relying on that field.

## 2. Design principles and rationale

---

Decision Purpose / rationale

---

Functional schemas Group objects by business
capability and provide a boundary
for permission grants.

Plural table names Keep table naming consistent and
readable across the model.

Multi-company ownership Operational rows include
`CompanyId` where appropriate, and
company-scoped foreign keys help
prevent cross-company references.

Composite candidate keys Unique `(CompanyId, Id)` keys
support company-scoped foreign-key
relationships even when the primary
key is a surrogate ID.

Central audit table Keep change history out of business
tables and make audit queries
consistent.

Set-based DML triggers Capture changes for multi-row
INSERT/UPDATE/DELETE statements
rather than assuming one affected
row.

`datetime2` UTC convention Use high-precision date/time fields
and standardize application
timestamps to UTC. The application
should enforce UTC semantics
consistently.

`decimal` for amounts Avoid approximate floating-point
arithmetic for monetary and
quantity values.

`rowversion` for optimistic Detect conflicting updates without
concurrency holding long-lived locks. It is a
binary version token, not a
date/time.

SQL Server schemas and roles Grant least-privilege access by
business function instead of broad
table access.

Row-Level Security Filter and block access to
company-scoped rows based on
session context and
`Security.UserCompanies`.

Controlled posting procedures Route selected financial, invoice
and inventory posting operations
through explicit procedures that
can validate state and transaction
rules.

No direct deletes for selected Encourage voids, reversals, credit
business roles notes and adjustments instead of
physically deleting posted business
records.

---

## 3. Repository layout

Recommended GitHub layout:

```text
Profit/                     # Visual Studio Database project
Scripts/                    # Contains the original database script.
README.md
```

Keep this README in sync with the SQL build script. When adding or
changing a table, trigger, view, procedure, role, policy, or index,
update the corresponding documentation in the same pull request.

## 4. Database schemas

---

Schema Responsibility

---

`Core` Company, geography, currency,
exchange-rate and fiscal-calendar
foundations.

`CRM` Customer master data and customer
contacts.

`Sales` Sales orders, invoices, receipts
and commissions.

`Procurement` Vendors, purchasing, vendor
invoices and payments.

`Inventory` Products, warehouses, stock
balances, movement ledger and
transfers.

`Finance` Chart of accounts, journal entries,
receivables and payables.

`HR` Departments and employee-related
records.

`Security` Application identity mapping,
company access, session context and
authorization helpers.

`Reference` Shared or company-scoped
lookup/reference values used by
operational documents.

`Audit` Centralized, row-level change
history written by DML triggers.

---

## 5. Entity and relationship overview

At a high level, the main flows are:

1.  **Sales:** `CRM.Customers` → `Sales.SalesOrders` /
    `Sales.SalesOrderLines` → `Sales.SalesInvoices` /
    `Sales.SalesInvoiceLines` → `Sales.CustomerPayments` and
    `Finance.AccountsReceivable`.
2.  **Procurement:** `Procurement.Vendors` →
    `Procurement.PurchaseOrders` / `Procurement.PurchaseOrderLines` →
    `Procurement.VendorInvoices` / `Procurement.VendorInvoiceLines` →
    `Procurement.VendorPayments` and `Finance.AccountsPayable`.
3.  **Inventory:** `Inventory.Products`, `Inventory.Warehouses`,
    `Inventory.InventoryBalances`, `Inventory.InventoryTransactions`,
    and inventory transfers track product movement and quantities.
4.  **General ledger:** `Finance.ChartOfAccounts` →
    `Finance.JournalEntries` → `Finance.JournalEntryLines`; posting
    procedures provide controlled entry points for selected operations.
5.  **Company security:** `Security.Users` ↔ `Security.UserCompanies` ↔
    `Core.Companies`; `Security.SetSessionContext` establishes database
    session context used by the RLS predicate.
6.  **Audit:** triggers on instrumented tables write old/new row
    snapshots and operation metadata to `Audit.AuditLog`.

These are conceptual flows, not a substitute for inspecting each
declared foreign key. Use the DDL as the authoritative relationship
definition.

## 6. Table data dictionary

The following lists every table defined by the build script, its
intended responsibility, and its columns as declared in the script.
Column types and modifiers are included in compact form. For complete
constraints and foreign-key definitions, refer to the SQL DDL.

### Core schema

Company, geography, currency, exchange-rate and fiscal-calendar
foundations.

#### `Core.Countries`

Country reference data.

#### `Core.States`

State/province/region reference data, related to countries.

#### `Core.Currencies`

Currency master data, including ISO code and display symbol.

#### `Core.Companies`

Legal entities/companies supported by the multi-company ERP.

#### `Core.ExchangeRates`

Exchange rates used for cross-currency transactions and reporting.

#### `Core.FiscalYears`

Fiscal-year definitions per company.

#### `Core.AccountingPeriods`

Company-specific accounting periods within fiscal years.

### CRM schema

Customer master data and customer contacts.

#### `CRM.Customers`

Customer master records, including legal name, tax identifier, contact
details and credit limit.

#### `CRM.CustomerContacts`

Contact persons associated with customers.

### Sales schema

Sales orders, invoices, receipts and commissions.

#### `Sales.SalesOrders`

Sales order headers.

#### `Sales.SalesOrderLines`

Products, quantities and prices belonging to sales orders.

#### `Sales.SalesInvoices`

Sales invoice headers and receivable document information.

#### `Sales.SalesInvoiceLines`

Line-level products, quantities, prices and taxes on sales invoices.

#### `Sales.CustomerPayments`

Payments received from customers.

#### `Sales.SalesCommissions`

Sales commission records associated with sales activity.

### Procurement schema

Vendors, purchasing, vendor invoices and payments.

#### `Procurement.Vendors`

Vendor/supplier master records.

#### `Procurement.VendorContacts`

Contact persons associated with vendors.

#### `Procurement.PurchaseOrders`

Purchase order headers.

#### `Procurement.PurchaseOrderLines`

Items, quantities and prices belonging to purchase orders.

#### `Procurement.VendorInvoices`

Vendor invoice headers and payable document information.

#### `Procurement.VendorInvoiceLines`

Line-level items and amounts on vendor invoices.

#### `Procurement.VendorPayments`

Payments made to vendors.

### Inventory schema

Products, warehouses, stock balances, movement ledger and transfers.

#### `Inventory.ProductCategories`

Product category hierarchy/classification.

#### `Inventory.Warehouses`

Company inventory locations/warehouses.

#### `Inventory.Products`

Product/service catalog and inventory-related product attributes.

#### `Inventory.InventoryBalances`

Current quantity balances by product and warehouse.

#### `Inventory.InventoryTransactions`

Inventory movement ledger.

#### `Inventory.InventoryTransfers`

Transfer headers between inventory locations.

#### `Inventory.InventoryTransferLines`

Products and quantities included in inventory transfers.

### Finance schema

Chart of accounts, journal entries, receivables and payables.

#### `Finance.ChartOfAccounts`

Company-specific general ledger accounts.

#### `Finance.JournalEntries`

General ledger journal entry headers.

#### `Finance.JournalEntryLines`

Debit/credit lines belonging to journal entries.

#### `Finance.AccountsReceivable`

Accounts-receivable items and customer balances/due dates.

#### `Finance.AccountsPayable`

Accounts-payable items and vendor balances/due dates.

### HR schema

Departments and employee-related records.

#### `HR.Departments`

Organizational departments.

#### `HR.EmployeeProfiles`

Employee profile/personnel details.

#### `HR.Employees`

Employee records associated with a company and department.

### Security schema

Application identity mapping, company access, session context and
authorization helpers.

#### `Security.Users`

Application-level identities mapped to the identity provider used by the
web application; not a password store.

#### `Security.UserCompanies`

Mapping between application users and companies they may access.

### Reference schema

Shared or company-scoped lookup/reference values used by operational
documents.

#### `Reference.DocumentStatuses`

Shared lookup values for document lifecycle statuses.

#### `Reference.PaymentMethods`

Payment-method reference values scoped to a company.

#### `Reference.TaxCodes`

Tax code/rate reference values scoped to a company.

### Audit schema

Centralized, row-level change history written by DML triggers.

#### `Audit.AuditLog`

Central audit trail for inserts, updates and deletes on instrumented
tables.

## 7. Stored procedures

Stored procedures are the database's explicit operational and
administration entry points. The application should use parameterized
calls and handle SQL errors as part of its normal error model.

---

Procedure Purpose

---

`Security.SetSessionContext` Sets the database session's
application user/company context
used by the RLS predicate. Call it
after authenticating the
application user and validating
their company membership.
Connection pooling makes correct
per-request initialization and
cleanup especially important.

`Security.CreateApplicationUser` Creates a row in `Security.Users`;
this is an application identity
mapping, not a replacement for
ASP.NET Core Identity, Entra ID, or
another identity provider.

`Security.GrantUserCompany` Adds or updates the company access
mapping for an active application
user and optionally designates the
default company.

`Security.GrantApplicationRole` Adds a database principal to a
named database role after
validating that both principals
exist. Restrict execution to
trusted administrators.

`Core.TouchUpdatedAt` Deliberately throws an error
directing callers to use
`rowversion`-based updates;
retained as a controlled extension
point rather than a general update
helper.

`CRM.CustomerCreate` Creates a customer record and
returns the generated customer ID.

`CRM.CustomerUpdate` Updates selected customer fields
using company scope and a
`rowversion` token; throws if the
record was missing or concurrently
changed.

`CRM.CustomerGet` Retrieves a customer by company and
customer ID.

`Procurement.VendorCreate` Creates a vendor record and returns
the generated vendor ID.

`Procurement.VendorGet` Retrieves a vendor by company and
vendor ID.

`Sales.PostSalesInvoice` Controlled posting operation for a
sales invoice. Review the procedure
body for status validation,
transaction handling, and the exact
side effects before integration.

`Procurement.PostVendorInvoice` Controlled posting operation for a
vendor invoice. Review the
procedure body for status
validation, transaction handling,
and the exact side effects before
integration.

`Finance.PostJournalEntry` Controlled posting operation for a
general-ledger journal entry.
Verify balancing and
accounting-period rules against
business requirements.

`Inventory.PostInventoryTransaction` Controlled posting operation for
inventory movements. Verify
stock-negative policy, costing
method, and transfer semantics
against business requirements.

---

### Procedure usage guidance

- Treat posting procedures as business operations, not generic CRUD
  methods.
- Confirm that a posting procedure is idempotent or add an idempotency
  strategy before retrying automatically after timeouts.
- Ensure all required checks are performed server-side; never trust
  UI-only validation.
- Add integration tests for valid posting, invalid status,
  cross-company access, concurrency, rollback, and duplicate requests.

## 8. Triggers and auditing

The script defines **39 audit triggers**. They follow the naming
convention `tr_Audit_<Schema>_<Table>` and are attached to the
instrumented tables listed below. Their common purpose is to record
INSERT, UPDATE, and DELETE activity in the centralized audit table.

### Trigger inventory

---

Trigger Table monitored Purpose

---

`Core.tr_Audit_Core_Companies` `Core.Companies` Capture row-level DML
change information in
`Audit.AuditLog`.

`Core.tr_Audit_Core_ExchangeRates` `Core.ExchangeRates` Capture row-level DML
change information in
`Audit.AuditLog`.

`Core.tr_Audit_Core_FiscalYears` `Core.FiscalYears` Capture row-level DML
change information in
`Audit.AuditLog`.

`Core.tr_Audit_Core_AccountingPeriods` `Core.AccountingPeriods` Capture row-level DML
change information in
`Audit.AuditLog`.

`Core.tr_Audit_Core_Currencies` `Core.Currencies` Capture row-level DML
change information in
`Audit.AuditLog`.

`Core.tr_Audit_Core_Countries` `Core.Countries` Capture row-level DML
change information in
`Audit.AuditLog`.

`Core.tr_Audit_Core_States` `Core.States` Capture row-level DML
change information in
`Audit.AuditLog`.

`CRM.tr_Audit_CRM_Customers` `CRM.Customers` Capture row-level DML
change information in
`Audit.AuditLog`.

`CRM.tr_Audit_CRM_CustomerContacts` `CRM.CustomerContacts` Capture row-level DML
change information in
`Audit.AuditLog`.

`HR.tr_Audit_HR_Departments` `HR.Departments` Capture row-level DML
change information in
`Audit.AuditLog`.

`HR.tr_Audit_HR_EmployeeProfiles` `HR.EmployeeProfiles` Capture row-level DML
change information in
`Audit.AuditLog`.

`HR.tr_Audit_HR_Employees` `HR.Employees` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_Vendors` `Procurement.Vendors` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_VendorContacts` `Procurement.VendorContacts` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_PurchaseOrders` `Procurement.PurchaseOrders` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_PurchaseOrderLines` `Procurement.PurchaseOrderLines` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_VendorInvoices` `Procurement.VendorInvoices` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_VendorInvoiceLines` `Procurement.VendorInvoiceLines` Capture row-level DML
change information in
`Audit.AuditLog`.

`Procurement.tr_Audit_Procurement_VendorPayments` `Procurement.VendorPayments` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_ProductCategories` `Inventory.ProductCategories` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_Warehouses` `Inventory.Warehouses` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_Products` `Inventory.Products` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_InventoryBalances` `Inventory.InventoryBalances` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_InventoryTransactions` `Inventory.InventoryTransactions` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_InventoryTransfers` `Inventory.InventoryTransfers` Capture row-level DML
change information in
`Audit.AuditLog`.

`Inventory.tr_Audit_Inventory_InventoryTransferLines` `Inventory.InventoryTransferLines` Capture row-level DML
change information in
`Audit.AuditLog`.

`Sales.tr_Audit_Sales_SalesOrders` `Sales.SalesOrders` Capture row-level DML
change information in
`Audit.AuditLog`.

`Sales.tr_Audit_Sales_SalesOrderLines` `Sales.SalesOrderLines` Capture row-level DML
change information in
`Audit.AuditLog`.

`Sales.tr_Audit_Sales_SalesInvoices` `Sales.SalesInvoices` Capture row-level DML
change information in
`Audit.AuditLog`.

`Sales.tr_Audit_Sales_SalesInvoiceLines` `Sales.SalesInvoiceLines` Capture row-level DML
change information in
`Audit.AuditLog`.

`Sales.tr_Audit_Sales_CustomerPayments` `Sales.CustomerPayments` Capture row-level DML
change information in
`Audit.AuditLog`.

`Sales.tr_Audit_Sales_SalesCommissions` `Sales.SalesCommissions` Capture row-level DML
change information in
`Audit.AuditLog`.

`Finance.tr_Audit_Finance_ChartOfAccounts` `Finance.ChartOfAccounts` Capture row-level DML
change information in
`Audit.AuditLog`.

`Finance.tr_Audit_Finance_JournalEntries` `Finance.JournalEntries` Capture row-level DML
change information in
`Audit.AuditLog`.

`Finance.tr_Audit_Finance_JournalEntryLines` `Finance.JournalEntryLines` Capture row-level DML
change information in
`Audit.AuditLog`.

`Finance.tr_Audit_Finance_AccountsReceivable` `Finance.AccountsReceivable` Capture row-level DML
change information in
`Audit.AuditLog`.

`Finance.tr_Audit_Finance_AccountsPayable` `Finance.AccountsPayable` Capture row-level DML
change information in
`Audit.AuditLog`.

`Security.tr_Audit_Security_Users` `Security.Users` Capture row-level DML
change information in
`Audit.AuditLog`.

`Security.tr_Audit_Security_UserCompanies` `Security.UserCompanies` Capture row-level DML
change information in
`Audit.AuditLog`.

---

### Audit record design

`Audit.AuditLog` centralizes the audit history. Its fields capture the
affected object/record, operation, actor/session metadata, timestamp,
and serialized row data as implemented in the DDL. Audit trigger writes
execute in the same transaction as the original DML: if the transaction
rolls back, its audit write rolls back too.

**Operational considerations:**

- Audit triggers add write overhead; measure performance under
  realistic batch sizes.
- Ensure the application sets user/company session context before DML
  so audit metadata is meaningful.
- Restrict UPDATE/DELETE permissions on audit records; audit data
  should not be editable by ordinary application roles.
- Define retention, archival, access review, and backup policies for
  audit records.
- `ChangedColumns` is not currently populated as a detailed per-column
  delta. Do not present it as a complete column-level diff unless the
  trigger implementation is extended and tested.
- Consider whether sensitive personal or financial data in
  before/after snapshots should be masked, encrypted, or excluded.

## 9. Views

---

View Purpose

---

`Sales.vSalesInvoiceBalances` Presents sales invoice balance
information for operational
reporting. Validate its exact
calculation and treatment of
credits, write-offs, and unapplied
payments before using it as an
accounting source of truth.

`Procurement.vVendorInvoiceBalances` Presents vendor invoice balance
information for operational
reporting. Validate its exact
calculation and treatment of
payments, credits, and adjustments.

`Inventory.vStockOnHand` Presents stock-on-hand information
derived from inventory data.
Validate whether it reads balance
snapshots, transactions, or both
before relying on it for valuation
or reconciliation.

---

## 10. Row-Level Security (RLS) and application identity

### Objects

- `Security.fn_CompanyAccessPredicate`: predicate function used by the
  security policy to determine whether a row's `CompanyId` is
  accessible in the current session.
- `Security.CompanySecurityPolicy`: policy applying filter predicates
  and insert block predicates to company-scoped tables.
- `Security.Users`: application-level user directory/mapping.
- `Security.UserCompanies`: authorized user-to-company relationships.
- `Security.SetSessionContext`: procedure for setting the session
  values used by the predicate.

### Request flow

1.  Authenticate the human user in the application using ASP.NET Core
    Identity, Microsoft Entra ID, or another trusted identity provider.
2.  Resolve the authenticated subject to `Security.Users` on the server.
3.  Validate that the requested company exists in
    `Security.UserCompanies` for that user.
4.  Set the session context on the **same SQL connection** that will
    execute the business queries.
5.  Execute parameterized database operations; RLS provides an
    additional database-side company boundary.
6.  With connection pooling, ensure each logical request initializes its
    context correctly. Never rely on a previous request's session state.

**Important:** a shared SQL login such as `ProfitApp` authenticates the
application to SQL Server; it does not authenticate each human user.
Human authentication and authorization remain application
responsibilities, with `Security.Users` and `Security.UserCompanies`
serving as database-side identity/access mappings.

### Database roles

---

Role Intended scope

---

`ERP_ReadOnly` Read-only reporting access, subject
to granted permissions and RLS.

`ERP_Sales` Sales-domain operations.

`ERP_Procurement` Procurement-domain operations.

`ERP_Inventory` Inventory-domain operations.

`ERP_Finance` Finance/accounting-domain
operations.

`ERP_HR` Human-resources operations.

`ERP_Auditor` Audit and review access.

`ERP_Admin` Trusted database/application
administration tasks. Keep
membership minimal.

---

Role names express intended scope; always inspect the actual `GRANT`,
`DENY`, and role-membership statements in the script before deployment.
Do not grant application identities `db_owner` or `sysadmin`.

## 11. Indexing and performance

The build script adds workload-oriented indexes for common lookup,
relationship, date, and audit access patterns, including:

- Customer/vendor/product lookups by company and name or tax
  identifier.
- Sales invoices and customer payments by customer/date or
  status/date.
- Vendor invoices and vendor payments by vendor/date.
- Inventory transactions by product/warehouse/date and reference.
- Journal entries by date/source and journal lines by account.
- Accounts receivable/payable by customer/vendor and due date.
- Audit log queries by record, company/date, and user/date.

Indexes are starting points, not a substitute for production query-plan
review. Review actual execution plans, Query Store, logical reads, write
amplification, index usage and fragmentation. Avoid adding duplicate
indexes without evidence, and verify that index key order matches real
predicates and sorting.

## 12. Integrity and concurrency

- Primary keys uniquely identify rows; foreign keys enforce declared
  relationships.
- Company-scoped composite keys/foreign keys help prevent
  relationships from crossing company boundaries where implemented.
- Unique constraints protect business identifiers and lookup codes
  where declared.
- `rowversion` tokens support optimistic concurrency; callers should
  return a conflict response when an update affects zero rows due to a
  stale token.
- `decimal` is used for exact numeric storage where appropriate;
  application calculations should use compatible decimal types and
  explicit rounding policies.
- Posting procedures should be tested for transaction atomicity,
  isolation behavior, duplicate calls, and period/status validation.

## 13. Installation and deployment

1.  Review `Profit_V2_SQLServer2025.sql` and set the SQL login
    secret safely. Do not commit production secrets to Git.
2.  Execute the script in a disposable SQL Server 2025 development/test
    instance using a principal with the permissions required to create
    databases, logins, users, schemas, roles, and objects.
3.  Verify that the script completes without errors and that all
    expected tables, procedures, triggers, views, indexes, and the
    security policy exist.
4.  Run automated integration tests for cross-company isolation, audit
    records, posting operations, permissions, and concurrency.
5.  Configure the application connection string through a secret manager
    or environment-specific secure configuration.
6.  Configure the authenticated-user-to-`Security.Users` mapping and
    company authorization flow.
7.  Apply production hardening: secret rotation, least privilege, TLS,
    backups, point-in-time recovery, monitoring, audit retention, and
    disaster-recovery testing.

Do not rerun a build script over a partially initialized database unless
its behavior is understood. For a clean rebuild, use a disposable
database with no data to preserve. This script is not a data-preserving
migration.

## 14. Verification checklist

- [ ] Script executes from a clean database with no errors.
- [ ] `ProfitApp` secret has been replaced or external authentication
      is configured.
- [ ] Actual database role memberships and object grants match the
      intended least-privilege model.
- [ ] Each application request establishes trusted user/company
      session context on the correct SQL connection.
- [ ] RLS blocks reads and writes across unauthorized companies,
      including insert/update edge cases.
- [ ] Audit entries are generated for INSERT, UPDATE, and DELETE on
      all instrumented tables.
- [ ] Audit metadata correctly identifies the application user,
      company, operation and affected record.
- [ ] Posting procedures are atomic, validated, concurrency-safe, and
      tested for duplicate requests.
- [ ] Customer/vendor CRUD procedures handle invalid input, duplicate
      identifiers, and concurrency as required.
- [ ] Indexes are validated against representative query plans and
      production-like data volumes.
- [ ] Financial totals reconcile to source documents and accounting
      policy.
- [ ] Backup restore and disaster recovery have been tested.

## 15. Recommended next improvements

1.  Add automated SQL build validation in CI against a clean SQL Server
    container/instance.
2.  Add migration scripts and versioning rather than relying only on a
    full build script.
3.  Add extended properties or a separately maintained data dictionary
    with business definitions, nullability, defaults, keys, and
    sensitivity classifications.
4.  Define explicit posting state machines, reversal/void/credit-note
    workflows, and idempotency keys.
5.  Expand automated tests for RLS, permissions, audit coverage, and
    company-boundary integrity.
6.  Define a formal accounting requirements matrix for NIIF/IFRS, tax
    jurisdiction rules, rounding, exchange-rate policy, period close,
    and statutory reports.
7.  Decide audit retention and whether old/new snapshots should be
    stored as JSON, normalized deltas, or both.
8.  Review whether `AuditLog` needs tamper-evidence, restricted
    ownership, partitioning, or archival for expected volume.

## 16. Source of truth

The SQL build script is the authoritative source for the exact schema,
column definitions, constraints, grants, trigger bodies, and procedure
behavior. This README explains the intent and provides a navigable
inventory; update it whenever the DDL changes.

**Build script:** `Profit_V2_SQLServer2025.sql`
