CREATE ROLE [profit_role_datainsert]
    AUTHORIZATION [ProfitUser];


GO
ALTER ROLE [profit_role_datainsert] ADD MEMBER [ProfitUser];

