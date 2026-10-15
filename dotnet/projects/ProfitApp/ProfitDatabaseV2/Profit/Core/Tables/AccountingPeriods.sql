CREATE TABLE [Core].[AccountingPeriods] (
    [AccountingPeriodId] INT        IDENTITY (1, 1) NOT NULL,
    [CompanyId]          INT        NOT NULL,
    [FiscalYearId]       INT        NOT NULL,
    [PeriodNumber]       TINYINT    NOT NULL,
    [StartDate]          DATE       NOT NULL,
    [EndDate]            DATE       NOT NULL,
    [IsClosed]           BIT        CONSTRAINT [DF_AccountingPeriods_IsClosed] DEFAULT ((0)) NOT NULL,
    [RowVersion]         ROWVERSION NOT NULL,
    CONSTRAINT [PK_AccountingPeriods] PRIMARY KEY CLUSTERED ([AccountingPeriodId] ASC),
    CONSTRAINT [CK_AccountingPeriods_Dates] CHECK ([EndDate]>=[StartDate]),
    CONSTRAINT [CK_AccountingPeriods_Number] CHECK ([PeriodNumber]>=(1) AND [PeriodNumber]<=(13)),
    CONSTRAINT [FK_AccountingPeriods_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_AccountingPeriods_FiscalYears] FOREIGN KEY ([FiscalYearId]) REFERENCES [Core].[FiscalYears] ([FiscalYearId]),
    CONSTRAINT [UQ_AccountingPeriods] UNIQUE NONCLUSTERED ([CompanyId] ASC, [FiscalYearId] ASC, [PeriodNumber] ASC),
    CONSTRAINT [UQ_AccountingPeriods_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [AccountingPeriodId] ASC)
);


GO

CREATE   TRIGGER [Core].[tr_Audit_Core_AccountingPeriods]
ON [Core].[AccountingPeriods]
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
        CASE WHEN i.[AccountingPeriodId] IS NULL THEN 'DELETE'
             WHEN d.[AccountingPeriodId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'AccountingPeriods',
        COALESCE(CONVERT(bigint, i.[AccountingPeriodId]), CONVERT(bigint, d.[AccountingPeriodId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[AccountingPeriodId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[AccountingPeriodId] = COALESCE(i.[AccountingPeriodId], d.[AccountingPeriodId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[AccountingPeriodId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[AccountingPeriodId] = COALESCE(i.[AccountingPeriodId], d.[AccountingPeriodId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[AccountingPeriodId] = d.[AccountingPeriodId];
END;
