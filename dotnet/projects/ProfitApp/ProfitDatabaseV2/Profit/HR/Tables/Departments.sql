CREATE TABLE [HR].[Departments] (
    [DepartmentId] INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]    INT            NOT NULL,
    [Code]         NVARCHAR (30)  NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [Location]     NVARCHAR (300) NULL,
    [IsActive]     BIT            CONSTRAINT [DF_Departments_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]   ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED ([DepartmentId] ASC),
    CONSTRAINT [FK_Departments_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_Departments] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC),
    CONSTRAINT [UQ_Departments_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [DepartmentId] ASC)
);


GO

CREATE   TRIGGER [HR].[tr_Audit_HR_Departments]
ON [HR].[Departments]
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
        CASE WHEN i.[DepartmentId] IS NULL THEN 'DELETE'
             WHEN d.[DepartmentId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'HR',
        N'Departments',
        COALESCE(CONVERT(bigint, i.[DepartmentId]), CONVERT(bigint, d.[DepartmentId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[DepartmentId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[DepartmentId] = COALESCE(i.[DepartmentId], d.[DepartmentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[DepartmentId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[DepartmentId] = COALESCE(i.[DepartmentId], d.[DepartmentId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[DepartmentId] = d.[DepartmentId];
END;
