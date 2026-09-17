CREATE PROCEDURE dbo.profit_sp_PaymentType_Read
(	@pPaymentTypeId int
 )
AS
	Select
		[PaymentTypeId],
		[CompanyId],
		[Name],
		[Period],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	PaymentType
	Where [PaymentTypeId] = @pPaymentTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_PaymentType_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_PaymentType_Read] TO [profit_role_datareader]
    AS [dbo];

