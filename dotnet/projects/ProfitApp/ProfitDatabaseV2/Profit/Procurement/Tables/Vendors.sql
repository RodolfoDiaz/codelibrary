CREATE TABLE [Procurement].[Vendors] (
    [VendorId]                INT             IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT             NOT NULL,
    [VendorNumber]            NVARCHAR (50)   NOT NULL,
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
    [CreditLimit]             DECIMAL (19, 4) CONSTRAINT [DF_Vendors_CreditLimit] DEFAULT ((0)) NOT NULL,
    [IsActive]                BIT             CONSTRAINT [DF_Vendors_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]              ROWVERSION      NOT NULL,
    CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED ([VendorId] ASC),
    CONSTRAINT [CK_Vendors_CreditLimit] CHECK ([CreditLimit]>=(0)),
    CONSTRAINT [FK_Vendors_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [FK_Vendors_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_Vendors_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [UQ_Vendors_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorId] ASC),
    CONSTRAINT [UQ_Vendors_Company_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorId] ASC),
    CONSTRAINT [UQ_Vendors_Number] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorNumber] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Vendors_Company_Name]
    ON [Procurement].[Vendors]([CompanyId] ASC, [LegalName] ASC)
    INCLUDE([VendorNumber], [IsActive]);


GO
CREATE NONCLUSTERED INDEX [IX_Vendors_Company_TaxId]
    ON [Procurement].[Vendors]([CompanyId] ASC, [TaxIdentificationNumber] ASC) WHERE ([TaxIdentificationNumber] IS NOT NULL);


GO

CREATE   TRIGGER [Procurement].[tr_Audit_Procurement_Vendors]
ON [Procurement].[Vendors]
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
        CASE WHEN i.[VendorId] IS NULL THEN 'DELETE'
             WHEN d.[VendorId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'Vendors',
        COALESCE(CONVERT(bigint, i.[VendorId]), CONVERT(bigint, d.[VendorId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorId] = COALESCE(i.[VendorId], d.[VendorId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorId] = COALESCE(i.[VendorId], d.[VendorId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorId] = d.[VendorId];
END;
