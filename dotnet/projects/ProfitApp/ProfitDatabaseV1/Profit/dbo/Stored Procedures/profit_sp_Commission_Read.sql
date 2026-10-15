CREATE PROCEDURE dbo.profit_sp_Commission_Read
(	@pCommissionId int
 )
AS
	Select
		[CommissionId], 
		[CompanyId], 
		[EmployeeId], 
		[DocumentId], 
		[DocDate], 
		[Amount], 
		[ExchangeRate], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From
		Commission
	Where [CommissionId] = @pCommissionId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Read] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Commission_Read] TO [profit_role_datareader]
    AS [dbo];

