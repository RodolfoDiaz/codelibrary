CREATE TABLE [dbo].[Warehouse] (
    [WarehouseId]    INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT           NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    [Location]       VARCHAR (200) NULL,
    [InsertUser]     INT           NOT NULL,
    [InsertDate]     DATETIME      NOT NULL,
    [LastUpdateUser] INT           NULL,
    [LastUpdateDate] DATETIME      NULL,
    [RowInfo]        ROWVERSION    NULL,
    CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED ([WarehouseId] ASC),
    CONSTRAINT [FK_Warehouse_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Warehouse_Company]
    ON [dbo].[Warehouse]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Warehouse] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Warehouse] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Warehouse] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Warehouse] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Warehouse] TO [profit_role_datareader]
    AS [dbo];

