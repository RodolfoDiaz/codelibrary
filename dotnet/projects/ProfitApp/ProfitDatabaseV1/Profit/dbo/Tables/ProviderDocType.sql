CREATE TABLE [dbo].[ProviderDocType] (
    [DocTypeId]      INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [IsDebit]        BIT          NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_ProviderDocType] PRIMARY KEY CLUSTERED ([DocTypeId] ASC),
    CONSTRAINT [FK_ProviderDocType_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProviderDocType_Company]
    ON [dbo].[ProviderDocType]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ProviderDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ProviderDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProviderDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ProviderDocType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProviderDocType] TO [profit_role_datareader]
    AS [dbo];

