CREATE ROLE [profit_role_datareader]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [profit_role_datareader] ADD MEMBER [ProfitUser];

