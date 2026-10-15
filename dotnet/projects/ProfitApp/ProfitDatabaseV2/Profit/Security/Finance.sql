CREATE SCHEMA [Finance]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Finance] TO [ERP_ReadOnly];


GO
DENY DELETE
    ON SCHEMA::[Finance] TO [ERP_Finance];


GO
GRANT EXECUTE
    ON SCHEMA::[Finance] TO [ERP_Finance];


GO
GRANT INSERT
    ON SCHEMA::[Finance] TO [ERP_Finance];


GO
GRANT SELECT
    ON SCHEMA::[Finance] TO [ERP_Finance];


GO
GRANT UPDATE
    ON SCHEMA::[Finance] TO [ERP_Finance];


GO
GRANT SELECT
    ON SCHEMA::[Finance] TO [ERP_Auditor];

