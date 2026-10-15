CREATE TABLE [dbo].[ClientContact] (
    [ContactId]      INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]       INT           NOT NULL,
    [CompanyId]      INT           NOT NULL,
    [FirstName]      VARCHAR (50)  NOT NULL,
    [LastName]       VARCHAR (50)  NOT NULL,
    [Title]          VARCHAR (25)  NULL,
    [IdNumber]       VARCHAR (25)  NULL,
    [Address]        VARCHAR (200) NULL,
    [City]           VARCHAR (25)  NULL,
    [StateId]        INT           NOT NULL,
    [CountryId]      INT           NOT NULL,
    [Gender]         VARCHAR (1)   NULL,
    [PostalCode]     VARCHAR (25)  NULL,
    [Phone]          VARCHAR (25)  NULL,
    [Fax]            VARCHAR (25)  NULL,
    [MobilePhone]    VARCHAR (25)  NULL,
    [EmailAddress]   VARCHAR (50)  NULL,
    [Birthday]       DATETIME      NULL,
    [IsActive]       BIT           CONSTRAINT [DF_ClientContact_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertUser]     INT           NOT NULL,
    [InsertDate]     DATETIME      NOT NULL,
    [LastUpdateUser] INT           NULL,
    [LastUpdateDate] DATETIME      NULL,
    [RowInfo]        ROWVERSION    NULL,
    CONSTRAINT [PK_ClientContact] PRIMARY KEY CLUSTERED ([ContactId] ASC),
    CONSTRAINT [CK_ClientContact_Birthday] CHECK ([Birthday]<getdate()),
    CONSTRAINT [FK_ClientContact_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_ClientContact_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ClientContact_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId]),
    CONSTRAINT [FK_ClientContact_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ClientContact_Company]
    ON [dbo].[ClientContact]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ClientContact_CompanyClient]
    ON [dbo].[ClientContact]([CompanyId] ASC, [ClientId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ClientContact] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ClientContact] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientContact] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ClientContact] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientContact] TO [profit_role_datareader]
    AS [dbo];

