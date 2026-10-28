# ProfitApp Security Model

## 1. Purpose

This document defines the recommended security architecture for **ProfitApp**, an ASP.NET Core 10 web application connected to the **Profit** ERP database on Microsoft SQL Server 2025.

The security model must support:

- Secure user authentication using established standards.
- Authorization by application module and permitted operation.
- Access to one or more companies, with company-level data isolation.
- Restricted database access using least privilege.
- Auditing of security-sensitive and business operations.
- Protection against unauthorized access, SQL injection, credential theft, and privilege escalation.

This document describes the intended application architecture and the relevant database security mechanisms. It is not a claim that every recommended control is already implemented in the database scripts.

## 2. Security architecture

ProfitApp should use multiple complementary security layers.

```text
User
 |
 | HTTPS
 v
ASP.NET Core 10 Web Application
 |
 +-- Authentication
 |     OpenID Connect / OAuth 2.0
 |     Identity provider or ASP.NET Core Identity
 |
 +-- Application Authorization
 |     Policies and permissions
 |     Module and operation access
 |     Company membership checks
 |
 +-- Business and Data Access Layer
 |     Validated requests
 |     Parameterized SQL / EF Core
 |     Trusted company and user context
 |
 | Restricted application identity
 v
SQL Server 2025 - Profit
 |
 +-- Database roles and object permissions
 +-- Row-Level Security (RLS)
 +-- Security.Users
 +-- Security.UserCompanies
 +-- Audit.AuditLog
```

Each layer serves a different purpose. Authentication identifies the user, application authorization decides what the user may do, and database controls restrict the data operations available to the application identity.

## 3. Authentication: Who is the user?

### 3.1 Recommended approach

For a business application, the preferred approach is to use a trusted identity provider through **OpenID Connect (OIDC)**.

Possible approaches include:

1. **Microsoft Entra ID** — recommended when ProfitApp belongs to an organization already using Microsoft Entra ID.
2. **Another trusted OIDC provider** — appropriate when the organization uses a different identity platform.
3. **ASP.NET Core Identity** — appropriate when ProfitApp must manage local user accounts, password hashes, password resets, lockouts, and related account functionality itself.

Do not implement a custom password-storage or password-verification mechanism.

For interactive browser applications, use the provider's supported sign-in flow and secure server-side authentication cookies where appropriate. For APIs called by separate clients, use OAuth 2.0 access tokens and validate them with the appropriate ASP.NET Core authentication handler.

Use HTTPS throughout the application.

### 3.2 Authentication responsibilities

The authentication system should handle:

- Credential verification through the identity provider or ASP.NET Core Identity.
- Multi-factor authentication where required by organizational policy.
- Password reset and account recovery, if local accounts are supported.
- Account lockout and suspicious sign-in monitoring, where applicable.
- Session expiration and sign-out.
- Secure cookie settings or access-token validation.
- Identity-provider issuer, audience, signature, and lifetime validation as applicable.

For cookie-authenticated applications, use secure, HTTP-only cookies and appropriate `SameSite` settings. Protect state-changing requests against cross-site request forgery (CSRF).

Do not store passwords, password hashes, access tokens, or session secrets in ordinary application logs.

### 3.3 The database is not the authentication provider

The existing `Security.Users` table represents an application user record. It is not, by itself, a complete authentication system.

The table does not contain a password field. Keep it that way if an external identity provider is used.

A user record should be associated with the authenticated identity through a stable identifier, such as the identity provider's subject (`sub`) together with its issuer, or through an explicitly mapped identity-provider object ID.

Do not use a display name or email address as the sole permanent identity key; those values can change.

If local authentication is required, use ASP.NET Core Identity and its supported user store rather than adding an improvised password column to `Security.Users`.

## 4. Application authorization: What can the user do?

Authentication does not automatically authorize a user to access every area of ProfitApp.

ProfitApp should use **policy-based authorization**, backed by explicit permissions. Permissions should represent business capabilities rather than merely whether a menu item is visible.

### 4.1 Suggested permission catalog

Use stable permission identifiers such as:

| Application area | Example permissions |
|---|---|
| Dashboard | `Dashboard.View` |
| Customers | `CRM.Customers.Read`, `CRM.Customers.Create`, `CRM.Customers.Update` |
| Vendors | `Procurement.Vendors.Read`, `Procurement.Vendors.Create`, `Procurement.Vendors.Update` |
| Sales | `Sales.Orders.Read`, `Sales.Orders.Create`, `Sales.Orders.Update` |
| Invoicing | `Sales.Invoices.Read`, `Sales.Invoices.Create`, `Sales.Invoices.Post`, `Sales.Invoices.Void` |
| Inventory | `Inventory.Items.Read`, `Inventory.Stock.Adjust` |
| Finance | `Finance.Reports.Read`, `Finance.Journals.Post` |
| Human Resources | `HR.Employees.Read`, `HR.Employees.Update` |
| Security administration | `Security.Users.Manage`, `Security.Roles.Manage`, `Security.CompanyAccess.Manage` |
| Audit | `Audit.Log.Read` |

