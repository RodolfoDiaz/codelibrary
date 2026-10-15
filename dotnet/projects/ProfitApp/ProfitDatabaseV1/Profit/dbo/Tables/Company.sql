CREATE TABLE [dbo].[Company] (
    [CompanyId]        INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [Address]          VARCHAR (200) NULL,
    [City]             VARCHAR (25)  NULL,
    [StateId]          INT           NOT NULL,
    [CountryId]        INT           NOT NULL,
    [PostalCode]       VARCHAR (25)  NULL,
    [Phone]            VARCHAR (25)  NULL,
    [Fax]              VARCHAR (25)  NULL,
    [Website]          VARCHAR (50)  NULL,
    [EmailAddress]     VARCHAR (50)  NULL,
    [Tax]              MONEY         CONSTRAINT [DF_Company_Tax] DEFAULT ((0)) NULL,
    [Discount]         MONEY         CONSTRAINT [DF_Company_Discount] DEFAULT ((0)) NULL,
    [MultipleCurrency] BIT           CONSTRAINT [DF_Company_MultipleCurrency] DEFAULT ((1)) NOT NULL,
    [Culture]          VARCHAR (5)   NOT NULL,
    [LocalSign]        VARCHAR (1)   NOT NULL,
    [ForeignSign]      VARCHAR (1)   NULL,
    [LocalName]        VARCHAR (25)  NOT NULL,
    [ForeignName]      VARCHAR (25)  NULL,
    [InsertUser]       INT           NOT NULL,
    [InsertDate]       DATETIME      NOT NULL,
    [LastUpdateUser]   INT           NULL,
    [LastUpdateDate]   DATETIME      NULL,
    [RowInfo]          ROWVERSION    NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([CompanyId] ASC),
    CONSTRAINT [CK_Company_Discount] CHECK ([Discount]>=(0) AND [Discount]<=(1)),
    CONSTRAINT [CK_Company_Tax] CHECK ([Tax]>=(0) AND [Tax]<=(1)),
    CONSTRAINT [FK_Company_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId]),
    CONSTRAINT [FK_Company_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Company_Location]
    ON [dbo].[Company]([CountryId] ASC, [StateId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Company] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Company] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Company] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Company] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Company] TO [profit_role_datareader]
    AS [dbo];

