CREATE TABLE [dbo].[ClientDocDetail] (
    [DocumentId] INT        NOT NULL,
    [ProductId]  INT        NOT NULL,
    [CompanyId]  INT        NOT NULL,
    [Quantity]   INT        NOT NULL,
    [Tax]        MONEY      CONSTRAINT [DF_DocumentDet_Tax] DEFAULT ((0)) NULL,
    [Discount]   MONEY      CONSTRAINT [DF_DocumentDet_Discount] DEFAULT ((0)) NULL,
    [UnitPrice]  MONEY      NOT NULL,
    [RowInfo]    ROWVERSION NULL,
    CONSTRAINT [PK_ClientDocDetail] PRIMARY KEY CLUSTERED ([DocumentId] ASC, [ProductId] ASC),
    CONSTRAINT [CK_ClientDocDetail_Discount] CHECK ([Discount]>=(0)),
    CONSTRAINT [CK_ClientDocDetail_Quantity] CHECK ([Quantity]>(0)),
    CONSTRAINT [CK_ClientDocDetail_Tax] CHECK ([Tax]>=(0)),
    CONSTRAINT [CK_ClientDocDetail_UnitPrice] CHECK ([UnitPrice]>(0)),
    CONSTRAINT [FK_ClientDocDetail_ClientDocument] FOREIGN KEY ([DocumentId]) REFERENCES [dbo].[ClientDocument] ([DocumentId]),
    CONSTRAINT [FK_ClientDocDetail_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ClientDocDetail_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ClientDocDetail_Company]
    ON [dbo].[ClientDocDetail]([CompanyId] ASC);


GO
CREATE TRIGGER Profit_tg_ClientDocDetail ON [dbo].[ClientDocDetail] 
FOR INSERT, UPDATE, DELETE 
AS
	Declare @ProductId int
	Declare @OldQuantity int
	Declare @NewQuantity int

	If Exists(Select Quantity From Inserted)
		Select @ProductId = ProductId, @NewQuantity = Quantity
		From Inserted
	Else
		Set @NewQuantity = 0

	If Exists(Select Quantity From Deleted)
		Select @ProductId = ProductId, @OldQuantity = Quantity
		From Deleted
	Else
		Set @OldQuantity = 0

	Update Product Set UnitsInStock = UnitsInStock + @OldQuantity - @NewQuantity
	Where ProductId = @ProductId

GO
GRANT DELETE
    ON OBJECT::[dbo].[ClientDocDetail] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ClientDocDetail] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientDocDetail] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ClientDocDetail] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientDocDetail] TO [profit_role_datareader]
    AS [dbo];

