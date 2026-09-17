CREATE PROCEDURE dbo.profit_sp_Department_Delete 
(	@pDepartmentId int 
 )
AS
	Delete Department
	Where
		[DepartmentId] = @pDepartmentId

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Department_Delete] TO [profit_role_datadelete]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[profit_sp_Department_Delete] TO [profit_role_fullaccess]
    AS [dbo];

