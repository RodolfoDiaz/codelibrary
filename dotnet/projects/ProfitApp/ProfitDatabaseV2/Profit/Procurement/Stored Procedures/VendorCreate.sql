
CREATE   PROCEDURE [Procurement].[VendorCreate]
    @CompanyId int,
    @VendorNumber nvarchar(50),
    @LegalName nvarchar(200),
    @TaxIdentificationNumber nvarchar(50) = NULL,
    @CountryId int,
    @StateId int = NULL,
    @EmailAddress nvarchar(320) = NULL,
    @CreditLimit decimal(19,4) = 0,
    @VendorId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    INSERT [Procurement].[Vendors]
        (CompanyId, VendorNumber, LegalName, TaxIdentificationNumber,
         CountryId, StateId, EmailAddress, CreditLimit)
    VALUES
        (@CompanyId, @VendorNumber, @LegalName, @TaxIdentificationNumber,
         @CountryId, @StateId, @EmailAddress, @CreditLimit);

    SET @VendorId = CONVERT(int, SCOPE_IDENTITY());
END;
