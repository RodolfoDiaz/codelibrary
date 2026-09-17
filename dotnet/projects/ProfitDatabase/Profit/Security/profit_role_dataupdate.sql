CREATE ROLE [profit_role_dataupdate]
    AUTHORIZATION [ProfitUser];


GO
ALTER ROLE [profit_role_dataupdate] ADD MEMBER [ProfitUser];