These are proposed application permissions, not a claim that they already exist in the current SQL scripts. Refine the catalog according to actual workflows and separation-of-duties requirements.

### 4.2 Roles should group permissions

Assign users one or more roles, then assign permissions to roles.

For example:

| Role | Illustrative permissions |
|---|---|
| Sales Clerk | Read customers; create and update sales orders |
| Sales Manager | Sales Clerk permissions; approve or post permitted sales transactions |
| Procurement Clerk | Read vendors; create purchase orders |
| Inventory Operator | Read inventory; perform authorized stock operations |
| Finance Accountant | Read finance records; prepare journal entries |
| Finance Manager | Finance Accountant permissions; approve permitted financial operations |
| HR Officer | Access permitted employee information |
| Auditor | Read authorized audit records |
| Profit Administrator | Manage application users, roles, and access assignments |

These are examples, not default grants. Sensitive operations such as posting invoices, voiding transactions, adjusting inventory, and managing access should be explicitly granted and audited.

Avoid giving every user a broad `Administrator` role. Separate routine work from privileged administration.

### 4.3 Where should roles and permissions live?

The current Profit database design includes:

- `Security.Users`
- `Security.UserCompanies`
- SQL Server database roles such as `ERP_ReadOnly`, `ERP_Sales`, `ERP_Procurement`, `ERP_Inventory`, `ERP_Finance`, `ERP_HR`, `ERP_Auditor`, and `ERP_Admin`

However, SQL database roles are not automatically equivalent to the roles of individual users in the web application.

The existing `Security.Users` and `Security.UserCompanies` tables do not, by themselves, provide a complete application module-permission model.

Choose one of these designs:

**Option A — ASP.NET Core Identity roles and claims**

Use ASP.NET Core Identity for application users and roles. Add explicit permission claims or a custom authorization service when roles need to map to fine-grained business permissions.

**Option B — Profit-managed application authorization**

Extend the `Security` schema with tables such as:

- `Security.ApplicationRoles`
- `Security.Permissions`
- `Security.UserRoles`
- `Security.RolePermissions`

Add appropriate constraints, indexes, audit events, and administration workflows.

In this model, `Security.Users` should be mapped to the authenticated external identity. The application authorization service resolves the user's roles and permissions from the trusted identity and application data.

Both designs can work. Select one as the authoritative source for application permissions, document the decision, and avoid maintaining conflicting role assignments in multiple places.

## 5. Enforcing authorization in ASP.NET Core

### 5.1 Register authorization policies

A simplified example using .NET 10:

```csharp
using Microsoft.AspNetCore.Authorization;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddAuthentication(/* configure OIDC or cookies */);

builder.Services.AddAuthorization(options =>
{
    options.FallbackPolicy = new AuthorizationPolicyBuilder()
        .RequireAuthenticatedUser()
        .Build();

    options.AddPolicy("Customers.Read", policy =>
        policy.RequireClaim("permission", "CRM.Customers.Read"));

    options.AddPolicy("Invoices.Post", policy =>
        policy.RequireClaim("permission", "Sales.Invoices.Post"));

    options.AddPolicy("Users.Manage", policy =>
        policy.RequireClaim("permission", "Security.Users.Manage"));
});

var app = builder.Build();

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
```

This example assumes the application has a trusted mechanism for issuing or loading permission claims. The policies will not work as intended until those claims are reliably populated and validated.

If permissions come from the Profit database, implement a custom authorization service or authorization handler that checks the current user's assigned permissions. Do not trust permission values submitted by the browser.

### 5.2 Apply policies to endpoints

```csharp
[Authorize(Policy = "Customers.Read")]
[HttpGet]
public async Task<IActionResult> Index()
{
    // Retrieve only data the authenticated user is allowed to access.
    return Ok();
}
```

For sensitive operations, use distinct permissions. For example, permission to view invoices should not automatically grant permission to post or void invoices.

Apply authorization to all relevant endpoints, including API endpoints, MVC controllers, Razor Pages, and background operations. Do not rely on hiding buttons, links, or navigation menu items in the user interface.

### 5.3 Resource-based authorization

Some decisions depend on the specific record being accessed. For example, a user may have permission to read sales orders but only for a particular company.

