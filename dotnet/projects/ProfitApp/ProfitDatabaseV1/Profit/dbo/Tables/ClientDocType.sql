CREATE TABLE [dbo].[ClientDocType] (
    [DocTypeId]      INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [IsDebit]        BIT          NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_DocType] PRIMARY KEY CLUSTERED ([DocTypeId] ASC),
    CONSTRAINT [FK_ClientDocType_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ClientDocType_Company]
    ON [dbo].[ClientDocType]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ClientDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ClientDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ClientDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientDocType] TO [profit_role_datareader]
    AS [dbo];

