CREATE TABLE [Finance].[JournalEntries] (
    [JournalEntryId]     BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]          INT             NOT NULL,
    [AccountingPeriodId] INT             NOT NULL,
    [EntryNumber]        NVARCHAR (50)   NOT NULL,
    [EntryDate]          DATE            NOT NULL,
    [SourceModule]       NVARCHAR (40)   NOT NULL,
    [SourceType]         NVARCHAR (60)   NULL,
    [SourceId]           BIGINT          NULL,
    [Description]        NVARCHAR (1000) NULL,
    [StatusCode]         NVARCHAR (30)   NOT NULL,
    [CurrencyId]         INT             NOT NULL,
    [ExchangeRate]       DECIMAL (19, 8) CONSTRAINT [DF_JournalEntries_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [RowVersion]         ROWVERSION      NOT NULL,
    CONSTRAINT [PK_JournalEntries] PRIMARY KEY CLUSTERED ([JournalEntryId] ASC),
    CONSTRAINT [CK_JournalEntries_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_JournalEntries_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_JournalEntries_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_JournalEntries_Periods] FOREIGN KEY ([CompanyId], [AccountingPeriodId]) REFERENCES [Core].[AccountingPeriods] ([CompanyId], [AccountingPeriodId]),
    CONSTRAINT [UQ_JournalEntries_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [JournalEntryId] ASC),
    CONSTRAINT [UQ_JournalEntries_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [EntryNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_JournalEntries_Date]
    ON [Finance].[JournalEntries]([CompanyId] ASC, [EntryDate] DESC)
    INCLUDE([EntryNumber], [StatusCode], [SourceModule], [SourceType], [SourceId]);


GO
CREATE NONCLUSTERED INDEX [IX_JournalEntries_Source]
    ON [Finance].[JournalEntries]([CompanyId] ASC, [SourceModule] ASC, [SourceType] ASC, [SourceId] ASC);


GO

CREATE   TRIGGER [Finance].[tr_Audit_Finance_JournalEntries]
ON [Finance].[JournalEntries]
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
        CASE WHEN i.[JournalEntryId] IS NULL THEN 'DELETE'
             WHEN d.[JournalEntryId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'JournalEntries',
        COALESCE(CONVERT(bigint, i.[JournalEntryId]), CONVERT(bigint, d.[JournalEntryId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[JournalEntryId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[JournalEntryId] = COALESCE(i.[JournalEntryId], d.[JournalEntryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[JournalEntryId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[JournalEntryId] = COALESCE(i.[JournalEntryId], d.[JournalEntryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[JournalEntryId] = d.[JournalEntryId];
END;
