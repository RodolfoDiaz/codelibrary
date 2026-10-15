CREATE TABLE [Finance].[ChartOfAccounts] (
    [AccountId]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT            NOT NULL,
    [AccountCode]      NVARCHAR (50)  NOT NULL,
    [AccountName]      NVARCHAR (200) NOT NULL,
    [AccountType]      NVARCHAR (30)  NOT NULL,
    [ParentAccountId]  BIGINT         NULL,
    [NormalBalance]    CHAR (1)       NOT NULL,
    [IsControlAccount] BIT            CONSTRAINT [DF_ChartOfAccounts_Control] DEFAULT ((0)) NOT NULL,
    [IsActive]         BIT            CONSTRAINT [DF_ChartOfAccounts_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]       ROWVERSION     NOT NULL,
    CONSTRAINT [PK_ChartOfAccounts] PRIMARY KEY CLUSTERED ([AccountId] ASC),
    CONSTRAINT [CK_ChartOfAccounts_NormalBalance] CHECK ([NormalBalance]='C' OR [NormalBalance]='D'),
    CONSTRAINT [CK_ChartOfAccounts_Type] CHECK ([AccountType]=N'EXPENSE' OR [AccountType]=N'REVENUE' OR [AccountType]=N'EQUITY' OR [AccountType]=N'LIABILITY' OR [AccountType]=N'ASSET'),
    CONSTRAINT [FK_ChartOfAccounts_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_ChartOfAccounts_Parent] FOREIGN KEY ([ParentAccountId]) REFERENCES [Finance].[ChartOfAccounts] ([AccountId]),
    CONSTRAINT [UQ_ChartOfAccounts_Code] UNIQUE NONCLUSTERED ([CompanyId] ASC, [AccountCode] ASC),
    CONSTRAINT [UQ_ChartOfAccounts_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [AccountId] ASC)
);


GO

CREATE   TRIGGER [Finance].[tr_Audit_Finance_ChartOfAccounts]
ON [Finance].[ChartOfAccounts]
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
        CASE WHEN i.[AccountId] IS NULL THEN 'DELETE'
             WHEN d.[AccountId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Finance',
        N'ChartOfAccounts',
        COALESCE(CONVERT(bigint, i.[AccountId]), CONVERT(bigint, d.[AccountId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[AccountId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[AccountId] = COALESCE(i.[AccountId], d.[AccountId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[AccountId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[AccountId] = COALESCE(i.[AccountId], d.[AccountId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[AccountId] = d.[AccountId];
END;
