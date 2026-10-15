CREATE ROLE [profit_role_dataupdate]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [profit_role_dataupdate] ADD MEMBER [ProfitUser];

