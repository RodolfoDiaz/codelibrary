CREATE TABLE [Procurement].[VendorContacts] (
    [VendorContactId]         INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT            NOT NULL,
    [VendorId]                INT            NOT NULL,
    [FirstName]               NVARCHAR (100) NOT NULL,
    [LastName]                NVARCHAR (100) NOT NULL,
    [JobTitle]                NVARCHAR (100) NULL,
    [TaxIdentificationNumber] NVARCHAR (50)  NULL,
    [Address]                 NVARCHAR (300) NULL,
    [City]                    NVARCHAR (100) NULL,
    [StateId]                 INT            NULL,
    [CountryId]               INT            NULL,
    [Phone]                   NVARCHAR (40)  NULL,
    [MobilePhone]             NVARCHAR (40)  NULL,
    [EmailAddress]            NVARCHAR (320) NULL,
    [IsPrimary]               BIT            CONSTRAINT [DF_VendorContacts_IsPrimary] DEFAULT ((0)) NOT NULL,
    [IsActive]                BIT            CONSTRAINT [DF_VendorContacts_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]              ROWVERSION     NOT NULL,
    CONSTRAINT [PK_VendorContacts] PRIMARY KEY CLUSTERED ([VendorContactId] ASC),
    CONSTRAINT [FK_VendorContacts_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_VendorContacts_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [FK_VendorContacts_Vendors] FOREIGN KEY ([CompanyId], [VendorId]) REFERENCES [Procurement].[Vendors] ([CompanyId], [VendorId]),
    CONSTRAINT [UQ_VendorContacts_Company] UNIQUE NONCLUSTERED ([CompanyId] ASC, [VendorContactId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_VendorContacts_Primary]
    ON [Procurement].[VendorContacts]([VendorId] ASC) WHERE ([IsPrimary]=(1));


GO

CREATE   TRIGGER [Procurement].[tr_Audit_Procurement_VendorContacts]
ON [Procurement].[VendorContacts]
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
        CASE WHEN i.[VendorContactId] IS NULL THEN 'DELETE'
             WHEN d.[VendorContactId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Procurement',
        N'VendorContacts',
        COALESCE(CONVERT(bigint, i.[VendorContactId]), CONVERT(bigint, d.[VendorContactId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[VendorContactId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[VendorContactId] = COALESCE(i.[VendorContactId], d.[VendorContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[VendorContactId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[VendorContactId] = COALESCE(i.[VendorContactId], d.[VendorContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[VendorContactId] = d.[VendorContactId];
END;
