CREATE SCHEMA [Reference]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Reference] TO [ERP_ReadOnly];


GO
GRANT SELECT
    ON SCHEMA::[Reference] TO [ERP_Sales];


GO
GRANT SELECT
    ON SCHEMA::[Reference] TO [ERP_Procurement];


GO
GRANT SELECT
    ON SCHEMA::[Reference] TO [ERP_Inventory];


GO
GRANT SELECT
    ON SCHEMA::[Reference] TO [ERP_Finance];

