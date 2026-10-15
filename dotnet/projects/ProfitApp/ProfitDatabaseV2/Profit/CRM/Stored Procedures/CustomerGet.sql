
CREATE   PROCEDURE [CRM].[CustomerGet]
    @CompanyId int,
    @CustomerId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM [CRM].[Customers]
    WHERE CompanyId = @CompanyId
      AND CustomerId = @CustomerId;
END;
