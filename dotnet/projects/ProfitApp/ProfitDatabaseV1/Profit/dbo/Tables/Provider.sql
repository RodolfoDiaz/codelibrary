CREATE TABLE [dbo].[Provider] (
    [ProviderId]       INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT           NOT NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [Address]          VARCHAR (200) NULL,
    [City]             VARCHAR (25)  NULL,
    [StateId]          INT           NOT NULL,
    [CountryId]        INT           NOT NULL,
    [PrimaryContactId] INT           NULL,
    [PostalCode]       VARCHAR (25)  NULL,
    [Phone]            VARCHAR (25)  NULL,
    [Fax]              VARCHAR (25)  NULL,
    [Website]          VARCHAR (50)  NULL,
    [EmailAddress]     VARCHAR (50)  NULL,
    [CreditLimit]      MONEY         CONSTRAINT [DF_Provider_CreditLimit] DEFAULT ((0)) NOT NULL,
    [Balance]          MONEY         CONSTRAINT [DF_Provider_Balance] DEFAULT ((0)) NOT NULL,
    [IsActive]         BIT           CONSTRAINT [DF_Provider_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertUser]       INT           NOT NULL,
    [InsertDate]       DATETIME      NOT NULL,
    [LastUpdateUser]   INT           NULL,
    [LastUpdateDate]   DATETIME      NULL,
    [RowInfo]          ROWVERSION    NULL,
    CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED ([ProviderId] ASC),
    CONSTRAINT [CK_Provider_Balance] CHECK ([Balance]>=(0)),
    CONSTRAINT [CK_Provider_CreditLimit] CHECK ([CreditLimit]>=(0)),
    CONSTRAINT [FK_Provider_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_Provider_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId]),
    CONSTRAINT [FK_Provider_ProviderContact] FOREIGN KEY ([PrimaryContactId]) REFERENCES [dbo].[ProviderContact] ([ContactId]),
    CONSTRAINT [FK_Provider_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Provider_Company]
    ON [dbo].[Provider]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Provider_CompanyCountry]
    ON [dbo].[Provider]([CompanyId] ASC, [CountryId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Provider] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Provider] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Provider] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Provider] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Provider] TO [profit_role_datareader]
    AS [dbo];