In such cases, combine policy authorization with resource-level checks. Load the resource using the authorized company scope and verify the user's access before returning or changing it.

Use `IAuthorizationService` and custom authorization handlers when authorization depends on a resource, company, transaction state, or other business rule.

### 5.4 Deny by default

- Require authentication by default for protected endpoints.
- Explicitly mark only intended public endpoints as anonymous.
- Deny access when a permission cannot be resolved.
- Recheck authorization for sensitive operations on the server.
- Invalidate or refresh cached permissions when roles or assignments change.
- Record security-sensitive authorization failures without logging secrets.

## 6. Company-level authorization

Profit is designed for multiple companies. A user who has access to one company must not automatically gain access to another.

The existing `Security.UserCompanies` mapping represents which users are assigned to which companies.

For each request that accesses company-scoped data, the application should:

1. Authenticate the user.
2. Resolve the Profit user record associated with the authenticated identity.
3. Determine the requested company.
4. Verify that the user is assigned to that company.
5. Verify the user's permission for the requested operation.
6. Execute the data operation with the validated company context.

Treat a company ID supplied by a URL, request body, query string, or client-side state as untrusted until its access has been verified.

**Company membership and application permissions are separate controls.** A user may be allowed to access Sales but only within companies assigned to them.

## 7. SQL Server connectivity

### 7.1 Use a restricted application identity

The web application normally connects to SQL Server using one restricted application identity, rather than creating a SQL login for every human user.

Preferred choices:

1. A managed identity or supported Microsoft Entra database authentication approach when the deployment environment supports it.
2. Otherwise, a dedicated SQL Server login with a strong, rotated secret held in an approved secrets manager.

Do not place production credentials in source control, configuration files committed to the repository, container images, or logs.

The SQL application identity must not be a member of `sysadmin`, `db_owner`, or another unnecessarily privileged role.

### 7.2 Database roles

The Profit script defines database roles for functional areas, including `ERP_ReadOnly`, `ERP_Sales`, `ERP_Procurement`, `ERP_Inventory`, `ERP_Finance`, `ERP_HR`, `ERP_Auditor`, and `ERP_Admin`.

These are SQL database security principals. Their permissions must be reviewed independently of the web application's user roles.

The script initially places `ProfitApp` in `ERP_ReadOnly` and grants execution of `Security.SetSessionContext`. This does **not** automatically provide all permissions needed to perform sales, procurement, inventory, finance, or HR operations.

Before enabling each workflow:

- Grant only the necessary database permissions.
- Prefer controlled stored procedures for sensitive operations where appropriate.
- Avoid granting broad write access to entire schemas without a documented requirement.
- Test that unauthorized operations fail at the database level where database enforcement is intended.
- Document the required grants for every application feature.

## 8. Row-Level Security and SESSION_CONTEXT

The Profit database design includes a company-access predicate and a row-level security policy using session context.

`Security.SetSessionContext` accepts values including the application user ID and company ID, checks that the user is active and assigned to the company, and sets session context for database operations.

The intended flow is:

1. The application authenticates the human user.
2. The application maps that identity to `Security.Users`.
3. The application validates the requested company and permissions.
4. The application opens a SQL connection.
5. It sets the required session context on that same connection.
6. It executes the protected queries or commands using that connection.
7. It closes or returns the connection to the pool safely.

Session context must be set for every logical operation that requires it. With connection pooling, do not assume that a newly opened logical connection has a new physical connection or a clean session. Test context behavior and cleanup explicitly.

### 8.1 Important trust boundary

The current session-context procedure validates the user/company membership pair, but it does not independently prove that the supplied user ID belongs to the human authenticated by ASP.NET Core.

Because multiple human users share the same `ProfitApp` SQL identity, a compromised application tier or stolen shared SQL credential could potentially set context for another valid user/company pair.

Therefore, the current design should be treated as **defense in depth against query mistakes**, not as cryptographic proof of the human user's identity.

Mitigations include:

- Harden and monitor the application tier.
- Keep the SQL credential secret and restricted.
- Use parameterized queries and tightly controlled data-access paths.
- Validate permissions and company access in the application.
- Restrict direct database access from untrusted clients.
- Review whether the threat model requires a stronger database identity-propagation design.

Do not claim that checking membership in `Security.UserCompanies` alone prevents a compromised application from impersonating another authorized user.

## 9. Data access and SQL injection

Use Entity Framework Core or parameterized SQL commands. Never concatenate untrusted user input into SQL statements.

Additional requirements:

