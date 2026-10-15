CREATE TABLE [CRM].[Customers] (
    [CustomerId]              INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT             NOT NULL,
    [CustomerNumber]          NVARCHAR (50)   NOT NULL,
    [LegalName]               NVARCHAR (200)  NOT NULL,
    [TaxIdentificationNumber] NVARCHAR (50)   NULL,
    [Address]                 NVARCHAR (300)  NULL,
    [City]                    NVARCHAR (100)  NULL,
    [StateId]                 INT             NULL,
    [CountryId]               INT             NOT NULL,
    [PostalCode]              NVARCHAR (25)   NULL,
    [Phone]                   NVARCHAR (40)   NULL,
    [MobilePhone]             NVARCHAR (40)   NULL,
    [Website]                 NVARCHAR (500)  NULL,
    [EmailAddress]            NVARCHAR (320)  NULL,
    [CreditLimit]             DECIMAL (19, 4) CONSTRAINT [DF_Customers_CreditLimit] DEFAULT ((0)) NOT NULL,
    [IsActive]                BIT             CONSTRAINT [DF_Customers_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]              ROWVERSION      NOT NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerId] ASC),
    CONSTRAINT [CK_Customers_CreditLimit] CHECK ([CreditLimit]>=(0)),
    CONSTRAINT [FK_Customers_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_Customers_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_Customers_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [UQ_Customers_Company_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [CustomerId] ASC),
    CONSTRAINT [UQ_Customers_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [CustomerNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Customers_Company_Name]
    ON [CRM].[Customers]([CompanyId] ASC, [LegalName] ASC)
    INCLUDE([CustomerNumber], [IsActive]);


GO
CREATE NONCLUSTERED INDEX [IX_Customers_Company_TaxId]
    ON [CRM].[Customers]([CompanyId] ASC, [TaxIdentificationNumber] ASC) WHERE ([TaxIdentificationNumber] IS NOT NULL);


GO

CREATE   TRIGGER [CRM].[tr_Audit_CRM_Customers]
ON [CRM].[Customers]
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
        CASE WHEN i.[CustomerId] IS NULL THEN 'DELETE'
             WHEN d.[CustomerId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'CRM',
        N'Customers',
        COALESCE(CONVERT(bigint, i.[CustomerId]), CONVERT(bigint, d.[CustomerId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CustomerId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CustomerId] = COALESCE(i.[CustomerId], d.[CustomerId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CustomerId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CustomerId] = COALESCE(i.[CustomerId], d.[CustomerId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CustomerId] = d.[CustomerId];
END;
