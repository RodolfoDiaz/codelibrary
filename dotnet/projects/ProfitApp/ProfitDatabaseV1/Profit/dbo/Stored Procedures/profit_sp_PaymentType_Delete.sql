CREATE PROCEDURE dbo.profit_sp_PaymentType_Delete 
(	@pPaymentTypeId int
 )
AS
	Delete PaymentType
	Where	[PaymentTypeId] = @pPaymentTypeId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_PaymentType_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_PaymentType_Delete] TO [profit_role_fullaccess]
    AS [dbo];

