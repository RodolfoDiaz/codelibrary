CREATE TABLE [Core].[Countries] (
    [CountryId]  INT            IDENTITY (1, 1) NOT NULL,
    [IsoCode]    CHAR (2)       NOT NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [IsActive]   BIT            CONSTRAINT [DF_Countries_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion] ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED ([CountryId] ASC),
    CONSTRAINT [UQ_Countries_IsoCode] UNIQUE NONCLUSTERED ([IsoCode] ASC),
    CONSTRAINT [UQ_Countries_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

CREATE   TRIGGER [Core].[tr_Audit_Core_Countries]
ON [Core].[Countries]
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
        CASE WHEN i.[CountryId] IS NULL THEN 'DELETE'
             WHEN d.[CountryId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core', N'Countries',
        COALESCE(CONVERT(bigint,i.[CountryId]),CONVERT(bigint,d.[CountryId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[CountryId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[CountryId]=COALESCE(i.[CountryId],d.[CountryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[CountryId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[CountryId]=COALESCE(i.[CountryId],d.[CountryId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CountryId]=d.[CountryId];
END;
