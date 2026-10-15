CREATE TABLE [Core].[Currencies] (
    [CurrencyId]    INT            IDENTITY (1, 1) NOT NULL,
    [IsoCode]       CHAR (3)       NOT NULL,
    [Name]          NVARCHAR (100) NOT NULL,
    [Symbol]        NVARCHAR (10)  NULL,
    [DecimalPlaces] TINYINT        CONSTRAINT [DF_Currencies_DecimalPlaces] DEFAULT ((2)) NOT NULL,
    [IsActive]      BIT            CONSTRAINT [DF_Currencies_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]    ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED ([CurrencyId] ASC),
    CONSTRAINT [CK_Currencies_DecimalPlaces] CHECK ([DecimalPlaces]>=(0) AND [DecimalPlaces]<=(6)),
    CONSTRAINT [UQ_Currencies_IsoCode] UNIQUE NONCLUSTERED ([IsoCode] ASC)
);


GO

CREATE   TRIGGER [Core].[tr_Audit_Core_Currencies]
ON [Core].[Currencies]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId int = TRY_CONVERT(int, SESSION_CONTEXT(N'UserId'));
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
        CASE WHEN i.[CurrencyId] IS NULL THEN 'DELETE'
             WHEN d.[CurrencyId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core', N'Currencies',
        COALESCE(CONVERT(bigint,i.[CurrencyId]),CONVERT(bigint,d.[CurrencyId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[CurrencyId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[CurrencyId]=COALESCE(i.[CurrencyId],d.[CurrencyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[CurrencyId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[CurrencyId]=COALESCE(i.[CurrencyId],d.[CurrencyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CurrencyId]=d.[CurrencyId];
END;
