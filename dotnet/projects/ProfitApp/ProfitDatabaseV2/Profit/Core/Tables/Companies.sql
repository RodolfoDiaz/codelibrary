CREATE TABLE [Core].[Companies] (
    [CompanyId]               INT            IDENTITY (1, 1) NOT NULL,
    [LegalName]               NVARCHAR (200) NOT NULL,
    [TradeName]               NVARCHAR (200) NULL,
    [TaxIdentificationNumber] NVARCHAR (50)  NULL,
    [Address]                 NVARCHAR (300) NULL,
    [City]                    NVARCHAR (100) NULL,
    [StateId]                 INT            NULL,
    [CountryId]               INT            NOT NULL,
    [PostalCode]              NVARCHAR (25)  NULL,
    [Phone]                   NVARCHAR (40)  NULL,
    [Website]                 NVARCHAR (500) NULL,
    [EmailAddress]            NVARCHAR (320) NULL,
    [BaseCurrencyId]          INT            NOT NULL,
    [CultureCode]             NVARCHAR (20)  CONSTRAINT [DF_Companies_CultureCode] DEFAULT (N'en-US') NOT NULL,
    [TaxRate]                 DECIMAL (9, 4) NULL,
    [DefaultDiscountRate]     DECIMAL (9, 4) NULL,
    [IsActive]                BIT            CONSTRAINT [DF_Companies_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]              ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED ([CompanyId] ASC),
    CONSTRAINT [CK_Companies_DiscountRate] CHECK ([DefaultDiscountRate] IS NULL OR [DefaultDiscountRate]>=(0)),
    CONSTRAINT [CK_Companies_TaxRate] CHECK ([TaxRate] IS NULL OR [TaxRate]>=(0)),
    CONSTRAINT [FK_Companies_Countries] FOREIGN KEY ([CountryId]) REFERENCES [Core].[Countries] ([CountryId]),
    CONSTRAINT [FK_Companies_Currencies] FOREIGN KEY ([BaseCurrencyId]) REFERENCES [Core].[Currencies] ([CurrencyId]),
    CONSTRAINT [FK_Companies_States] FOREIGN KEY ([StateId]) REFERENCES [Core].[States] ([StateId]),
    CONSTRAINT [UQ_Companies_TaxId] UNIQUE NONCLUSTERED ([TaxIdentificationNumber] ASC)
);


GO

/* ---------------------------------------------------------------------------
   Centralized AuditLog triggers
   One audit row is written for each affected row. OldValues/NewValues contain
   the complete row image as JSON. ChangedColumns is reserved for a future
   column-diff optimization; full row images are authoritative.
--------------------------------------------------------------------------- */

CREATE   TRIGGER [Core].[tr_Audit_Core_Companies]
ON [Core].[Companies]
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
        CASE WHEN i.[CompanyId] IS NULL THEN 'DELETE'
             WHEN d.[CompanyId] IS NULL THEN 'INSERT'
             ELSE 'UPDATE' END,
        N'Core',
        N'Companies',
        COALESCE(CONVERT(bigint, i.[CompanyId]), CONVERT(bigint, d.[CompanyId])),
        COALESCE(TRY_CONVERT(int, i.CompanyId), TRY_CONVERT(int, d.CompanyId), @SessionCompanyId),
        @UserId,
        @ApplicationUser,
        @ApplicationName,
        HOST_NAME(),
        CONVERT(varchar(48), CONNECTIONPROPERTY('client_net_address')),
        @@SPID,
        @CorrelationId,
        CASE WHEN d.[CompanyId] IS NOT NULL
             THEN (SELECT d2.* FROM deleted d2 WHERE d2.[CompanyId] = COALESCE(i.[CompanyId], d.[CompanyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        CASE WHEN i.[CompanyId] IS NOT NULL
             THEN (SELECT i2.* FROM inserted i2 WHERE i2.[CompanyId] = COALESCE(i.[CompanyId], d.[CompanyId]) FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        END,
        NULL
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.[CompanyId] = d.[CompanyId];
END;
