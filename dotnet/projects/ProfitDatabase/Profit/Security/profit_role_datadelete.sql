CREATE ROLE [profit_role_datadelete]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [profit_role_datadelete] ADD MEMBER [ProfitUser];

