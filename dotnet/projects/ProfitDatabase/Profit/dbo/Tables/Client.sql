CREATE TABLE [dbo].[Client] (
    [ClientId]         INT           IDENTITY (1, 1) NOT NULL,
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
    [CreditLimit]      MONEY         CONSTRAINT [DF_Client_CreditLimit] DEFAULT ((0)) NOT NULL,
    [Balance]          MONEY         CONSTRAINT [DF_Client_Balance] DEFAULT ((0)) NOT NULL,
    [IsActive]         BIT           CONSTRAINT [DF_Client_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertUser]       INT           NOT NULL,
    [InsertDate]       DATETIME      NOT NULL,
    [LastUpdateUser]   INT           NULL,
    [LastUpdateDate]   DATETIME      NULL,
    [RowInfo]          ROWVERSION    NULL,
    CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED ([ClientId] ASC),
    CONSTRAINT [CK_Client_Balance] CHECK ([Balance]>=(0)),
    CONSTRAINT [CK_Client_CreditLimit] CHECK ([CreditLimit]>=(0)),
    CONSTRAINT [FK_Client_ClientContact] FOREIGN KEY ([PrimaryContactId]) REFERENCES [dbo].[ClientContact] ([ContactId]),
    CONSTRAINT [FK_Client_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_Client_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId]),
    CONSTRAINT [FK_Client_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Client_Company]
    ON [dbo].[Client]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Client_CompanyCountry]
    ON [dbo].[Client]([CompanyId] ASC, [CountryId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Client] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Client] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Client] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Client] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Client] TO [profit_role_datareader]
    AS [dbo];

