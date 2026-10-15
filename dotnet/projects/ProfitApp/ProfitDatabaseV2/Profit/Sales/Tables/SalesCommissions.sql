CREATE TABLE [Sales].[SalesCommissions] (
    [SalesCommissionId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT             NOT NULL,
    [EmployeeId]        INT             NOT NULL,
    [SalesInvoiceId]    BIGINT          NOT NULL,
    [CommissionDate]    DATE            NOT NULL,
    [Amount]            DECIMAL (19, 4) NOT NULL,
    [ExchangeRate]      DECIMAL (19, 8) CONSTRAINT [DF_SalesCommissions_ExchangeRate] DEFAULT ((1)) NOT NULL,
    [IsPaid]            BIT             CONSTRAINT [DF_SalesCommissions_IsPaid] DEFAULT ((0)) NOT NULL,
    [RowVersion]        ROWVERSION      NOT NULL,
    CONSTRAINT [PK_SalesCommissions] PRIMARY KEY CLUSTERED ([SalesCommissionId] ASC),
    CONSTRAINT [CK_SalesCommissions_Amount] CHECK ([Amount]>=(0)),
    CONSTRAINT [CK_SalesCommissions_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_SalesCommissions_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_SalesCommissions_Employees] FOREIGN KEY ([CompanyId], [EmployeeId]) REFERENCES [HR].[Employees] ([CompanyId], [EmployeeId]),
    CONSTRAINT [FK_SalesCommissions_Invoices] FOREIGN KEY ([CompanyId], [SalesInvoiceId]) REFERENCES [Sales].[SalesInvoices] ([CompanyId], [SalesInvoiceId])
);


GO

CREATE   TRIGGER [Sales].[tr_Audit_Sales_SalesCommissions]
ON [Sales].[SalesCommissions]
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
        CASE WHEN i.[SalesCommissionId] IS NULL THEN 'DELETE'
             WHEN d.[SalesCommissionId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Sales',
        N'SalesCommissions',
        COALESCE(CONVERT(bigint, i.[SalesCommissionId]), CONVERT(bigint, d.[SalesCommissionId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[SalesCommissionId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[SalesCommissionId] = COALESCE(i.[SalesCommissionId], d.[SalesCommissionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[SalesCommissionId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[SalesCommissionId] = COALESCE(i.[SalesCommissionId], d.[SalesCommissionId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[SalesCommissionId] = d.[SalesCommissionId];
END;
