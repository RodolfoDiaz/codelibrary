CREATE SCHEMA [Procurement]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Procurement] TO [ERP_ReadOnly];


GO
DENY DELETE
    ON SCHEMA::[Procurement] TO [ERP_Procurement];


GO
GRANT INSERT
    ON SCHEMA::[Procurement] TO [ERP_Procurement];


GO
GRANT SELECT
    ON SCHEMA::[Procurement] TO [ERP_Procurement];


GO
GRANT UPDATE
    ON SCHEMA::[Procurement] TO [ERP_Procurement];


GO
GRANT SELECT
    ON SCHEMA::[Procurement] TO [ERP_Finance];


GO
GRANT SELECT
    ON SCHEMA::[Procurement] TO [ERP_Auditor];

