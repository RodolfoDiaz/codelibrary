CREATE TABLE [Finance].[JournalEntryLines] (
    [JournalEntryLineId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]          INT             NOT NULL,
    [JournalEntryId]     BIGINT          NOT NULL,
    [LineNumber]         INT             NOT NULL,
    [AccountId]          BIGINT          NOT NULL,
    [Description]        NVARCHAR (500)  NULL,
    [DebitAmount]        DECIMAL (19, 4) CONSTRAINT [DF_JournalEntryLines_Debit] DEFAULT ((0)) NOT NULL,
    [CreditAmount]       DECIMAL (19, 4) CONSTRAINT [DF_JournalEntryLines_Credit] DEFAULT ((0)) NOT NULL,
    [TaxCodeId]          INT             NULL,
    [CustomerId]         INT             NULL,
    [VendorId]           INT             NULL,
    [EmployeeId]         INT             NULL,
    [RowVersion]         ROWVERSION      NOT NULL,
    CONSTRAINT [PK_JournalEntryLines] PRIMARY KEY CLUSTERED ([JournalEntryLineId] ASC),
    CONSTRAINT [CK_JournalEntryLines_Amounts] CHECK ([DebitAmount]>=(0) AND [CreditAmount]>=(0) AND ([DebitAmount]>(0) AND [CreditAmount]=(0) OR [CreditAmount]>(0) AND [DebitAmount]=(0))),
    CONSTRAINT [FK_JournalEntryLines_Accounts] FOREIGN KEY ([CompanyId], [AccountId]) REFERENCES [Finance].[ChartOfAccounts] ([CompanyId], [AccountId]),
    CONSTRAINT [FK_JournalEntryLines_Customers] FOREIGN KEY ([CompanyId], [CustomerId]) REFERENCES [CRM].[Customers] ([CompanyId], [CustomerId]),
    CONSTRAINT [FK_JournalEntryLines_Employees] FOREIGN KEY ([CompanyId], [EmployeeId]) REFERENCES [HR].[Employees] ([CompanyId], [EmployeeId]),
    CONSTRAINT [FK_JournalEntryLines_Entries] FOREIGN KEY ([CompanyId], [JournalEntryId]) REFERENCES [Finance].[JournalEntries] ([CompanyId], [JournalEntryId]),
    CONSTRAINT [FK_JournalEntryLines_TaxCodes] FOREIGN KEY ([CompanyId], [TaxCodeId]) REFERENCES [Reference].[TaxCodes] ([CompanyId], [TaxCodeId]),
    CONSTRAINT [FK_JournalEntryLines_Vendors] FOREIGN KEY ([CompanyId], [VendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId]),
    CONSTRAINT [UQ_JournalEntryLines_Line] UNIQUE NONCLUSTERED ([JournalEntryId] ASC, [LineNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_JournalEntryLines_Account]
    ON [Finance].[JournalEntryLines]([CompanyId] ASC, [AccountId] ASC, [JournalEntryId] ASC)
    INCLUDE([DebitAmount], [CreditAmount]);


GO

CREATE   TRIGGER [Finance].[tr_Audit_Finance_JournalEntryLines]
ON [Finance].[JournalEntryLines]
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
        CASE WHEN i.[JournalEntryLineId] IS NULL THEN 'DELETE'
             WHEN d.[JournalEntryLineId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'JournalEntryLines',
        COALESCE(CONVERT(bigint, i.[JournalEntryLineId]), CONVERT(bigint, d.[JournalEntryLineId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[JournalEntryLineId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[JournalEntryLineId] = COALESCE(i.[JournalEntryLineId], d.[JournalEntryLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[JournalEntryLineId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[JournalEntryLineId] = COALESCE(i.[JournalEntryLineId], d.[JournalEntryLineId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[JournalEntryLineId] = d.[JournalEntryLineId];
END;
