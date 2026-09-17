CREATE ROLE [profit_role_datainsert]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [profit_role_datainsert] ADD MEMBER [ProfitUser];

