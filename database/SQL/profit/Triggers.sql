if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Profit_tg_ClientDocDetail]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[Profit_tg_ClientDocDetail]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Profit_tg_ClientDocument]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[Profit_tg_ClientDocument]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Profit_tg_ProviderDocument]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[Profit_tg_ProviderDocument]
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE TRIGGER Profit_tg_ClientDocument ON [dbo].[ClientDocument]
FOR INSERT, UPDATE, DELETE
AS
	Declare @ClientId int
	Declare @NewAmount money
	Declare @OldAmount money
	Declare @DocTypeId int
	Declare @IsDebit bit

	If Exists(Select Amount From Inserted)
		Select @ClientId = ClientId, @NewAmount = Amount, @DocTypeId = DocTypeId
		From Inserted
	Else
		Set @NewAmount = 0

	If Exists(Select Amount From Deleted)
		Select @ClientId = ClientId, @OldAmount = Amount, @DocTypeId = DocTypeId
		From Deleted
	Else
		Set @OldAmount = 0

	Select @IsDebit = IsDebit From ClientDocType Where [DocTypeId] = @DocTypeId

	If @IsDebit = 0
		Update Client Set Balance = Balance - (@OldAmount - @NewAmount)
	Else
		Update Client Set Balance = Balance + (@OldAmount - @NewAmount)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE TRIGGER Profit_tg_ProviderDocument ON [dbo].[ProviderDocument]
FOR INSERT, UPDATE, DELETE
AS
	Declare @ProviderId int
	Declare @NewAmount money
	Declare @OldAmount money
	Declare @DocTypeId int
	Declare @IsDebit bit

	If Exists(Select Amount From Inserted)
		Select @ProviderId = ProviderId, @NewAmount = Amount, @DocTypeId = DocTypeId
		From Inserted
	Else
		Set @NewAmount = 0

	If Exists(Select Amount From Deleted)
		Select @ProviderId = ProviderId, @OldAmount = Amount, @DocTypeId = DocTypeId
		From Deleted
	Else
		Set @OldAmount = 0

	Select @IsDebit = IsDebit From ProviderDocType Where [DocTypeId] = @DocTypeId

	If @IsDebit = 1
		Update Provider Set Balance = Balance - (@OldAmount - @NewAmount)
	Else
		Update Provider Set Balance = Balance + (@OldAmount - @NewAmount)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

