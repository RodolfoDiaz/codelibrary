
CREATE   PROCEDURE [Procurement].[VendorGet]
    @CompanyId int,
    @VendorId int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM [Procurement].[Vendors]
    WHERE CompanyId = @CompanyId
      AND VendorId = @VendorId;
END;
