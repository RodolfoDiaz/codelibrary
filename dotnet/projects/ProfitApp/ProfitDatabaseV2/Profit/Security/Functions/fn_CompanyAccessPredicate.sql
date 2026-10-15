
/* ---------------------------------------------------------------------------
   Row-Level Security
   The application must execute Security.SetSessionContext first.
--------------------------------------------------------------------------- */
CREATE   FUNCTION [Security].[fn_CompanyAccessPredicate]
(
    @CompanyId int
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 1 AS AccessResult
    WHERE
        IS_MEMBER(N'ERP_Admin') = 1
        OR
        EXISTS
        (
            SELECT 1
            FROM [Security].[UserCompanies] UC
            INNER JOIN [Security].[Users] U
                ON U.UserId = UC.UserId
            WHERE UC.CompanyId = @CompanyId
              AND UC.UserId = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'))
              AND U.IsActive = 1
        )
);
