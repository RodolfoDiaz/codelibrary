
/* ---------------------------------------------------------------------------
   Sales invoice posting - transactionally creates AR and inventory movement.
   The procedure expects invoice lines to already exist.
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Sales].[PostSalesInvoice]
    @CompanyId int,
    @SalesInvoiceId bigint
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Status nvarchar(30);

    BEGIN TRANSACTION;

    SELECT @Status = StatusCode
    FROM [Sales].[SalesInvoices] WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId
      AND SalesInvoiceId = @SalesInvoiceId;

    IF @Status IS NULL
        THROW 51010, 'Sales invoice not found.', 1;

    IF @Status = N'POSTED'
    BEGIN
        COMMIT;
        RETURN;
    END;

    IF @Status <> N'DRAFT'
        THROW 51011, 'Only DRAFT sales invoices can be posted.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM [Sales].[SalesInvoiceLines]
        WHERE CompanyId = @CompanyId
          AND SalesInvoiceId = @SalesInvoiceId
    )
        THROW 51012, 'Sales invoice must contain at least one line.', 1;

    UPDATE [Sales].[SalesInvoices]
       SET StatusCode = N'POSTED'
     WHERE CompanyId = @CompanyId
       AND SalesInvoiceId = @SalesInvoiceId;

    INSERT [Finance].[AccountsReceivable]
        (CompanyId, CustomerId, SalesInvoiceId, TransactionDate, DueDate,
         DebitAmount, CreditAmount, CurrencyId, ExchangeRate,
         ReferenceType, ReferenceId)
    SELECT CompanyId, CustomerId, SalesInvoiceId, InvoiceDate, DueDate,
           TotalAmount, 0, CurrencyId, ExchangeRate,
           N'SalesInvoice', SalesInvoiceId
    FROM [Sales].[SalesInvoices]
    WHERE CompanyId = @CompanyId
      AND SalesInvoiceId = @SalesInvoiceId;

    COMMIT;
END;
