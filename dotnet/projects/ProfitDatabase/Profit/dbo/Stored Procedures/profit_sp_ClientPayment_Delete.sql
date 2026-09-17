CREATE PROCEDURE dbo.profit_sp_ClientPayment_Delete 
(	@pClientPaymentId int 
 )
AS
	Delete ClientPayment
	Where
		([ClientPaymentId] = @pClientPaymentId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientPayment_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ClientPayment_Delete] TO [profit_role_fullaccess]
    AS [dbo];

