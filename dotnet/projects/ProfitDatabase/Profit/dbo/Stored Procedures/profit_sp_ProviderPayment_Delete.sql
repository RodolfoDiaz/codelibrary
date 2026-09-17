CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Delete 
(	@pProviderPaymentId int 
 )
AS
	Delete ProviderPayment
	Where
		([ProviderPaymentId] = @pProviderPaymentId)

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_ProviderPayment_Delete] TO [profit_role_fullaccess]
    AS [dbo];

