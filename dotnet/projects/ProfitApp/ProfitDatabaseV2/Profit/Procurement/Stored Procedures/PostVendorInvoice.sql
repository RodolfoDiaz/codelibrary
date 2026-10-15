
/* ---------------------------------------------------------------------------
   Purchase invoice posting
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Procurement].[PostVendorInvoice]
    @CompanyId int,
    @VendorInvoiceId bigint
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Status nvarchar(30);

    BEGIN TRANSACTION;

    SELECT @Status = StatusCode
    FROM [Procurement].[VendorInvoices] WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId
      AND VendorInvoiceId = @VendorInvoiceId;

    IF @Status IS NULL
        THROW 51020, 'Vendor invoice not found.', 1;

    IF @Status = N'POSTED'
    BEGIN
        COMMIT;
        RETURN;
    END;

    IF @Status <> N'DRAFT'
        THROW 51021, 'Only DRAFT vendor invoices can be posted.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Procurement].[VendorInvoiceLines]
        WHERE CompanyId = @CompanyId
          AND VendorInvoiceId = @VendorInvoiceId
    )
        THROW 51022, 'Vendor invoice must contain at least one line.', 1;

    UPDATE [Procurement].[VendorInvoices]
       SET StatusCode = N'POSTED'
     WHERE CompanyId = @CompanyId
       AND VendorInvoiceId = @VendorInvoiceId;

    INSERT [Finance].[AccountsPayable]
        (CompanyId, VendorId, VendorInvoiceId, TransactionDate, DueDate,
         DebitAmount, CreditAmount, CurrencyId, ExchangeRate,
         ReferenceType, ReferenceId)
    SELECT CompanyId, VendorId, VendorInvoiceId, InvoiceDate, DueDate,
           0, TotalAmount, CurrencyId, ExchangeRate,
           N'VendorInvoice', VendorInvoiceId
    FROM [Procurement].[VendorInvoices]
    WHERE CompanyId = @CompanyId
      AND VendorInvoiceId = @VendorInvoiceId;

    COMMIT;
END;
