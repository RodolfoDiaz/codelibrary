CREATE TABLE [HR].[Employees] (
    [EmployeeId]              INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT             NOT NULL,
    [EmployeeNumber]          NVARCHAR (50)   NOT NULL,
    [DepartmentId]            INT             NOT NULL,
    [EmployeeProfileId]       INT             NULL,
    [FirstName]               NVARCHAR (100)  NOT NULL,
    [LastName]                NVARCHAR (100)  NOT NULL,
    [JobTitle]                NVARCHAR (100)  NULL,
    [TaxIdentificationNumber] NVARCHAR (50)   NULL,
    [Address]                 NVARCHAR (300)  NULL,
    [City]                    NVARCHAR (100)  NULL,
    [StateId]                 INT             NULL,
    [CountryId]               INT             NULL,
    [Gender]                  NVARCHAR (20)   NULL,
    [PostalCode]              NVARCHAR (25)   NULL,
    [Phone]                   NVARCHAR (40)   NULL,
    [MobilePhone]             NVARCHAR (40)   NULL,
    [EmailAddress]            NVARCHAR (320)  NULL,
    [BirthDate]               DATE            NULL,
    [HireDate]                DATE            NULL,
    [TerminationDate]         DATE            NULL,
    [MaritalStatus]           NVARCHAR (30)   NULL,
    [Salary]                  DECIMAL (19, 4) NULL,
    [Deductions]              DECIMAL (19, 4) NULL,
    [EmergencyContactName]    NVARCHAR (200)  NULL,
    [EmergencyContactPhone]   NVARCHAR (40)   NULL,
    [IsActive]                BIT             CONSTRAINT [DF_Employees_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]              ROWVERSION      NOT NULL,
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeId] ASC),
    CONSTRAINT [CK_Employees_Deductions] CHECK ([Deductions] IS NULL OR [Deductions]>=(0)),
    CONSTRAINT [CK_Employees_Salary] CHECK ([Salary] IS NULL OR [Salary]>=(0)),
    CONSTRAINT [FK_Employees_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_Employees_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_Employees_Departments] FOREIGN KEY ([CompanyId], [DepartmentId]) REFERENCES [HR].[Departments] ([CompanyId], [DepartmentId]),
    CONSTRAINT [FK_Employees_Profiles] FOREIGN KEY ([CompanyId], [EmployeeProfileId]) REFERENCES [HR].[EmployeeProfiles] ([CompanyId], [EmployeeProfileId]),
    CONSTRAINT [FK_Employees_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [UQ_Employees_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [EmployeeId] ASC),
    CONSTRAINT [UQ_Employees_Company_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [EmployeeNumber] ASC)
);


GO

CREATE   TRIGGER [HR].[tr_Audit_HR_Employees]
ON [HR].[Employees]
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
        CASE WHEN i.[EmployeeId] IS NULL THEN 'DELETE'
             WHEN d.[EmployeeId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'HR',
        N'Employees',
        COALESCE(CONVERT(bigint, i.[EmployeeId]), CONVERT(bigint, d.[EmployeeId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[EmployeeId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[EmployeeId] = COALESCE(i.[EmployeeId], d.[EmployeeId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[EmployeeId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[EmployeeId] = COALESCE(i.[EmployeeId], d.[EmployeeId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[EmployeeId] = d.[EmployeeId];
END;
