
/* ---------------------------------------------------------------------------
   Operational views
--------------------------------------------------------------------------- */
CREATE   VIEW [Sales].[vSalesInvoiceBalances]
AS
SELECT
    I.CompanyId,
    I.SalesInvoiceId,
    I.InvoiceNumber,
    I.CustomerId,
    I.InvoiceDate,
    I.DueDate,
    I.TotalAmount,
    ISNULL(SUM(AR.CreditAmount - AR.DebitAmount), 0) AS AppliedAmount,
    I.TotalAmount - ISNULL(SUM(AR.CreditAmount - AR.DebitAmount), 0) AS OutstandingAmount,
    I.StatusCode
FROM [Sales].[SalesInvoices] I
LEFT JOIN [Finance].[AccountsReceivable] AR
    ON AR.CompanyId = I.CompanyId
   AND AR.SalesInvoiceId = I.SalesInvoiceId
GROUP BY
    I.CompanyId, I.SalesInvoiceId, I.InvoiceNumber, I.CustomerId,
    I.InvoiceDate, I.DueDate, I.TotalAmount, I.StatusCode;

GO
GRANT SELECT
    ON OBJECT::[Sales].[vSalesInvoiceBalances] TO [ERP_ReadOnly]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Sales].[vSalesInvoiceBalances] TO [ERP_Sales]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Sales].[vSalesInvoiceBalances] TO [ERP_Finance]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Sales].[vSalesInvoiceBalances] TO [ERP_Auditor]
    AS [dbo];

