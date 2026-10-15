
CREATE   VIEW [Procurement].[vVendorInvoiceBalances]
AS
SELECT
    I.CompanyId,
    I.VendorInvoiceId,
    I.InvoiceNumber,
    I.VendorId,
    I.InvoiceDate,
    I.DueDate,
    I.TotalAmount,
    ISNULL(SUM(AP.DebitAmount - AP.CreditAmount), 0) AS AppliedAmount,
    I.TotalAmount - ISNULL(SUM(AP.DebitAmount - AP.CreditAmount), 0) AS OutstandingAmount,
    I.StatusCode
FROM [Procurement].[VendorInvoices] I
LEFT JOIN [Finance].[AccountsPayable] AP
    ON AP.CompanyId = I.CompanyId
   AND AP.VendorInvoiceId = I.VendorInvoiceId
GROUP BY
    I.CompanyId, I.VendorInvoiceId, I.InvoiceNumber, I.VendorId,
    I.InvoiceDate, I.DueDate, I.TotalAmount, I.StatusCode;

GO
GRANT SELECT
    ON OBJECT::[Procurement].[vVendorInvoiceBalances] TO [ERP_ReadOnly]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Procurement].[vVendorInvoiceBalances] TO [ERP_Procurement]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Procurement].[vVendorInvoiceBalances] TO [ERP_Finance]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[Procurement].[vVendorInvoiceBalances] TO [ERP_Auditor]
    AS [dbo];

