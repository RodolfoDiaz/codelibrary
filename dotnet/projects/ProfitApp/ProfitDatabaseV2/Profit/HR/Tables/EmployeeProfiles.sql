CREATE TABLE [HR].[EmployeeProfiles] (
    [EmployeeProfileId] INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT            NOT NULL,
    [Code]              NVARCHAR (30)  NOT NULL,
    [Name]              NVARCHAR (100) NOT NULL,
    [CommissionRate]    DECIMAL (9, 4) CONSTRAINT [DF_EmployeeProfiles_Commission] DEFAULT ((0)) NOT NULL,
    [IsActive]          BIT            CONSTRAINT [DF_EmployeeProfiles_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_EmployeeProfiles] PRIMARY KEY CLUSTERED ([EmployeeProfileId] ASC),
    CONSTRAINT [CK_EmployeeProfiles_Commission] CHECK ([CommissionRate]>=(0)),
    CONSTRAINT [FK_EmployeeProfiles_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_EmployeeProfiles] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC),
    CONSTRAINT [UQ_EmployeeProfiles_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [EmployeeProfileId] ASC)
);


GO

CREATE   TRIGGER [HR].[tr_Audit_HR_EmployeeProfiles]
ON [HR].[EmployeeProfiles]
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
        CASE WHEN i.[EmployeeProfileId] IS NULL THEN 'DELETE'
             WHEN d.[EmployeeProfileId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'HR',
        N'EmployeeProfiles',
        COALESCE(CONVERT(bigint, i.[EmployeeProfileId]), CONVERT(bigint, d.[EmployeeProfileId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[EmployeeProfileId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[EmployeeProfileId] = COALESCE(i.[EmployeeProfileId], d.[EmployeeProfileId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[EmployeeProfileId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[EmployeeProfileId] = COALESCE(i.[EmployeeProfileId], d.[EmployeeProfileId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[EmployeeProfileId] = d.[EmployeeProfileId];
END;
