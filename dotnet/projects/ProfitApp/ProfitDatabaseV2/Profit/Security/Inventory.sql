CREATE SCHEMA [Inventory]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Inventory] TO [ERP_ReadOnly];


GO
GRANT SELECT
    ON SCHEMA::[Inventory] TO [ERP_Sales];


GO
GRANT EXECUTE
    ON SCHEMA::[Inventory] TO [ERP_Procurement];


GO
GRANT SELECT
    ON SCHEMA::[Inventory] TO [ERP_Procurement];


GO
DENY DELETE
    ON SCHEMA::[Inventory] TO [ERP_Inventory];


GO
GRANT EXECUTE
    ON SCHEMA::[Inventory] TO [ERP_Inventory];


GO
GRANT INSERT
    ON SCHEMA::[Inventory] TO [ERP_Inventory];


GO
GRANT SELECT
    ON SCHEMA::[Inventory] TO [ERP_Inventory];


GO
GRANT UPDATE
    ON SCHEMA::[Inventory] TO [ERP_Inventory];


GO
GRANT SELECT
    ON SCHEMA::[Inventory] TO [ERP_Auditor];

