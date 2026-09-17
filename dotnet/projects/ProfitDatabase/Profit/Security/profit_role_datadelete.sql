CREATE ROLE [profit_role_datadelete]
    AUTHORIZATION [ProfitUser];


GO
ALTER ROLE [profit_role_datadelete] ADD MEMBER [ProfitUser];

