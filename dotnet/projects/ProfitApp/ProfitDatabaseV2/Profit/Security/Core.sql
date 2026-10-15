CREATE SCHEMA [Core]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_ReadOnly];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_Sales];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_Procurement];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_Inventory];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_Finance];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_HR];


GO
GRANT SELECT
    ON SCHEMA::[Core] TO [ERP_Auditor];

