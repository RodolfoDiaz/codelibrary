
/* ---------------------------------------------------------------------------
   Application session context
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Security].[SetSessionContext]
    @UserId int,
    @CompanyId int,
    @ApplicationName nvarchar(128) = NULL,
    @CorrelationId uniqueidentifier = NULL
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Security].[Users] U
        INNER JOIN [Security].[UserCompanies] UC ON UC.UserId = U.UserId
        WHERE U.UserId = @UserId
          AND UC.CompanyId = @CompanyId
          AND U.IsActive = 1
    )
        THROW 51000, 'The user is not authorized for the selected company.', 1;

    EXEC sys.sp_set_session_context @key = N'UserId', @value = @UserId;
    EXEC sys.sp_set_session_context @key = N'CompanyId', @value = @CompanyId;
    EXEC sys.sp_set_session_context @key = N'ApplicationName', @value = @ApplicationName;
    EXEC sys.sp_set_session_context @key = N'CorrelationId', @value = @CorrelationId;
END;

GO
GRANT EXECUTE
    ON OBJECT::[Security].[SetSessionContext] TO [ProfitApp]
    AS [dbo];

