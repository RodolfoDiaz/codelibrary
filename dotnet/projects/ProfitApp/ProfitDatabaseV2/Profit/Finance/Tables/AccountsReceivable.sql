CREATE TABLE [Finance].[AccountsReceivable] (
    [ReceivableId]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT             NOT NULL,
    [CustomerId]      INT             NOT NULL,
    [SalesInvoiceId]  BIGINT          NULL,
    [TransactionDate] DATE            NOT NULL,
    [DueDate]         DATE            NULL,
    [DebitAmount]     DECIMAL (19, 4) CONSTRAINT [DF_AR_Debit] DEFAULT ((0)) NOT NULL,
    [CreditAmount]    DECIMAL (19, 4) CONSTRAINT [DF_AR_Credit] DEFAULT ((0)) NOT NULL,
    [CurrencyId]      INT             NOT NULL,
    [ExchangeRate]    DECIMAL (19, 8) CONSTRAINT [DF_AR_Rate] DEFAULT ((1)) NOT NULL,
    [ReferenceType]   NVARCHAR (50)   NULL,
    [ReferenceId]     BIGINT          NULL,
    [RowVersion]      ROWVERSION      NOT NULL,
    CONSTRAINT [PK_AccountsReceivable] PRIMARY KEY CLUSTERED ([ReceivableId] ASC),
    CONSTRAINT [CK_AR_Amounts] CHECK ([DebitAmount]>(0) AND [CreditAmount]=(0) OR [CreditAmount]>(0) AND [DebitAmount]=(0)),
    CONSTRAINT [CK_AR_Rate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_AR_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_AR_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_AR_Customers] FOREIGN KEY ([CompanyId], [CustomerId]) REFERENCES [CRM].[Customers] ([CompanyId], [CustomerId]),
    CONSTRAINT [FK_AR_Invoices] FOREIGN KEY ([CompanyId], [SalesInvoiceId]) REFERENCES [Sales].[SalesInvoices] ([CompanyId], [SalesInvoiceId])
);


GO
CREATE NONCLUSTERED INDEX [IX_AR_Customer_DueDate]
    ON [Finance].[AccountsReceivable]([CompanyId] ASC, [CustomerId] ASC, [DueDate] ASC)
    INCLUDE([DebitAmount], [CreditAmount], [SalesInvoiceId]);


GO

CREATE   TRIGGER [Finance].[tr_Audit_Finance_AccountsReceivable]
ON [Finance].[AccountsReceivable]
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
        CASE WHEN i.[ReceivableId] IS NULL THEN 'DELETE'
             WHEN d.[ReceivableId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'AccountsReceivable',
        COALESCE(CONVERT(bigint, i.[ReceivableId]), CONVERT(bigint, d.[ReceivableId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ReceivableId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ReceivableId] = COALESCE(i.[ReceivableId], d.[ReceivableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ReceivableId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ReceivableId] = COALESCE(i.[ReceivableId], d.[ReceivableId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ReceivableId] = d.[ReceivableId];
END;
