CREATE SCHEMA [Audit]
    AUTHORIZATION [dbo];


GO
DENY DELETE
    ON SCHEMA::[Audit] TO [ERP_ReadOnly];


GO
DENY INSERT
    ON SCHEMA::[Audit] TO [ERP_ReadOnly];


GO
DENY SELECT
    ON SCHEMA::[Audit] TO [ERP_ReadOnly];


GO
DENY UPDATE
    ON SCHEMA::[Audit] TO [ERP_ReadOnly];


GO
DENY DELETE
    ON SCHEMA::[Audit] TO [ERP_Sales];


GO
DENY INSERT
    ON SCHEMA::[Audit] TO [ERP_Sales];


GO
DENY SELECT
    ON SCHEMA::[Audit] TO [ERP_Sales];


GO
DENY UPDATE
    ON SCHEMA::[Audit] TO [ERP_Sales];


GO
DENY DELETE
    ON SCHEMA::[Audit] TO [ERP_Procurement];


GO
DENY INSERT
    ON SCHEMA::[Audit] TO [ERP_Procurement];


GO
DENY SELECT
    ON SCHEMA::[Audit] TO [ERP_Procurement];


GO
DENY UPDATE
    ON SCHEMA::[Audit] TO [ERP_Procurement];


GO
DENY DELETE
    ON SCHEMA::[Audit] TO [ERP_Inventory];


GO
DENY INSERT
    ON SCHEMA::[Audit] TO [ERP_Inventory];


GO
DENY SELECT
    ON SCHEMA::[Audit] TO [ERP_Inventory];


GO
DENY UPDATE
    ON SCHEMA::[Audit] TO [ERP_Inventory];


GO
DENY DELETE
    ON SCHEMA::[Audit] TO [ERP_Finance];


GO
DENY INSERT
    ON SCHEMA::[Audit] TO [ERP_Finance];


GO
DENY SELECT
    ON SCHEMA::[Audit] TO [ERP_Finance];


GO
DENY UPDATE
    ON SCHEMA::[Audit] TO [ERP_Finance];


GO
DENY DELETE
    ON SCHEMA::[Audit] TO [ERP_HR];


GO
DENY INSERT
    ON SCHEMA::[Audit] TO [ERP_HR];


GO
DENY SELECT
    ON SCHEMA::[Audit] TO [ERP_HR];


GO
DENY UPDATE
    ON SCHEMA::[Audit] TO [ERP_HR];


GO
GRANT SELECT
    ON SCHEMA::[Audit] TO [ERP_Auditor];


GO
GRANT DELETE
    ON SCHEMA::[Audit] TO [ERP_Admin];


GO
GRANT EXECUTE
    ON SCHEMA::[Audit] TO [ERP_Admin];


GO
GRANT INSERT
    ON SCHEMA::[Audit] TO [ERP_Admin];


GO
GRANT SELECT
    ON SCHEMA::[Audit] TO [ERP_Admin];


GO
GRANT UPDATE
    ON SCHEMA::[Audit] TO [ERP_Admin];

