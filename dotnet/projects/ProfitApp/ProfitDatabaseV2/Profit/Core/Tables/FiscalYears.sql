CREATE TABLE [Core].[FiscalYears] (
    [FiscalYearId] INT        IDENTITY (1, 1) NOT NULL,
    [CompanyId]    INT        NOT NULL,
    [FiscalYear]   SMALLINT   NOT NULL,
    [StartDate]    DATE       NOT NULL,
    [EndDate]      DATE       NOT NULL,
    [IsClosed]     BIT        CONSTRAINT [DF_FiscalYears_IsClosed] DEFAULT ((0)) NOT NULL,
    [RowVersion]   ROWVERSION NOT NULL,
    CONSTRAINT [PK_FiscalYears] PRIMARY KEY CLUSTERED ([FiscalYearId] ASC),
    CONSTRAINT [CK_FiscalYears_Dates] CHECK ([EndDate]>=[StartDate]),
    CONSTRAINT [FK_FiscalYears_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_FiscalYears] UNIQUE NONCLUSTERED ([CompanyId] ASC, [FiscalYear] ASC)
);


GO

CREATE   TRIGGER [Core].[tr_Audit_Core_FiscalYears]
ON [Core].[FiscalYears]
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
        CASE WHEN i.[FiscalYearId] IS NULL THEN 'DELETE'
             WHEN d.[FiscalYearId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'FiscalYears',
        COALESCE(CONVERT(bigint, i.[FiscalYearId]), CONVERT(bigint, d.[FiscalYearId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[FiscalYearId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[FiscalYearId] = COALESCE(i.[FiscalYearId], d.[FiscalYearId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[FiscalYearId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[FiscalYearId] = COALESCE(i.[FiscalYearId], d.[FiscalYearId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[FiscalYearId] = d.[FiscalYearId];
END;
