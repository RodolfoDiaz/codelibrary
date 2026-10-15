CREATE TABLE [CRM].[CustomerContacts] (
    [CustomerContactId]       INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]               INT            NOT NULL,
    [CustomerId]              INT            NOT NULL,
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
    [BirthDate]               DATE           NULL,
    [IsPrimary]               BIT            CONSTRAINT [DF_CustomerContacts_IsPrimary] DEFAULT ((0)) NOT NULL,
    [IsActive]                BIT            CONSTRAINT [DF_CustomerContacts_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]              ROWVERSION     NOT NULL,
    CONSTRAINT [PK_CustomerContacts] PRIMARY KEY CLUSTERED ([CustomerContactId] ASC),
    CONSTRAINT [FK_CustomerContacts_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_CustomerContacts_Customers] FOREIGN KEY ([CompanyId], [CustomerId]) REFERENCES [CRM].[Customers] ([CompanyId], [CustomerId]),
    CONSTRAINT [FK_CustomerContacts_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [UQ_CustomerContacts_Company] UNIQUE NONCLUSTERED ([CompanyId] ASC, [CustomerContactId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_CustomerContacts_Primary]
    ON [CRM].[CustomerContacts]([CustomerId] ASC) WHERE ([IsPrimary]=(1));


GO

CREATE   TRIGGER [CRM].[tr_Audit_CRM_CustomerContacts]
ON [CRM].[CustomerContacts]
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
        CASE WHEN i.[CustomerContactId] IS NULL THEN 'DELETE'
             WHEN d.[CustomerContactId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'CRM',
        N'CustomerContacts',
        COALESCE(CONVERT(bigint, i.[CustomerContactId]), CONVERT(bigint, d.[CustomerContactId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CustomerContactId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CustomerContactId] = COALESCE(i.[CustomerContactId], d.[CustomerContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CustomerContactId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CustomerContactId] = COALESCE(i.[CustomerContactId], d.[CustomerContactId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CustomerContactId] = d.[CustomerContactId];
END;
