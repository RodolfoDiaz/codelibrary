CREATE TABLE [Security].[Users] (
    [UserId]       INT            IDENTITY (1, 1) NOT NULL,
    [UserName]     NVARCHAR (100) NOT NULL,
    [DisplayName]  NVARCHAR (200) NULL,
    [EmailAddress] NVARCHAR (320) NULL,
    [IsActive]     BIT            CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedAt]    DATETIME2 (3)  CONSTRAINT [DF_Users_CreatedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt]    DATETIME2 (3)  NULL,
    [RowVersion]   ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [UQ_Users_UserName] UNIQUE NONCLUSTERED ([UserName] ASC)
);


GO

CREATE   TRIGGER [Security].[tr_Audit_Security_Users]
ON [Security].[Users]
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
        CASE WHEN i.[UserId] IS NULL THEN 'DELETE'
             WHEN d.[UserId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Security', N'Users',
        COALESCE(CONVERT(bigint,i.[UserId]),CONVERT(bigint,d.[UserId])),
        NULL,@UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.[UserId] IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2 WHERE d2.[UserId]=COALESCE(i.[UserId],d.[UserId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.[UserId] IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2 WHERE i2.[UserId]=COALESCE(i.[UserId],d.[UserId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[UserId]=d.[UserId];
END;
