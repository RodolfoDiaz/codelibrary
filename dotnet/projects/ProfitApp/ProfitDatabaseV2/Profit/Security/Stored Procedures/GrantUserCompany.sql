
CREATE   PROCEDURE [Security].[GrantUserCompany]
    @UserId int,
    @CompanyId int,
    @IsDefault bit = 0
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [Security].[Users] WHERE UserId=@UserId AND IsActive=1)
        THROW 51003, 'Application user does not exist or is inactive.', 1;

    IF NOT EXISTS (SELECT 1 FROM [Core].[Companies] WHERE CompanyId=@CompanyId)
        THROW 51004, 'Company does not exist.', 1;

    IF @IsDefault = 1
        UPDATE [Security].[UserCompanies] SET IsDefault=0 WHERE UserId=@UserId;

    IF EXISTS (SELECT 1 FROM [Security].[UserCompanies] WHERE UserId=@UserId AND CompanyId=@CompanyId)
        UPDATE [Security].[UserCompanies] SET IsDefault=@IsDefault WHERE UserId=@UserId AND CompanyId=@CompanyId;
    ELSE
        INSERT [Security].[UserCompanies](UserId,CompanyId,IsDefault)
        VALUES (@UserId,@CompanyId,@IsDefault);
END;

GO
GRANT EXECUTE
    ON OBJECT::[Security].[GrantUserCompany] TO [ERP_Admin]
    AS [dbo];

