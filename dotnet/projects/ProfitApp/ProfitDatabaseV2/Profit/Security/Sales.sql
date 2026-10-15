CREATE SCHEMA [Sales]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Sales] TO [ERP_ReadOnly];


GO
DENY DELETE
    ON SCHEMA::[Sales] TO [ERP_Sales];


GO
GRANT EXECUTE
    ON SCHEMA::[Sales] TO [ERP_Sales];


GO
GRANT SELECT
    ON SCHEMA::[Sales] TO [ERP_Sales];


GO
GRANT SELECT
    ON SCHEMA::[Sales] TO [ERP_Auditor];

