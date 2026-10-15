CREATE TABLE [Procurement].[VendorPayments] (
    [VendorPaymentId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [VendorId]        INT             NOT NULL,
    [CurrencyId]      INT             NOT NULL,
    [PaymentMethodId] INT             NOT NULL,
    [PaymentDate]     DATETIME2 (3)   NOT NULL,
    [Amount]          DECIMAL (19, 4) NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_VendorPayments_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [ReferenceNumber] NVARCHAR (100)  NULL,
    [Remarks]         NVARCHAR (1000) NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_VendorPayments] PRIMARY KEY CLUSTERED ([VendorPaymentId] ASC),
    CONSTRAINT [CK_VendorPayments_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_VendorPayments_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_VendorPayments_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_VendorPayments_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_VendorPayments_PaymentMethods] FOREIGN KEY ([CompanyId], [PaymentMethodId]) REFERENCES [Reference].[PaymentMethods] ([CompanyId], [PaymentMethodId]),
    CONSTRAINT [FK_VendorPayments_Vendors] FOREIGN KEY ([CompanyId], [VendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId])
);


GO
CREATE NONCLUSTERED INDEX [IX_VendorPayments_Vendor_Date]
    ON [Procurement].[VendorPayments]([CompanyId] ASC, [VendorId] ASC, [PaymentDate] DESC)
    INCLUDE([Amount], [CurrencyId], [ReferenceNumber]);


GO

CREATE   TRIGGER [Procurement].[tr_Audit_Procurement_VendorPayments]
ON [Procurement].[VendorPayments]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
    DECLARE @SessionCompanyId int = TRY_CONVERT(int, SESSION_CONTEXT(N'CompanyId'));
    DECLARE @ApplicationUser nvarchar(256) = ORIGINAL_LOGIN();
    DECLARE @ApplicationName nvarchar(128) = TRY_CONVERT(nvarchar(128), SESSION_CONTEXT(N'ApplicationName'));
    DECLARE @CorrelationId uniqueidentifier = TRY_CONVERT(uniqueidentifier, SESSION_CONTEXT(N'CorrelationId'));

    INSERT [Audit].[AuditLog]
    (
        AuditDate, ActionType, SchemaName, TableName, RecordId, CompanyId,
        UserId, ApplicationUser, ApplicationName, HostName, IpAddress,
        SessionId, CorrelationId, OldValues, NewValues, ChangedColumns
    )
    SELECT
        SYSUTCDATETIME(),
        CASE WHEN i.[VendorPaymentId] IS NULL THEN 'DELETE'
             WHEN d.[VendorPaymentId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorPayments',
        COALESCE(CONVERT(bigint, i.[VendorPaymentId]), CONVERT(bigint, d.[VendorPaymentId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorPaymentId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorPaymentId] = COALESCE(i.[VendorPaymentId], d.[VendorPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorPaymentId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorPaymentId] = COALESCE(i.[VendorPaymentId], d.[VendorPaymentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorPaymentId] = d.[VendorPaymentId];
END;
