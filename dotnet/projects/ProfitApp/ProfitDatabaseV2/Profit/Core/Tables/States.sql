CREATE TABLE [Core].[States] (
    [StateId]    INT            IDENTITY (1, 1) NOT NULL,
    [CountryId]  INT            NOT NULL,
    [Code]       NVARCHAR (20)  NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [IsActive]   BIT            CONSTRAINT [DF_States_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion] ROWVERSION     NOT NULL,
    CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED ([StateId] ASC),
    CONSTRAINT [FK_States_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [UQ_States_Country_Name] UNIQUE NONCLUSTERED ([CountryId] ASC, [Name] ASC)
);


GO

CREATE   TRIGGER [Core].[tr_Audit_Core_States]
ON [Core].[States]
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
        CASE WHEN i.[StateId] IS NULL THEN 'DELETE'
             WHEN d.[StateId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core', N'States',
        COALESCE(CONVERT(bigint,i.[StateId]),CONVERT(bigint,d.[StateId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[StateId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[StateId]=COALESCE(i.[StateId],d.[StateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[StateId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[StateId]=COALESCE(i.[StateId],d.[StateId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[StateId]=d.[StateId];
END;
