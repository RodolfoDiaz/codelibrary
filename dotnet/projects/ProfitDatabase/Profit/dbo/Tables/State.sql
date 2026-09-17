CREATE TABLE [dbo].[State] (
    [StateId]        INT          IDENTITY (1, 1) NOT NULL,
    [CountryId]      INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([StateId] ASC),
    CONSTRAINT [FK_State_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId])
);


GO
CREATE NONCLUSTERED INDEX [IX_State_Country]
    ON [dbo].[State]([CountryId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[State] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[State] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[State] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[State] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[State] TO [profit_role_datareader]
    AS [dbo];

