/*
	Sidsa
	Profit Manager
	Data Insertion Script
*/ 
Use Profit

/* Country */
DECLARE @pCountryID int

Exec dbo.profit_sp_Country_Insert @pCountryID, 'Costa Rica'
Exec dbo.profit_sp_Country_Insert @pCountryID, 'Guatemala'
Exec dbo.profit_sp_Country_Insert @pCountryID, 'Honduras'
Exec dbo.profit_sp_Country_Insert @pCountryID, 'El Salvador'
Exec dbo.profit_sp_Country_Insert @pCountryID, 'Nicaragua'
Exec dbo.profit_sp_Country_Insert @pCountryID, 'Panamá'
Exec dbo.profit_sp_Country_Insert @pCountryID, 'México'

/* State */
DECLARE @pStateID int

Exec dbo.profit_sp_State_Insert @pStateID, 1, 'San José'
Exec dbo.profit_sp_State_Insert @pStateID, 1, 'Cartago'
Exec dbo.profit_sp_State_Insert @pStateID, 1, 'Heredia'
Exec dbo.profit_sp_State_Insert @pStateID, 1, 'Alajuela'
Exec dbo.profit_sp_State_Insert @pStateID, 1, 'Puntarenas'
Exec dbo.profit_sp_State_Insert @pStateID, 1, 'Guanacaste'
Exec dbo.profit_sp_State_Insert @pStateID, 1, 'Limón'

Exec dbo.profit_sp_State_Insert @pStateID, 2, 'Ciudad de Guatemala'
Exec dbo.profit_sp_State_Insert @pStateID, 3, 'Tegucigalpa'
Exec dbo.profit_sp_State_Insert @pStateID, 4, 'San Salvador'
Exec dbo.profit_sp_State_Insert @pStateID, 5, 'Managua'
Exec dbo.profit_sp_State_Insert @pStateID, 6, 'Ciudad de Panamá'
Exec dbo.profit_sp_State_Insert @pStateID, 7, 'Ciudad de México'

/* Company */
DECLARE @pCompanyID int

Exec dbo.profit_sp_Company_Insert @pCompanyID, 'Company Name', NULL, 'Company Address', 1, 1, NULL, '8880-0000', NULL, NULL, '', 0.13, 0, 1, 'es-CR', '¢', '$', 'Colones','Dólares'

/* Department */
DECLARE @pDepartmentID int

Exec dbo.profit_sp_Department_Insert @pDepartmentID, 1, 'Administración', NULL

/* MoneyType */
DECLARE @pMoneyTypeID int

Exec dbo.profit_sp_MoneyType_Insert @pMoneyTypeID, 1, 'Efectivo'
Exec dbo.profit_sp_MoneyType_Insert @pMoneyTypeID, 1, 'Cheque'
Exec dbo.profit_sp_MoneyType_Insert @pMoneyTypeID, 1, 'Tarjeta de Crédito'
Exec dbo.profit_sp_MoneyType_Insert @pMoneyTypeID, 1, 'Letra de Cambio'
Exec dbo.profit_sp_MoneyType_Insert @pMoneyTypeID, 1, 'Otro'

/* PaymentType */
DECLARE @pPaymentTypeID int

Exec dbo.profit_sp_PaymentType_Insert @pPaymentTypeID, 1, 'Contado', 0
Exec dbo.profit_sp_PaymentType_Insert @pPaymentTypeID, 1, 'Crédito a 15 días', 15
Exec dbo.profit_sp_PaymentType_Insert @pPaymentTypeID, 1, 'Crédito a 30 días', 30
Exec dbo.profit_sp_PaymentType_Insert @pPaymentTypeID, 1, 'Crédito a 45 días', 45
Exec dbo.profit_sp_PaymentType_Insert @pPaymentTypeID, 1, 'Crédito a 60 días', 60
Exec dbo.profit_sp_PaymentType_Insert @pPaymentTypeID, 1, 'Crédito a 90 días', 90

/* Warehouse */
DECLARE @pWarehouseID int

Exec dbo.profit_sp_Warehouse_Insert @pWarehouseID, 1, 'Principal', NULL

/* Currency */
DECLARE @pExchangeRateID int

Exec dbo.profit_sp_ExchangeRate_Insert @pExchangeRateID, 1, 1

/* ClientDocType */
DECLARE @pDocTypeID int

Exec dbo.profit_sp_ClientDocType_Insert @pDocTypeID, 1, 'Factura', 0
Exec dbo.profit_sp_ClientDocType_Insert @pDocTypeID, 1, 'Nota de Débito', 0
Exec dbo.profit_sp_ClientDocType_Insert @pDocTypeID, 1, 'Otro Débito', 0
Exec dbo.profit_sp_ClientDocType_Insert @pDocTypeID, 1, 'Recibo por Dinero', 1
Exec dbo.profit_sp_ClientDocType_Insert @pDocTypeID, 1, 'Nota de Crédito', 1
Exec dbo.profit_sp_ClientDocType_Insert @pDocTypeID, 1, 'Otro Crédito', 1

/* ProviderDocType */

Exec dbo.profit_sp_ProviderDocType_Insert @pDocTypeID, 1, 'Factura', 1
Exec dbo.profit_sp_ProviderDocType_Insert @pDocTypeID, 1, 'Nota de Débito', 1
Exec dbo.profit_sp_ProviderDocType_Insert @pDocTypeID, 1, 'Otro Débito', 1
Exec dbo.profit_sp_ProviderDocType_Insert @pDocTypeID, 1, 'Recibo por Dinero', 0
Exec dbo.profit_sp_ProviderDocType_Insert @pDocTypeID, 1, 'Nota de Crédito', 0
Exec dbo.profit_sp_ProviderDocType_Insert @pDocTypeID, 1, 'Otro Crédito', 0

/* DocumentStatus*/
DECLARE @pDocumentStatusID int

Exec dbo.profit_sp_DocumentStatus_Insert @pDocumentStatusID, 1, 'Nuevo'
Exec dbo.profit_sp_DocumentStatus_Insert @pDocumentStatusID, 1, 'Revisado'
Exec dbo.profit_sp_DocumentStatus_Insert @pDocumentStatusID, 1, 'Empacado'
Exec dbo.profit_sp_DocumentStatus_Insert @pDocumentStatusID, 1, 'Entregado'
Exec dbo.profit_sp_DocumentStatus_Insert @pDocumentStatusID, 1, 'Cancelado'
Exec dbo.profit_sp_DocumentStatus_Insert @pDocumentStatusID, 1, 'Anulado'

/*
Select * From State
Select * From Country
Select * From Company
Select * From Department
Select * From MoneyType
Select * From PaymentType
Select * From Warehouse
Select * From ExchangeRate
Select * From Clientdoctype
Select * From Providerdoctype
Select * From Documentstatus

Delete From Documentstatus
Delete From Clientdoctype
Delete From Providerdoctype
Delete From Warehouse
Delete From Department
Delete From MoneyType
Delete From PaymentType
Delete From ExchangeRate
Delete From Company
Delete From State
Delete From Country
*/