- Validate input and enforce business rules on the server.
- Use transactions for multi-step financial operations.
- Use optimistic concurrency where appropriate.
- Restrict dynamic SQL and validate identifiers that cannot be parameterized.
- Avoid returning database exception details to end users.
- Apply pagination and query limits to large result sets.
- Review stored procedures for unsafe dynamic SQL and excessive permissions.

## 10. Auditing and monitoring

The database design includes `Audit.AuditLog` and audit triggers intended to record changes to audited tables.

Audit events should be reviewed for completeness and reliability. In particular, verify that the authenticated application user and company can be reliably associated with each database operation. The audit trail should not imply stronger identity assurance than the underlying session-context trust model provides.

Log security-sensitive events such as:

- Successful and failed sign-ins, as supported by the identity provider.
- Changes to users, roles, permissions, and company assignments.
- Attempts to access unauthorized modules or companies.
- Posting, voiding, and reversal of financial transactions.
- Inventory adjustments.
- Changes to security configuration.
- Unexpected database permission failures.

Protect logs from unauthorized modification and avoid recording passwords, tokens, connection strings, or other secrets.

The current `AuditLog` design should also be tested to confirm that the expected old/new data, actor identity, correlation information, and changed-column details are recorded correctly. Do not assume every field is populated simply because it exists in the schema.

## 11. Secrets, transport, and deployment

- Enforce HTTPS and use secure TLS connections to SQL Server.
- Restrict SQL Server network access to trusted application hosts.
- Store production secrets in a managed secrets store.
- Rotate credentials and revoke unused accounts.
- Use separate identities and configuration for development, testing, and production.
- Apply least privilege to deployment and migration identities.
- Keep .NET, SQL Server, drivers, and dependencies patched.
- Protect backups and database files, and evaluate encryption at rest.
- Use security monitoring and alerting appropriate to the deployment.
- Do not expose database connectivity directly to a browser or untrusted client.

The SQL build script contains a placeholder application-login password. Replace it before deployment and ensure the actual secret is not committed to source control.

## 12. Suggested implementation sequence

1. Choose and configure the authentication provider.
2. Map the authenticated identity to a Profit user record.
3. Define the authoritative source for application roles and permissions.
4. Implement policy-based authorization for each module and operation.
5. Enforce company membership for all company-scoped operations.
6. Configure the restricted SQL application identity and grants.
7. Integrate session-context setup with the data-access layer.
8. Test RLS behavior with connection pooling enabled.
9. Validate auditing and security-event logging.
10. Add automated authorization and company-isolation tests.
11. Review secrets management, TLS, deployment permissions, and monitoring.
12. Conduct a security review before production release.

## 13. Minimum security test matrix

| Test | Expected result |
|---|---|
| Anonymous request to a protected endpoint | Rejected or redirected to sign-in |
| Authenticated user without the required permission | Access denied |
| Sales user requests an HR operation | Access denied |
| User accesses an unassigned company | Access denied |
| User attempts to change company ID in a request | Membership revalidated; unauthorized access denied |
| User can read invoices but cannot post them | Read succeeds; posting is denied |
| Application SQL identity attempts an ungranted operation | SQL Server rejects the operation |
| RLS query runs under a valid company context | Only authorized company rows are visible |
| Reused pooled connection serves a different company request | Correct context is set; no previous-company data leaks |
| User loses a role or company assignment | Subsequent access reflects the revoked assignment |
| Malicious input is supplied to a query | No SQL injection; input is safely handled |
| Sensitive operation is completed | Appropriate audit record is created |
| Application logs an authentication or database error | No credentials or tokens are disclosed |

## 14. Official references

- [ASP.NET Core security overview](https://learn.microsoft.com/en-us/aspnet/core/security/?view=aspnetcore-10.0)
- [Overview of ASP.NET Core authentication](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/?view=aspnetcore-10.0)
- [Policy-based authorization in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authorization/policies?view=aspnetcore-10.0)
- [Secure user data with authorization in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authorization/secure-data?view=aspnetcore-10.0)
- [SQL Server Row-Level Security](https://learn.microsoft.com/en-us/sql/relational-databases/security/row-level-security?view=sql-server-ver17)
- [SQL Server security best practices](https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-server-security-best-practices?view=sql-server-ver17)

## 15. Final recommendation

Use a trusted authentication provider, policy-based application authorization, explicit company membership checks, a least-privilege SQL identity, and SQL Server Row-Level Security as complementary controls.

Do not treat SQL database roles as a substitute for per-user application permissions, and do not treat a user/company pair passed through a shared SQL connection as independently verified human identity.

The final design must be validated against the deployed Profit schema, application workflows, database grants, and the organization's threat model before production use.
