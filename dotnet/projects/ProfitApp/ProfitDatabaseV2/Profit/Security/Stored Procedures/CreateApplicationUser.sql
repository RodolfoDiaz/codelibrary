
/* ---------------------------------------------------------------------------
   Security administration helpers
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Security].[CreateApplicationUser]
    @UserName nvarchar(100),
    @DisplayName nvarchar(200) = NULL,
    @EmailAddress nvarchar(320) = NULL,
    @UserId int OUTPUT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    INSERT [Security].[Users](UserName, DisplayName, EmailAddress)
    VALUES (@UserName, @DisplayName, @EmailAddress);

    SET @UserId = CONVERT(int, SCOPE_IDENTITY());
END;

GO
GRANT EXECUTE
    ON OBJECT::[Security].[CreateApplicationUser] TO [ERP_Admin]
    AS [dbo];

