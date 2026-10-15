CREATE TABLE [dbo].[Product] (
    [ProductId]      INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [ProductTypeId]  INT          NOT NULL,
    [ProviderId]     INT          NOT NULL,
    [WarehouseId]    INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [UnitsInStock]   INT          CONSTRAINT [DF_Product_UnitsInStock] DEFAULT ((0)) NOT NULL,
    [UnitPrice]      MONEY        NOT NULL,
    [IsActive]       BIT          CONSTRAINT [DF_Product_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductId] ASC),
    CONSTRAINT [CK_Product_UnitPrice] CHECK ([UnitPrice]>=(0)),
    CONSTRAINT [CK_Product_UnitsInStock] CHECK ([UnitsInStock]>=(0)),
    CONSTRAINT [FK_Product_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_Product_ProductType] FOREIGN KEY ([ProductTypeId]) REFERENCES [dbo].[ProductType] ([ProductTypeId]),
    CONSTRAINT [FK_Product_Provider] FOREIGN KEY ([ProviderId]) REFERENCES [dbo].[Provider] ([ProviderId]),
    CONSTRAINT [FK_Product_Warehouse] FOREIGN KEY ([WarehouseId]) REFERENCES [dbo].[Warehouse] ([WarehouseId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Product_Company]
    ON [dbo].[Product]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Product] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Product] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Product] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Product] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Product] TO [profit_role_datareader]
    AS [dbo];

