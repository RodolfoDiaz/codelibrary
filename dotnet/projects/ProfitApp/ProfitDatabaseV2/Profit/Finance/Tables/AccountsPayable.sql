CREATE TABLE [Finance].[AccountsPayable] (
    [PayableId]       BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [VendorId]        INT             NOT NULL,
    [VendorInvoiceId] BIGINT          NULL,
    [TransactionDate] DATE            NOT NULL,
    [DueDate]         DATE            NULL,
    [DebitAmount]     DECIMAL (19, 4) CONSTRAINT [DF_AP_Debit] DEFAULT ((0)) NOT NULL,
    [CreditAmount]    DECIMAL (19, 4) CONSTRAINT [DF_AP_Credit] DEFAULT ((0)) NOT NULL,
    [CurrencyId]      INT             NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_AP_Rate] DEFAULT ((1)) NOT NULL,
    [ReferenceType]   NVARCHAR (50)   NULL,
    [ReferenceId]     BIGINT          NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_AccountsPayable] PRIMARY KEY CLUSTERED ([PayableId] ASC),
    CONSTRAINT [CK_AP_Amounts] CHECK ([DebitAmount]>(0) AND [CreditAmount]=(0) OR [CreditAmount]>(0) AND [DebitAmount]=(0)),
    CONSTRAINT [CK_AP_Rate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_AP_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_AP_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_AP_Invoices] FOREIGN KEY ([CompanyId], [VendorInvoiceId]) REFERENCES [Procurement].[VendorInvoices] ([CompanyId], [VendorInvoiceId]),
    CONSTRAINT [FK_AP_Vendors] FOREIGN KEY ([CompanyId], [VendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId])
);


GO
CREATE NONCLUSTERED INDEX [IX_AP_Vendor_DueDate]
    ON [Finance].[AccountsPayable]([CompanyId] ASC, [VendorId] ASC, [DueDate] ASC)
    INCLUDE([DebitAmount], [CreditAmount], [VendorInvoiceId]);


GO

CREATE   TRIGGER [Finance].[tr_Audit_Finance_AccountsPayable]
ON [Finance].[AccountsPayable]
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
        CASE WHEN i.[PayableId] IS NULL THEN 'DELETE'
             WHEN d.[PayableId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'AccountsPayable',
        COALESCE(CONVERT(bigint, i.[PayableId]), CONVERT(bigint, d.[PayableId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[PayableId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[PayableId] = COALESCE(i.[PayableId], d.[PayableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[PayableId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[PayableId] = COALESCE(i.[PayableId], d.[PayableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[PayableId] = d.[PayableId];
END;
