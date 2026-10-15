CREATE TABLE [dbo].[Country] (
    [CountryId]      INT          IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Country] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Country] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Country] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Country] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Country] TO [profit_role_datareader]
    AS [dbo];

