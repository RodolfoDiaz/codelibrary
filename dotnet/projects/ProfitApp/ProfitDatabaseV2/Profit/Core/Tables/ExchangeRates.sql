CREATE TABLE [Core].[ExchangeRates] (
    [ExchangeRateId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT             NOT NULL,
    [CurrencyId]     INT             NOT NULL,
    [EffectiveDate]  DATE            NOT NULL,
    [Rate]           DECIMAL (19, 8) NOT NULL,
    [Source]         NVARCHAR (100)  NULL,
    [RowVersion]     ROWVERSION      NOT NULL,
    CONSTRAINT [PK_ExchangeRates] PRIMARY KEY CLUSTERED ([ExchangeRateId] ASC),
    CONSTRAINT [CK_ExchangeRates_Rate] CHECK ([Rate]>(0)),
    CONSTRAINT [FK_ExchangeRates_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_ExchangeRates_Currencies] FOREIGN KEY ([CurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [UQ_ExchangeRates] UNIQUE NONCLUSTERED ([CompanyId] ASC, [CurrencyId] ASC, [EffectiveDate] ASC)
);


GO

CREATE   TRIGGER [Core].[tr_Audit_Core_ExchangeRates]
ON [Core].[ExchangeRates]
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
        CASE WHEN i.[ExchangeRateId] IS NULL THEN 'DELETE'
             WHEN d.[ExchangeRateId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'ExchangeRates',
        COALESCE(CONVERT(bigint, i.[ExchangeRateId]), CONVERT(bigint, d.[ExchangeRateId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[ExchangeRateId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[ExchangeRateId] = COALESCE(i.[ExchangeRateId], d.[ExchangeRateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[ExchangeRateId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[ExchangeRateId] = COALESCE(i.[ExchangeRateId], d.[ExchangeRateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[ExchangeRateId] = d.[ExchangeRateId];
END;
