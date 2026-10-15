CREATE TABLE [Security].[UserCompanies] (
    [UserId]    INT NOT NULL,
    [CompanyId] INT NOT NULL,
    [IsDefault] BIT CONSTRAINT [DF_UserCompanies_IsDefault] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_UserCompanies] PRIMARY KEY CLUSTERED ([UserId] ASC, [CompanyId] ASC),
    CONSTRAINT [FK_UserCompanies_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_UserCompanies_Users] FOREIGN KEY ([UserId]) REFERENCES [Security].[Users] ([UserId])
);


GO

CREATE   TRIGGER [Security].[tr_Audit_Security_UserCompanies]
ON [Security].[UserCompanies]
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
        CASE WHEN i.UserId IS NULL THEN 'DELETE'
             WHEN d.UserId IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Security', N'UserCompanies',
        CONVERT(bigint, COALESCE(i.UserId,d.UserId)),
        COALESCE(i.CompanyId,d.CompanyId,@SessionCompanyId),
        @UserId,@ApplicationUser,@ApplicationName,HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,@CorrelationId,
        CASE WHEN d.UserId IS NOT NULL THEN
             (SELECT d2.* FROM deleted d2
              WHERE d2.UserId=COALESCE(i.UserId,d.UserId)
                AND d2.CompanyId=COALESCE(i.CompanyId,d.CompanyId)
              FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        CASE WHEN i.UserId IS NOT NULL THEN
             (SELECT i2.* FROM inserted i2
              WHERE i2.UserId=COALESCE(i.UserId,d.UserId)
                AND i2.CompanyId=COALESCE(i.CompanyId,d.CompanyId)
              FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d
      ON i.UserId=d.UserId AND i.CompanyId=d.CompanyId;
END;
