
CREATE   PROCEDURE [CRM].[CustomerUpdate]
    @CustomerId int,
    @CompanyId int,
    @LegalName nvarchar(200),
    @EmailAddress nvarchar(320) = NULL,
    @CreditLimit decimal(19,4),
    @IsActive bit,
    @RowVersion binary(8)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    UPDATE C
       SET LegalName = @LegalName,
           EmailAddress = @EmailAddress,
           CreditLimit = @CreditLimit,
           IsActive = @IsActive
    FROM [CRM].[Customers] C
    WHERE C.CustomerId = @CustomerId
      AND C.CompanyId = @CompanyId
      AND C.RowVersion = @RowVersion;

    IF @@ROWCOUNT = 0
        THROW 51002, 'Customer was not found or was changed by another transaction.', 1;
END;
