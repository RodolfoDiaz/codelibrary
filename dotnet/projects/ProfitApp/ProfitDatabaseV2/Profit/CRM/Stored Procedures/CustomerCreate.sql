
/* ---------------------------------------------------------------------------
   Core CRUD procedures
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [CRM].[CustomerCreate]
    @CompanyId int,
    @CustomerNumber nvarchar(50),
    @LegalName nvarchar(200),
    @TaxIdentificationNumber nvarchar(50) = NULL,
    @CountryId int,
    @StateId int = NULL,
    @EmailAddress nvarchar(320) = NULL,
    @CreditLimit decimal(19,4) = 0,
    @CustomerId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    INSERT [CRM].[Customers]
        (CompanyId, CustomerNumber, LegalName, TaxIdentificationNumber,
         CountryId, StateId, EmailAddress, CreditLimit)
    VALUES
        (@CompanyId, @CustomerNumber, @LegalName, @TaxIdentificationNumber,
         @CountryId, @StateId, @EmailAddress, @CreditLimit);

    SET @CustomerId = CONVERT(int, SCOPE_IDENTITY());
END;
