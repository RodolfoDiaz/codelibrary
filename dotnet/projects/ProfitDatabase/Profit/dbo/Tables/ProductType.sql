CREATE TABLE [dbo].[ProductType] (
    [ProductTypeId]  INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_ProductType] PRIMARY KEY CLUSTERED ([ProductTypeId] ASC),
    CONSTRAINT [FK_ProductType_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProductType_Company]
    ON [dbo].[ProductType]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ProductType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ProductType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProductType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ProductType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProductType] TO [profit_role_datareader]
    AS [dbo];

