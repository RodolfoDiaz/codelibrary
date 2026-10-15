# Profit Database

Database documentation for **Profit**, a SQL Server relational database supporting multi-company business operations, including customer and supplier records, products and inventory, sales documents, purchasing documents, payments, employees, and currency configuration.

> **Source reviewed:** `Profit.sql` and `Triggers.sql`.

> **Important:** This README documents the objects present in those scripts. It does not claim that the scripts implement every capability of a full accounting/ERP platform or that the schema has been validated against a particular IFRS/NIIF implementation.

## Contents

- [Overview](#overview)
- [Build and deployment](#build-and-deployment)
- [Database object inventory](#database-object-inventory)
- [Tables by functional area](#tables-by-functional-area)
- [Relationships and data conventions](#relationships-and-data-conventions)
- [Views](#views)
- [Stored procedures](#stored-procedures)
- [Triggers and business rules](#triggers-and-business-rules)
- [Indexes and constraints](#indexes-and-constraints)
- [Application integration and security](#application-integration-and-security)
- [Operational notes and recommendations](#operational-notes-and-recommendations)
- [Known limitations to verify](#known-limitations-to-verify)

## Overview

Profit uses a company-oriented data model. Most operational records include `CompanyId`, supporting separation of records by company. The schema includes master/reference data, customer and supplier records, sales and purchasing documents, document detail lines, payments, inventory, and employee-related data.

### Functional areas

| Area                               | Purpose                                                                                              |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------- |
| Organization and geography         | Companies, countries, states, departments, warehouses                                                |
| Customers and receivables          | Customer master data, contacts, document types, sales documents, document details, customer payments |
| Suppliers and payables             | Supplier master data, contacts, document types, purchase documents, supplier payments                |
| Inventory                          | Products, product types, warehouses, stock quantity                                                  |
| Employees and commissions          | Employees, employee profiles, departments, commissions                                               |
| Currency and payment configuration | Currency types, exchange rates, payment types                                                        |
| Document workflow                  | Document statuses and document-type configuration                                                    |
| Application user metadata          | User-to-company metadata, culture and role values                                                    |

The schema uses **singular, PascalCase table names** such as `Client`, `Provider`, and `Product`. The documentation keeps these names as they exist in the scripts so SQL examples match the deployed objects.

## Build and deployment

### Source files

- **`Profit(1).sql`** — creates the `Profit` database and defines its tables, constraints, views, stored procedures, indexes, and database user objects.
- **`Triggers(1).sql`** — defines three DML triggers related to inventory and customer/supplier balances.

### Execution

The main script begins by dropping the existing `Profit` database if it exists, then recreates it. **This is destructive**: running it against an existing environment can permanently delete the database and its data.

1. Review both scripts and confirm the target SQL Server instance.
2. Back up any existing database and test in a disposable development environment first.
3. Execute `Profit(1).sql` using a SQL Server tool that supports `GO` batch separators, such as SQL Server Management Studio or `sqlcmd`.
4. Execute `Triggers(1).sql` in the newly created `Profit` database.
5. Check the SQL Server Messages output for errors and verify the object inventory after deployment.

The script header requests execution as a system administrator (`sa`). For normal deployments, prefer a controlled deployment identity with only the required permissions rather than using `sa` routinely.

### Compatibility

The script uses traditional SQL Server T-SQL constructs including `IDENTITY`, `money`, `datetime`, `timestamp`/`rowversion`, SQL Server system catalogs, and `GO` batch separators. Test against the target SQL Server version before production use. Although the database may run on a newer SQL Server release, the scripts should not be assumed to use newer platform features merely because that release is targeted.

## Database object inventory

Inventory found in the scripts:

| Object type       |     Count | Notes                                                                |
| ----------------- | --------: | -------------------------------------------------------------------- |
| Tables            |        26 | Core business and configuration data                                 |
| Views             |        26 | One `profit_vw_...` view per table in the script                     |
| Stored procedures |       105 | Mostly CRUD procedures plus an exchange-rate lookup                  |
| Explicit indexes  |        35 | Named nonclustered indexes in the script                             |
| Triggers          |         3 | Defined in the separate trigger script                               |
| Schemas           |         — | Objects are defined under `dbo`; no custom schema creation was found |
| `AuditLog` table  | Not found | The scripts do not define a generic audit log table                  |

Counts are based on object definitions found in the files. Confirm the live database catalog after deployment, particularly if scripts have been modified or run only partially.

## Tables by functional area

Descriptions below are based on table names, columns, and relationships present in the scripts.

### Organization, geography, and configuration

| Table            | Purpose                                                                                                                                 |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `Company`        | Company profile and configuration, including address, tax/discount settings, currency behavior, and culture/localization values         |
| `Country`        | Country reference data                                                                                                                  |
| `State`          | State/province reference data associated with a country                                                                                 |
| `Department`     | Company departments                                                                                                                     |
| `Warehouse`      | Warehouses or inventory locations associated with a company                                                                             |
| `DocumentStatus` | Status values used by customer and supplier documents                                                                                   |
| `MoneyType`      | Currency or money-type configuration                                                                                                    |
| `ExchangeRate`   | Exchange rates associated with a company and currency configuration                                                                     |
| `PaymentType`    | Payment terms or payment-method/type configuration                                                                                      |
| `UserInfo`       | Application user metadata, including `SidName`, `Culture`, and a numeric `Role`; this is not by itself a complete authentication system |

### Customers and receivables

| Table             | Purpose                                                                                                                                                              |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Client`          | Customer master record, contact/location details, credit limit, active flag, and current balance                                                                     |
| `ClientContact`   | Contact records associated with customers                                                                                                                            |
| `ClientDocType`   | Customer document-type configuration, including debit/credit behavior                                                                                                |
| `ClientDocument`  | Customer-facing documents such as sales invoices or other receivable documents; includes date, status, amount, tax, discount, exchange rate, and employee references |
| `ClientDocDetail` | Line items associated with customer documents, including product, quantity, unit price, tax, and discount                                                            |
| `ClientPayment`   | Customer payment records                                                                                                                                             |

### Suppliers and payables

| Table              | Purpose                                                                                                       |
| ------------------ | ------------------------------------------------------------------------------------------------------------- |
| `Provider`         | Supplier master record, including contact/location details and balance                                        |
| `ProviderContact`  | Contact records associated with suppliers                                                                     |
| `ProviderDocType`  | Supplier document-type configuration, including debit/credit behavior                                         |
| `ProviderDocument` | Supplier/purchasing documents with date, status, amount, tax, discount, exchange rate, and supplier reference |
| `ProviderPayment`  | Supplier payment records                                                                                      |

> **Terminology note:** The deployed schema calls suppliers `Provider`. If the model is later renamed to the more common ERP/accounting term `Vendor` or `Supplier`, update all dependent foreign keys, views, procedures, triggers, application mappings, and reports in a coordinated migration.

### Products, inventory, and sales support

| Table         | Purpose                                                                                                       |
| ------------- | ------------------------------------------------------------------------------------------------------------- |
| `Product`     | Product master data, including product type, supplier, warehouse, unit price, active flag, and `UnitsInStock` |
| `ProductType` | Product classification                                                                                        |
| `Commission`  | Employee-related commission records                                                                           |

### Human resources

| Table             | Purpose                                                                             |
| ----------------- | ----------------------------------------------------------------------------------- |
| `Employee`        | Employee records, including company, department, profile, and geographic references |
| `EmployeeProfile` | Employee profile/type configuration                                                 |

## Relationships and data conventions

The schema uses integer identity keys for many master and header records. Foreign-key relationships connect records to their parent entities, including company, geography, customer/supplier, employee, product, document type, payment type, status, and warehouse.

Examples of major relationships:

- `Company` relates to `Country` and `State`.
- `Client` relates to `Company`, `Country`, and `State`; `ClientContact` relates to a client.
- `ClientDocument` relates to a client, employee, document type, document status, and payment type.
- `ClientDocDetail` relates document lines to `ClientDocument` and `Product`.
- `ProviderDocument` relates to a supplier, document type, document status, and payment type.
- `Product` relates to a company, product type, supplier (`Provider`), and warehouse.
- `Employee` relates to a company, department, employee profile, and geographic data.

### Common audit/concurrency columns

Many tables include:

- `InsertUser` and `InsertDate` — record creation metadata.
- `LastUpdateUser` and `LastUpdateDate` — last-update metadata.
- `RowInfo` — SQL Server `timestamp`/`rowversion` value for detecting row changes; it is **not** a date/time.

These columns provide basic record metadata and optimistic-concurrency support when correctly used by the application. They are not a complete historical audit trail because they do not retain prior values.

### Multi-company considerations

Many tables include `CompanyId` and company-scoped indexes. Application queries and write operations should enforce company boundaries consistently. A `CompanyId` column alone does not guarantee tenant isolation; verify that foreign keys, stored procedures, views, and authorization checks prevent cross-company access.

## Views

The main script defines 26 views, using the naming convention `profit_vw_<TableName>`:

`profit_vw_Country`, `profit_vw_State`, `profit_vw_Company`, `profit_vw_ClientDocType`, `profit_vw_Department`, `profit_vw_DocumentStatus`, `profit_vw_EmployeeProfile`, `profit_vw_ExchangeRate`, `profit_vw_MoneyType`, `profit_vw_PaymentType`, `profit_vw_ProductType`, `profit_vw_ProviderDocType`, `profit_vw_UserInfo`, `profit_vw_Warehouse`, `profit_vw_Employee`, `profit_vw_Client`, `profit_vw_ClientContact`, `profit_vw_ClientDocDetail`, `profit_vw_ClientDocument`, `profit_vw_ClientPayment`, `profit_vw_Commission`, `profit_vw_Product`, `profit_vw_Provider`, `profit_vw_ProviderContact`, `profit_vw_ProviderDocument`, and `profit_vw_ProviderPayment`.

These appear to provide a consistent read interface over the underlying tables. Review each view definition before relying on it for security, reporting, or API contracts: a view does not automatically enforce row-level company isolation unless its definition and execution context are designed to do so.

## Stored procedures

The script defines 105 stored procedures. Most follow a consistent naming convention:

`profit_sp_<Entity>_<Action>`

For most entities, the actions are:

- `Insert` — create a record.
- `Read` — retrieve record(s).
- `Update` — update a record.
- `Delete` — delete a record.

CRUD procedure groups exist for the tables covered by the script, including geography/configuration, company, customer and supplier records, documents, payments, products, employees, and commissions.

Additional procedure:

- **`profit_sp_GetExchangeRate`** — retrieves an exchange rate for currency-related operations.

The procedures provide a potential database access layer, but their existence does not itself guarantee secure authorization, input validation, transactional correctness, or company-level access control. Review each procedure’s parameters, transaction handling, error handling, and permission grants before using it as the sole application data-access interface.

## Triggers and business rules

The separate `Triggers(1).sql` file defines three triggers.

### `Profit_tg_ClientDocDetail`

- **Table:** `ClientDocDetail`
- **Events:** `INSERT`, `UPDATE`, `DELETE`
- **Intended rule:** Adjusts `Product.UnitsInStock` using the old and new line quantity.
- **Important implementation concern:** The trigger assigns values from the `inserted` and `deleted` pseudo-tables to scalar variables. SQL Server triggers execute once per statement and these pseudo-tables can contain multiple rows. The current scalar-variable approach is not safe for multi-row statements and may update stock incorrectly. It also assumes the affected row(s) can be represented by a single product/document line. Rewrite it using set-based aggregation and joins before relying on it for production inventory accounting.

### `Profit_tg_ClientDocument`

- **Table:** `ClientDocument`
- **Events:** `INSERT`, `UPDATE`, `DELETE`
- **Intended rule:** Updates `Client.Balance` based on the document amount and the debit/credit behavior configured in `ClientDocType.IsDebit`.
- **Important implementation concern:** The trigger reads one row into scalar variables and does not correctly account for multi-row changes. On updates that change the customer or document type, old and new effects must be reversed/applied separately. The implementation should be reviewed and replaced with set-based logic.

### `Profit_tg_ProviderDocument`

- **Table:** `ProviderDocument`
- **Events:** `INSERT`, `UPDATE`, `DELETE`
- **Intended rule:** Updates `Provider.Balance` according to the supplier document amount and `ProviderDocType.IsDebit`.
- **Important implementation concern:** Like the customer-document trigger, the implementation uses scalar variables and is not safe for multi-row statements. Changes to supplier or document type also need correct reversal and reapplication of the old/new effects.

### Trigger deployment

The triggers are not in the main `Profit(1).sql` script; execute `Triggers(1).sql` after the database is created. The current trigger logic should be treated as legacy behavior pending testing and remediation.

## Indexes and constraints

The main script defines 35 explicitly named indexes, primarily to support company-scoped queries and common relationship lookups. Names include:

- `IX_State_Country`
- `IX_Company_Location`
- `IX_ClientDocType_Company`
- `IX_Department_Company`
- `IX_DocumentStatus_Company`
- `IX_EmployeeProfile_Company`
- `IX_ExchangeRate_Company`
- `IX_MoneyType_Company`
- `IX_PaymentType_Company`
- `IX_ProductType_Company`
- `IX_ProviderDocType_Company`
- `IX_UserInfo_Company`
- `IX_Warehouse_Company`
- `IX_Employee_Company`
- `IX_Employee_CompanyCountry`
- `IX_Client_Company`
- `IX_Client_CompanyCountry`
- `IX_ClientContact_Company`
- `IX_ClientContact_CompanyClient`
- `IX_ClientDocDetail_Company`
- `IX_ClientDocument_Company`
- `IX_ClientDocument_CompanyClient`
- `IX_ClientPayment_Company`
- `IX_ClientPayment_CompanyClient`
- `IX_Commission_Company`
- `IX_Commission_CompanyEmployee`
- `IX_Product_Company`
- `IX_Provider_Company`
- `IX_Provider_CompanyCountry`
- `IX_ProviderContact_Company`
- `IX_ProviderContact_CompanyProvider`
- `IX_ProviderDocument_Company`
- `IX_ProviderDocument_CompanyProvider`
- `IX_ProviderPayment_Company`
- `IX_ProviderPayment_CompanyProvider`

The scripts also define primary-key and foreign-key constraints. Validate the actual deployed constraints and execution plans rather than assuming that an index is optimal for every workload. Additional indexes should be driven by measured query patterns and write overhead.

## Application integration and security

### `UserInfo` is not database authentication

`UserInfo` stores application-oriented metadata such as a SID/name, culture, company, and numeric role. It is not a replacement for ASP.NET Core authentication, identity management, password hashing, or authorization policy configuration.

For an ASP.NET Core application:

1. Authenticate users using a supported application identity system (for example, ASP.NET Core Identity or an external OpenID Connect provider).
2. Authorize requests using application roles/claims and company membership.
3. Connect to SQL Server using a dedicated application database principal (or an appropriate managed identity where supported by the hosting environment).
4. Grant the application principal only the required database permissions, preferably execute permissions on approved stored procedures and/or permissions on specific views rather than broad table modification rights.
5. Keep credentials out of source control; use a secret store or environment-specific secure configuration.
6. Enforce company scoping in data access and test for cross-company IDOR/authorization vulnerabilities.

The script includes a database user named `ProfitUser`, but does not appear to create a SQL Server login in the script. Confirm how that user is mapped in the target environment and what permissions it receives. Do not assume it can authenticate directly until the principal mapping and grants are verified.

### Least privilege

Avoid using `sa`, `sysadmin`, `db_owner`, or a shared administrator credential from the web application. Use separate identities for deployment and runtime access. Review grants and role membership explicitly after deployment.

## Operational notes and recommendations

- **Backups and recovery:** Define backup, restore, and point-in-time recovery objectives before production use.
- **Migrations:** Avoid using the drop-and-recreate script as a production upgrade mechanism. Use versioned, incremental migrations.
- **Transactions:** Ensure document headers, details, stock updates, balances, and payments are committed atomically where they represent one business operation.
- **Money and precision:** Review use of `money` for tax, exchange rates, discounts, and totals. Choose precision and rounding rules based on currency and accounting requirements.
- **Concurrency:** Use `RowInfo`/`rowversion` in update predicates where optimistic concurrency is required.
- **Error handling:** Standardize `TRY...CATCH`, transaction rollback, and error propagation in write procedures.
- **Validation:** Enforce positive/nonnegative quantities and amounts, valid document states, required references, and uniqueness rules with constraints where appropriate.
- **Auditability:** If a full audit trail is required, implement an `AuditLog` or another approved audit mechanism recording actor, timestamp, action, entity, key, and relevant before/after values. The scripts do not include `AuditLog`.
- **Observability:** Monitor deadlocks, long-running queries, blocking, index usage, and procedure errors.
- **Data retention:** Define retention and archival rules for financial documents and audit records.
- **ERP/accounting scope:** The presence of sales and purchasing documents does not by itself mean the database implements a general ledger, chart of accounts, double-entry posting, tax jurisdiction rules, or full IFRS/NIIF compliance. Validate these requirements separately.

## Known limitations to verify

Before treating this schema as production-ready, review at least the following:

1. **Destructive deployment:** The main script drops `Profit` if it exists.
2. **Trigger correctness:** All three triggers use scalar variables against `inserted`/`deleted`, making them unsafe for multi-row statements.
3. **Balance and stock reconciliation:** Test insert, update, delete, document cancellation, customer/supplier reassignment, document-type changes, and concurrent transactions. Compare stored balances/stock against totals derived from source documents.
4. **Authentication and permissions:** Verify the `ProfitUser` mapping, logins, database roles, grants, and the application runtime identity.
5. **Company isolation:** Test that a user cannot read or modify another company’s records by changing IDs or calling procedures directly.
6. **Audit trail:** No generic `AuditLog` table was found in the scripts; `InsertUser`, `InsertDate`, `LastUpdateUser`, and `LastUpdateDate` are not historical auditing.
7. **Naming consistency:** `Client` and `Provider` are existing schema terms; consider a planned, coordinated migration if standardizing to `Customer` and `Vendor`/`Supplier`.
8. **Constraint coverage:** Review unique constraints, check constraints, nullability, and referential actions for business rules not fully captured by foreign keys.
9. **Financial correctness:** Validate currency conversion, rounding, tax/discount calculation, payment allocation, document numbering, and debit/credit semantics with domain experts.
10. **Testing:** Add automated integration tests for stored procedures, triggers, constraints, company scoping, and rollback behavior.

## Suggested repository layout

```text
ProfitDatabaseV1/

├── Profit                      # Visual Studio Database project
├── README.md
├── ./Scripts/Profit.sql        # Contains the original database script.
├── ./Scripts/ProfitData.sql    # Script that inserts sample data
└── ./Scripts/Triggers.sql      # Constains database table triggers
```

Keep the deployed scripts and this documentation versioned together. Update the README whenever tables, columns, constraints, views, stored procedures, indexes, or trigger behavior changes.
