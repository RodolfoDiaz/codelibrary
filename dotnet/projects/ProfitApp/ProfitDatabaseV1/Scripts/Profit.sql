-- EXECUTE THIS SCRIPT AS SYSTEM ADMINISTRATOR (SA)

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Profit')
	DROP DATABASE [Profit]
GO

CREATE DATABASE [Profit]
GO

use [Profit]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Client_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Client] DROP CONSTRAINT FK_Client_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientContact_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientContact] DROP CONSTRAINT FK_ClientContact_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Company_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Company] DROP CONSTRAINT FK_Company_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Employee_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT FK_Employee_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Provider_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Provider] DROP CONSTRAINT FK_Provider_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderContact_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderContact] DROP CONSTRAINT FK_ProviderContact_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_State_Country]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[State] DROP CONSTRAINT FK_State_Country
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Client_State]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Client] DROP CONSTRAINT FK_Client_State
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientContact_State]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientContact] DROP CONSTRAINT FK_ClientContact_State
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Company_State]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Company] DROP CONSTRAINT FK_Company_State
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Employee_State]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT FK_Employee_State
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Provider_State]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Provider] DROP CONSTRAINT FK_Provider_State
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderContact_State]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderContact] DROP CONSTRAINT FK_ProviderContact_State
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Client_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Client] DROP CONSTRAINT FK_Client_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientContact_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientContact] DROP CONSTRAINT FK_ClientContact_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocDetail_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocDetail] DROP CONSTRAINT FK_ClientDocDetail_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocType_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocType] DROP CONSTRAINT FK_ClientDocType_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocument_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocument] DROP CONSTRAINT FK_ClientDocument_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientPayment_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientPayment] DROP CONSTRAINT FK_ClientPayment_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Commission_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Commission] DROP CONSTRAINT FK_Commission_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Department_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Department] DROP CONSTRAINT FK_Department_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DocumentStatus_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DocumentStatus] DROP CONSTRAINT FK_DocumentStatus_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Employee_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT FK_Employee_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_EmployeeProfile_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[EmployeeProfile] DROP CONSTRAINT FK_EmployeeProfile_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ExchangeRate_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ExchangeRate] DROP CONSTRAINT FK_ExchangeRate_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MoneyType_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[MoneyType] DROP CONSTRAINT FK_MoneyType_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PaymentType_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PaymentType] DROP CONSTRAINT FK_PaymentType_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Product_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProductType_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProductType] DROP CONSTRAINT FK_ProductType_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Provider_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Provider] DROP CONSTRAINT FK_Provider_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderContact_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderContact] DROP CONSTRAINT FK_ProviderContact_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderDocType_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderDocType] DROP CONSTRAINT FK_ProviderDocType_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderDocument_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderDocument] DROP CONSTRAINT FK_ProviderDocument_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderPayment_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderPayment] DROP CONSTRAINT FK_ProviderPayment_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_UserInfo_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[UserInfo] DROP CONSTRAINT FK_UserInfo_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Warehouse_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Warehouse] DROP CONSTRAINT FK_Warehouse_Company
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocument_ClientDocType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocument] DROP CONSTRAINT FK_ClientDocument_ClientDocType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Employee_Department]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT FK_Employee_Department
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocument_DocumentStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocument] DROP CONSTRAINT FK_ClientDocument_DocumentStatus
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderDocument_DocumentStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderDocument] DROP CONSTRAINT FK_ProviderDocument_DocumentStatus
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Employee_EmployeeProfile]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT FK_Employee_EmployeeProfile
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientPayment_MoneyType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientPayment] DROP CONSTRAINT FK_ClientPayment_MoneyType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderPayment_MoneyType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderPayment] DROP CONSTRAINT FK_ProviderPayment_MoneyType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocument_PaymentType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocument] DROP CONSTRAINT FK_ClientDocument_PaymentType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderDocument_PaymentType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderDocument] DROP CONSTRAINT FK_ProviderDocument_PaymentType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_ProductType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Product_ProductType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderDocument_ProviderDocType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderDocument] DROP CONSTRAINT FK_ProviderDocument_ProviderDocType
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_Warehouse]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Product_Warehouse
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocument_Employee]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocument] DROP CONSTRAINT FK_ClientDocument_Employee
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Commission_Employee]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Commission] DROP CONSTRAINT FK_Commission_Employee
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientContact_Client]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientContact] DROP CONSTRAINT FK_ClientContact_Client
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocument_Client]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocument] DROP CONSTRAINT FK_ClientDocument_Client
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientPayment_Client]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientPayment] DROP CONSTRAINT FK_ClientPayment_Client
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Client_ClientContact]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Client] DROP CONSTRAINT FK_Client_ClientContact
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocDetail_ClientDocument]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocDetail] DROP CONSTRAINT FK_ClientDocDetail_ClientDocument
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientPayment_ClientDocument_Credit]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientPayment] DROP CONSTRAINT FK_ClientPayment_ClientDocument_Credit
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientPayment_ClientDocument_Debit]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientPayment] DROP CONSTRAINT FK_ClientPayment_ClientDocument_Debit
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Commission_ClientDocument]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Commission] DROP CONSTRAINT FK_Commission_ClientDocument
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ClientDocDetail_Product]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClientDocDetail] DROP CONSTRAINT FK_ClientDocDetail_Product
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_Provider]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Product_Provider
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderContact_Provider]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderContact] DROP CONSTRAINT FK_ProviderContact_Provider
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderDocument_Provider]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderDocument] DROP CONSTRAINT FK_ProviderDocument_Provider
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderPayment_Provider]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderPayment] DROP CONSTRAINT FK_ProviderPayment_Provider
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Provider_ProviderContact]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Provider] DROP CONSTRAINT FK_Provider_ProviderContact
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderPayment_ProviderDocument_Credit]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderPayment] DROP CONSTRAINT FK_ProviderPayment_ProviderDocument_Credit
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProviderPayment_ProviderDocument_Debit]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProviderPayment] DROP CONSTRAINT FK_ProviderPayment_ProviderDocument_Debit
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientContact_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientContact_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientContact_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientContact_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientContact_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientContact_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientContact_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientContact_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocDetail_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocDetail_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocDetail_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocDetail_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocDetail_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocDetail_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocDetail_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocDetail_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocument_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocument_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocument_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocument_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocument_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocument_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocument_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocument_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientPayment_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientPayment_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientPayment_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientPayment_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientPayment_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientPayment_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientPayment_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientPayment_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Client_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Client_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Client_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Client_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Client_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Client_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Client_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Client_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Commission_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Commission_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Commission_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Commission_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Commission_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Commission_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Commission_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Commission_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Product_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Product_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Product_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Product_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Product_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Product_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Product_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Product_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderContact_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderContact_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderContact_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderContact_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderContact_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderContact_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderContact_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderContact_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocument_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocument_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocument_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocument_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocument_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocument_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocument_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocument_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderPayment_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderPayment_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderPayment_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderPayment_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderPayment_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderPayment_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderPayment_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderPayment_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Provider_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Provider_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Provider_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Provider_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Provider_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Provider_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Provider_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Provider_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Employee_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Employee_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Employee_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Employee_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Employee_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Employee_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Employee_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Employee_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocType_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocType_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocType_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocType_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocType_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocType_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ClientDocType_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ClientDocType_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Department_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Department_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Department_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Department_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Department_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Department_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Department_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Department_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_DocumentStatus_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_DocumentStatus_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_DocumentStatus_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_DocumentStatus_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_DocumentStatus_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_DocumentStatus_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_DocumentStatus_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_DocumentStatus_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_EmployeeProfile_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_EmployeeProfile_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_EmployeeProfile_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_EmployeeProfile_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_EmployeeProfile_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_EmployeeProfile_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_EmployeeProfile_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_EmployeeProfile_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ExchangeRate_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ExchangeRate_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ExchangeRate_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ExchangeRate_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ExchangeRate_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ExchangeRate_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ExchangeRate_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ExchangeRate_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_GetExchangeRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_GetExchangeRate]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_MoneyType_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_MoneyType_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_MoneyType_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_MoneyType_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_MoneyType_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_MoneyType_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_MoneyType_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_MoneyType_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_PaymentType_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_PaymentType_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_PaymentType_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_PaymentType_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_PaymentType_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_PaymentType_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_PaymentType_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_PaymentType_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProductType_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProductType_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProductType_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProductType_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProductType_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProductType_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProductType_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProductType_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocType_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocType_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocType_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocType_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocType_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocType_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_ProviderDocType_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_ProviderDocType_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_UserInfo_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_UserInfo_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_UserInfo_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_UserInfo_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_UserInfo_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_UserInfo_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_UserInfo_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_UserInfo_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Warehouse_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Warehouse_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Warehouse_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Warehouse_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Warehouse_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Warehouse_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Warehouse_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Warehouse_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Company_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Company_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Company_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Company_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Company_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Company_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Company_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Company_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_State_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_State_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_State_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_State_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_State_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_State_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_State_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_State_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Country_Delete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Country_Delete]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Country_Insert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Country_Insert]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Country_Read]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Country_Read]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_sp_Country_Update]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[profit_sp_Country_Update]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Client]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Client]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ClientContact]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ClientContact]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ClientDocDetail]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ClientDocDetail]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ClientDocument]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ClientDocument]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ClientPayment]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ClientPayment]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Commission]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Commission]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Product]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Product]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Provider]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Provider]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ProviderContact]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ProviderContact]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ProviderDocument]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ProviderDocument]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ProviderPayment]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ProviderPayment]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Employee]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Employee]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ClientDocType]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ClientDocType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Department]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Department]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_DocumentStatus]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_DocumentStatus]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_EmployeeProfile]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_EmployeeProfile]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ExchangeRate]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ExchangeRate]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_MoneyType]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_MoneyType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_PaymentType]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_PaymentType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ProductType]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ProductType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_ProviderDocType]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_ProviderDocType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_UserInfo]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_UserInfo]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Warehouse]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Warehouse]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Company]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Company]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_State]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_State]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[profit_vw_Country]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[profit_vw_Country]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Client]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Client]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClientContact]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClientContact]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClientDocDetail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClientDocDetail]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClientDocument]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClientDocument]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClientPayment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClientPayment]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Commission]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Commission]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Product]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Product]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Provider]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Provider]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProviderContact]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProviderContact]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProviderDocument]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProviderDocument]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProviderPayment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProviderPayment]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Employee]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Employee]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClientDocType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClientDocType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Department]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Department]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DocumentStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocumentStatus]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EmployeeProfile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EmployeeProfile]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ExchangeRate]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ExchangeRate]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MoneyType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MoneyType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PaymentType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PaymentType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProductType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProductType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProviderDocType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProviderDocType]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserInfo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UserInfo]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Warehouse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Warehouse]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Company]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Company]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[State]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[State]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Country]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Country]
GO
if not exists (select * from master.dbo.syslogins where loginname = N'ProfitUser')
BEGIN
	declare @logindb nvarchar(132), @loginlang nvarchar(132) select @logindb = N'ProfitUser', @loginlang = N'us_english'
	if @logindb is null or not exists (select * from master.dbo.sysdatabases where name = @logindb)
		select @logindb = N'Profit'
	if @loginlang is null or (not exists (select * from master.dbo.syslanguages where name = @loginlang) and @loginlang <> N'us_english')
		select @loginlang = @@language
	
	--  For security reasons, never hardcode passwords directly in this file.
	DECLARE @password NVARCHAR(50)
	-- Set the value to the variable, but do not commit/push this change!
	--SELECT @password = ''
	
	exec sp_addlogin N'ProfitUser', @password, @logindb, @loginlang
END
GO
if not exists (select * from dbo.sysusers where name = N'Profit' and uid < 16382)
	CREATE USER [ProfitUser] FOR LOGIN [ProfitUser]
GO
if not exists (select * from dbo.sysusers where name = N'profit_role_datadelete' and uid > 16399)
	EXEC sp_addrole N'profit_role_datadelete'
GO
if not exists (select * from dbo.sysusers where name = N'profit_role_datainsert' and uid > 16399)
	EXEC sp_addrole N'profit_role_datainsert'
GO
if not exists (select * from dbo.sysusers where name = N'profit_role_dataupdate' and uid > 16399)
	EXEC sp_addrole N'profit_role_dataupdate'
GO
if not exists (select * from dbo.sysusers where name = N'profit_role_fullaccess' and uid > 16399)
	EXEC sp_addrole N'profit_role_fullaccess'
GO
if not exists (select * from dbo.sysusers where name = N'profit_role_datareader' and uid > 16399)
	EXEC sp_addrole N'profit_role_datareader'
GO
exec sp_addrolemember N'profit_role_datadelete', N'ProfitUser'
GO
exec sp_addrolemember N'profit_role_datainsert', N'ProfitUser'
GO
exec sp_addrolemember N'profit_role_datareader', N'ProfitUser'
GO
exec sp_addrolemember N'profit_role_dataupdate', N'ProfitUser'
GO
CREATE TABLE [dbo].[Country] (
	[CountryId] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[State] (
	[StateId] [int] IDENTITY (1, 1) NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Company] (
	[CompanyId] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Address] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateId] [int] NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[PostalCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Website] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Tax] [money] NULL ,
	[Discount] [money] NULL ,
	[MultipleCurrency] [bit] NOT NULL ,
	[Culture] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LocalSign] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ForeignSign] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LocalName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ForeignName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ClientDocType] (
	[DocTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IsDebit] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Department] (
	[DepartmentId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Location] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[DocumentStatus] (
	[DocumentStatusId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[EmployeeProfile] (
	[EmployeeProfileId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Commission] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ExchangeRate] (
	[ExchangeRateId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[RefreshDate] [datetime] NOT NULL ,
	[Amount] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[MoneyType] (
	[MoneyTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[PaymentType] (
	[PaymentTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Period] [smallint] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ProductType] (
	[ProductTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ProviderDocType] (
	[DocTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IsDebit] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[UserInfo] (
	[UserInfoId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SidName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Culture] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Role] [smallint] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Warehouse] (
	[WarehouseId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Location] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Employee] (
	[EmployeeId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[DepartmentId] [int] NOT NULL ,
	[EmployeeProfileId] [int] NOT NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Title] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IdNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateId] [int] NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PostalCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MobilePhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Birthday] [datetime] NULL ,
	[IsActive] [bit] NOT NULL ,
	[MaritalStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DateHired] [datetime] NULL ,
	[Deductions] [money] NULL ,
	[Salary] [money] NULL ,
	[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContactPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Client] (
	[ClientId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Address] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateId] [int] NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[PrimaryContactId] [int] NULL ,
	[PostalCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Website] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreditLimit] [money] NOT NULL ,
	[Balance] [money] NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ClientContact] (
	[ContactId] [int] IDENTITY (1, 1) NOT NULL ,
	[ClientId] [int] NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Title] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IdNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateId] [int] NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PostalCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MobilePhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Birthday] [datetime] NULL ,
	[IsActive] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ClientDocDetail] (
	[DocumentId] [int] NOT NULL ,
	[ProductId] [int] NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Quantity] [int] NOT NULL ,
	[Tax] [money] NULL ,
	[Discount] [money] NULL ,
	[UnitPrice] [money] NOT NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ClientDocument] (
	[DocumentId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[DocTypeId] [int] NOT NULL ,
	[DocumentStatusId] [int] NOT NULL ,
	[ClientId] [int] NOT NULL ,
	[EmployeeId] [int] NOT NULL ,
	[PaymentTypeId] [int] NOT NULL ,
	[Commission] [money] NOT NULL ,
	[CommissionPaid] [bit] NOT NULL ,
	[DocDate] [datetime] NOT NULL ,
	[DocConsecutive] [int] NOT NULL ,
	[OtherCost] [money] NULL ,
	[Discount] [money] NULL ,
	[Tax] [money] NULL ,
	[Amount] [money] NOT NULL ,
	[Remarks] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExchangeRate] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ClientPayment] (
	[ClientPaymentId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[ClientId] [int] NOT NULL ,
	[CreditDocumentId] [int] NOT NULL ,
	[DebitDocumentId] [int] NOT NULL ,
	[MoneyTypeId] [int] NOT NULL ,
	[PaymentDate] [datetime] NOT NULL ,
	[Amount] [money] NOT NULL ,
	[Remarks] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExchangeRate] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Commission] (
	[CommissionId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[EmployeeId] [int] NOT NULL ,
	[DocumentId] [int] NOT NULL ,
	[DocDate] [datetime] NOT NULL ,
	[Amount] [money] NOT NULL ,
	[ExchangeRate] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Product] (
	[ProductId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[ProductTypeId] [int] NOT NULL ,
	[ProviderId] [int] NOT NULL ,
	[WarehouseId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[UnitsInStock] [int] NOT NULL ,
	[UnitPrice] [money] NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Provider] (
	[ProviderId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Address] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateId] [int] NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[PrimaryContactId] [int] NULL ,
	[PostalCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Website] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CreditLimit] [money] NOT NULL ,
	[Balance] [money] NOT NULL ,
	[IsActive] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ProviderContact] (
	[ContactId] [int] IDENTITY (1, 1) NOT NULL ,
	[ProviderId] [int] NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Title] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IdNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Address] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StateId] [int] NOT NULL ,
	[CountryId] [int] NOT NULL ,
	[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PostalCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MobilePhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Birthday] [datetime] NULL ,
	[IsActive] [bit] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ProviderDocument] (
	[DocumentId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[DocTypeId] [int] NOT NULL ,
	[DocumentStatusId] [int] NOT NULL ,
	[ProviderId] [int] NOT NULL ,
	[PaymentTypeId] [int] NOT NULL ,
	[DocDate] [datetime] NOT NULL ,
	[DocConsecutive] [int] NOT NULL ,
	[OtherCost] [money] NULL ,
	[Discount] [money] NULL ,
	[Tax] [money] NULL ,
	[Amount] [money] NOT NULL ,
	[Remarks] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExchangeRate] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[ProviderPayment] (
	[ProviderPaymentId] [int] IDENTITY (1, 1) NOT NULL ,
	[CompanyId] [int] NOT NULL ,
	[ProviderId] [int] NOT NULL ,
	[DebitDocumentId] [int] NOT NULL ,
	[CreditDocumentId] [int] NOT NULL ,
	[MoneyTypeId] [int] NOT NULL ,
	[PaymentDate] [datetime] NOT NULL ,
	[Amount] [money] NOT NULL ,
	[Remarks] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ExchangeRate] [money] NOT NULL ,
	[InsertUser] [int] NOT NULL ,
	[InsertDate] [datetime] NOT NULL ,
	[LastUpdateUser] [int] NULL ,
	[LastUpdateDate] [datetime] NULL ,
	[RowInfo] [timestamp] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Country] WITH NOCHECK ADD 
	CONSTRAINT [PK_Country] PRIMARY KEY  CLUSTERED 
	(
		[CountryId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[State] WITH NOCHECK ADD 
	CONSTRAINT [PK_State] PRIMARY KEY  CLUSTERED 
	(
		[StateId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Company] WITH NOCHECK ADD 
	CONSTRAINT [PK_Company] PRIMARY KEY  CLUSTERED 
	(
		[CompanyId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ClientDocType] WITH NOCHECK ADD 
	CONSTRAINT [PK_DocType] PRIMARY KEY  CLUSTERED 
	(
		[DocTypeId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Department] WITH NOCHECK ADD 
	CONSTRAINT [PK_Department] PRIMARY KEY  CLUSTERED 
	(
		[DepartmentId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[DocumentStatus] WITH NOCHECK ADD 
	CONSTRAINT [PK_DocumentStatus] PRIMARY KEY  CLUSTERED 
	(
		[DocumentStatusId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[EmployeeProfile] WITH NOCHECK ADD 
	CONSTRAINT [PK_EmployeeProfile] PRIMARY KEY  CLUSTERED 
	(
		[EmployeeProfileId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ExchangeRate] WITH NOCHECK ADD 
	CONSTRAINT [PK_ExchangeRate] PRIMARY KEY  CLUSTERED 
	(
		[ExchangeRateId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[MoneyType] WITH NOCHECK ADD 
	CONSTRAINT [PK_MoneyType] PRIMARY KEY  CLUSTERED 
	(
		[MoneyTypeId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[PaymentType] WITH NOCHECK ADD 
	CONSTRAINT [PK_PaymentType] PRIMARY KEY  CLUSTERED 
	(
		[PaymentTypeId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ProductType] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProductType] PRIMARY KEY  CLUSTERED 
	(
		[ProductTypeId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ProviderDocType] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProviderDocType] PRIMARY KEY  CLUSTERED 
	(
		[DocTypeId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[UserInfo] WITH NOCHECK ADD 
	CONSTRAINT [PK_UserInfo] PRIMARY KEY  CLUSTERED 
	(
		[UserInfoId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Warehouse] WITH NOCHECK ADD 
	CONSTRAINT [PK_Warehouse] PRIMARY KEY  CLUSTERED 
	(
		[WarehouseId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Employee] WITH NOCHECK ADD 
	CONSTRAINT [PK_Employee] PRIMARY KEY  CLUSTERED 
	(
		[EmployeeId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Client] WITH NOCHECK ADD 
	CONSTRAINT [PK_Client] PRIMARY KEY  CLUSTERED 
	(
		[ClientId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ClientContact] WITH NOCHECK ADD 
	CONSTRAINT [PK_ClientContact] PRIMARY KEY  CLUSTERED 
	(
		[ContactId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ClientDocDetail] WITH NOCHECK ADD 
	CONSTRAINT [PK_ClientDocDetail] PRIMARY KEY  CLUSTERED 
	(
		[DocumentId],
		[ProductId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ClientDocument] WITH NOCHECK ADD 
	CONSTRAINT [PK_ClientDocument] PRIMARY KEY  CLUSTERED 
	(
		[DocumentId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ClientPayment] WITH NOCHECK ADD 
	CONSTRAINT [PK_ClientPayment] PRIMARY KEY  CLUSTERED 
	(
		[ClientPaymentId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Commission] WITH NOCHECK ADD 
	CONSTRAINT [PK_Commission] PRIMARY KEY  CLUSTERED 
	(
		[CommissionId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Product] WITH NOCHECK ADD 
	CONSTRAINT [PK_Product] PRIMARY KEY  CLUSTERED 
	(
		[ProductId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Provider] WITH NOCHECK ADD 
	CONSTRAINT [PK_Provider] PRIMARY KEY  CLUSTERED 
	(
		[ProviderId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ProviderContact] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProviderContact] PRIMARY KEY  CLUSTERED 
	(
		[ContactId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ProviderDocument] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProviderDocument] PRIMARY KEY  CLUSTERED 
	(
		[DocumentId]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[ProviderPayment] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProviderPayment] PRIMARY KEY  CLUSTERED 
	(
		[ProviderPaymentId]
	)  ON [PRIMARY] 
GO
 CREATE  INDEX [IX_State_Country] ON [dbo].[State]([CountryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Company] ADD 
	CONSTRAINT [DF_Company_Tax] DEFAULT (0) FOR [Tax],
	CONSTRAINT [DF_Company_Discount] DEFAULT (0) FOR [Discount],
	CONSTRAINT [DF_Company_MultipleCurrency] DEFAULT (1) FOR [MultipleCurrency],
	CONSTRAINT [CK_Company_Discount] CHECK ([Discount] >= 0 and [Discount] <= 1),
	CONSTRAINT [CK_Company_Tax] CHECK ([Tax] >= 0 and [Tax] <= 1)
GO
 CREATE  INDEX [IX_Company_Location] ON [dbo].[Company]([CountryId], [StateId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ClientDocType_Company] ON [dbo].[ClientDocType]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_Department_Company] ON [dbo].[Department]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_DocumentStatus_Company] ON [dbo].[DocumentStatus]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeProfile] ADD 
	CONSTRAINT [DF_EmployeeProfile_Commission] DEFAULT (0) FOR [Commission],
	CONSTRAINT [CK_EmployeeProfile_Commission] CHECK ([Commission] >= 0 and [Commission] <= 1)
GO
 CREATE  INDEX [IX_EmployeeProfile_Company] ON [dbo].[EmployeeProfile]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExchangeRate] ADD 
	CONSTRAINT [CK_ExchangeRate] CHECK ([Amount] > 0)
GO
 CREATE  INDEX [IX_ExchangeRate_Company] ON [dbo].[ExchangeRate]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_MoneyType_Company] ON [dbo].[MoneyType]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentType] ADD 
	CONSTRAINT [DF_PaymentType_Period] DEFAULT (0) FOR [Period],
	CONSTRAINT [CK_PaymentType_Period] CHECK ([Period] >= 0)
GO
 CREATE  INDEX [IX_PaymentType_Company] ON [dbo].[PaymentType]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ProductType_Company] ON [dbo].[ProductType]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ProviderDocType_Company] ON [dbo].[ProviderDocType]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserInfo] ADD 
	CONSTRAINT [CK_UserInfo] CHECK ([Role] >= 0 and [Role] <= 10)
GO
 CREATE  INDEX [IX_UserInfo_Company] ON [dbo].[UserInfo]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_Warehouse_Company] ON [dbo].[Warehouse]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee] ADD 
	CONSTRAINT [DF_Employee_Deductions] DEFAULT (0) FOR [Deductions],
	CONSTRAINT [DF_Employee_Salary] DEFAULT (0) FOR [Salary],
	CONSTRAINT [CK_Employee_Birthday] CHECK ([Birthday] < getdate()),
	CONSTRAINT [CK_Employee_DateHired] CHECK ([DateHired] < getdate() + 1),
	CONSTRAINT [CK_Employee_Deductions] CHECK ([Deductions] >= 0),
	CONSTRAINT [CK_Employee_Salary] CHECK ([Salary] >= 0)
GO
 CREATE  INDEX [IX_Employee_Company] ON [dbo].[Employee]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_Employee_CompanyCountry] ON [dbo].[Employee]([CompanyId], [CountryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Client] ADD 
	CONSTRAINT [DF_Client_CreditLimit] DEFAULT (0) FOR [CreditLimit],
	CONSTRAINT [DF_Client_Balance] DEFAULT (0) FOR [Balance],
	CONSTRAINT [DF_Client_IsActive] DEFAULT (1) FOR [IsActive],
	CONSTRAINT [CK_Client_Balance] CHECK ([Balance] >= 0),
	CONSTRAINT [CK_Client_CreditLimit] CHECK ([CreditLimit] >= 0)
GO
 CREATE  INDEX [IX_Client_Company] ON [dbo].[Client]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_Client_CompanyCountry] ON [dbo].[Client]([CompanyId], [CountryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientContact] ADD 
	CONSTRAINT [DF_ClientContact_IsActive] DEFAULT (1) FOR [IsActive],
	CONSTRAINT [CK_ClientContact_Birthday] CHECK ([Birthday] < getdate())
GO
 CREATE  INDEX [IX_ClientContact_Company] ON [dbo].[ClientContact]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ClientContact_CompanyClient] ON [dbo].[ClientContact]([CompanyId], [ClientId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientDocDetail] ADD 
	CONSTRAINT [DF_DocumentDet_Tax] DEFAULT (0) FOR [Tax],
	CONSTRAINT [DF_DocumentDet_Discount] DEFAULT (0) FOR [Discount],
	CONSTRAINT [CK_ClientDocDetail_Discount] CHECK ([Discount] >= 0),
	CONSTRAINT [CK_ClientDocDetail_Quantity] CHECK ([Quantity] > 0),
	CONSTRAINT [CK_ClientDocDetail_Tax] CHECK ([Tax] >= 0),
	CONSTRAINT [CK_ClientDocDetail_UnitPrice] CHECK ([UnitPrice] > 0)
GO
 CREATE  INDEX [IX_ClientDocDetail_Company] ON [dbo].[ClientDocDetail]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientDocument] ADD 
	CONSTRAINT [DF_Document_Commission] DEFAULT (0) FOR [Commission],
	CONSTRAINT [DF_ClientDocument_IsCommissionPaid] DEFAULT (0) FOR [CommissionPaid],
	CONSTRAINT [DF_Document_OtherCost] DEFAULT (0) FOR [OtherCost],
	CONSTRAINT [DF_Document_Discount] DEFAULT (0) FOR [Discount],
	CONSTRAINT [DF_Document_Tax] DEFAULT (0) FOR [Tax],
	CONSTRAINT [CK_ClientDocument_Amount] CHECK ([Amount] > 0),
	CONSTRAINT [CK_ClientDocument_Commission] CHECK ([Commission] >= 0),
	CONSTRAINT [CK_ClientDocument_Discount] CHECK ([Discount] >= 0),
	CONSTRAINT [CK_ClientDocument_ExchangeRate] CHECK ([ExchangeRate] > 0),
	CONSTRAINT [CK_ClientDocument_OtherCost] CHECK ([OtherCost] >= 0),
	CONSTRAINT [CK_ClientDocument_Tax] CHECK ([Tax] >= 0)
GO
 CREATE  INDEX [IX_ClientDocument_Company] ON [dbo].[ClientDocument]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ClientDocument_CompanyClient] ON [dbo].[ClientDocument]([CompanyId],[ClientId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientPayment] ADD 
	CONSTRAINT [CK_ClientPayment_Amount] CHECK ([Amount] > 0),
	CONSTRAINT [CK_ClientPayment_ExchangeRate] CHECK ([ExchangeRate] > 0)
GO
 CREATE  INDEX [IX_ClientPayment_Company] ON [dbo].[ClientPayment]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ClientPayment_CompanyClient] ON [dbo].[ClientPayment]([CompanyId],[ClientId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Commission] ADD 
	CONSTRAINT [CK_Commission_Amount] CHECK ([Amount] > 0),
	CONSTRAINT [CK_Commission_ExchangeRate] CHECK ([ExchangeRate] > 0)
GO
 CREATE  INDEX [IX_Commission_Company] ON [dbo].[Commission]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_Commission_CompanyEmployee] ON [dbo].[Commission]([CompanyId],[EmployeeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Product] ADD 
	CONSTRAINT [DF_Product_UnitsInStock] DEFAULT (0) FOR [UnitsInStock],
	CONSTRAINT [DF_Product_IsActive] DEFAULT (1) FOR [IsActive],
	CONSTRAINT [CK_Product_UnitPrice] CHECK ([UnitPrice] >= 0),
	CONSTRAINT [CK_Product_UnitsInStock] CHECK ([UnitsInStock] >= 0)
GO
 CREATE  INDEX [IX_Product_Company] ON [dbo].[Product]([CompanyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Provider] ADD 
	CONSTRAINT [DF_Provider_CreditLimit] DEFAULT (0) FOR [CreditLimit],
	CONSTRAINT [DF_Provider_Balance] DEFAULT (0) FOR [Balance],
	CONSTRAINT [DF_Provider_IsActive] DEFAULT (1) FOR [IsActive],
	CONSTRAINT [CK_Provider_Balance] CHECK ([Balance] >= 0),
	CONSTRAINT [CK_Provider_CreditLimit] CHECK ([CreditLimit] >= 0)
GO
 CREATE  INDEX [IX_Provider_Company] ON [dbo].[Provider]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_Provider_CompanyCountry] ON [dbo].[Provider]([CompanyId], [CountryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProviderContact] ADD 
	CONSTRAINT [DF_ProviderContact_IsActive] DEFAULT (1) FOR [IsActive],
	CONSTRAINT [CK_ProviderContact_Birthday] CHECK ([Birthday] < getdate())
GO
 CREATE  INDEX [IX_ProviderContact_Company] ON [dbo].[ProviderContact]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ProviderContact_CompanyProvider] ON [dbo].[ProviderContact]([CompanyId], [ProviderId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProviderDocument] ADD 
	CONSTRAINT [DF_ProviderDoc_OtherCost] DEFAULT (0) FOR [OtherCost],
	CONSTRAINT [DF_ProviderDoc_Discount] DEFAULT (0) FOR [Discount],
	CONSTRAINT [DF_ProviderDoc_Tax] DEFAULT (0) FOR [Tax],
	CONSTRAINT [CK_ProviderDocument_Amount] CHECK ([Amount] > 0),
	CONSTRAINT [CK_ProviderDocument_Discount] CHECK ([Discount] >= 0),
	CONSTRAINT [CK_ProviderDocument_ExchangeRate] CHECK ([ExchangeRate] > 0),
	CONSTRAINT [CK_ProviderDocument_OtherCost] CHECK ([OtherCost] >= 0),
	CONSTRAINT [CK_ProviderDocument_Tax] CHECK ([Tax] >= 0)
GO
 CREATE  INDEX [IX_ProviderDocument_Company] ON [dbo].[ProviderDocument]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ProviderDocument_CompanyProvider] ON [dbo].[ProviderDocument]([CompanyId],[ProviderId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProviderPayment] ADD 
	CONSTRAINT [CK_ProviderPayment_Amount] CHECK ([Amount] > 0),
	CONSTRAINT [CK_ProviderPayment_ExchangeRate] CHECK ([ExchangeRate] > 0)
GO
 CREATE  INDEX [IX_ProviderPayment_Company] ON [dbo].[ProviderPayment]([CompanyId]) ON [PRIMARY]
GO
 CREATE  INDEX [IX_ProviderPayment_CompanyProvider] ON [dbo].[ProviderPayment]([CompanyId],[ProviderId]) ON [PRIMARY]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE ON [dbo].[Country]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Country]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[State]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[State]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Company]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Company]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ClientDocType]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ClientDocType]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Department]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Department]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[DocumentStatus]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[DocumentStatus]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[EmployeeProfile]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[EmployeeProfile]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ExchangeRate]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ExchangeRate]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[MoneyType]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[MoneyType]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[PaymentType]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[PaymentType]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ProductType]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ProductType]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ProviderDocType]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ProviderDocType]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[UserInfo]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[UserInfo]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Warehouse]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Warehouse]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Employee]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Employee]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Client]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Client]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ClientContact]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ClientContact]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ClientDocDetail]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ClientDocDetail]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ClientDocument]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ClientDocument]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ClientPayment]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ClientPayment]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Commission]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Commission]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Product]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Product]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[Provider]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[Provider]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ProviderContact]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ProviderContact]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ProviderDocument]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ProviderDocument]  TO [profit_role_datareader]
GO
GRANT  SELECT, UPDATE, INSERT, DELETE  ON [dbo].[ProviderPayment]  TO [profit_role_fullaccess]
GO
GRANT  SELECT  ON [dbo].[ProviderPayment]  TO [profit_role_datareader]
GO
ALTER TABLE [dbo].[State] ADD 
	CONSTRAINT [FK_State_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	)
GO
ALTER TABLE [dbo].[Company] ADD 
	CONSTRAINT [FK_Company_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	),
	CONSTRAINT [FK_Company_State] FOREIGN KEY 
	(
		[StateId]
	) REFERENCES [dbo].[State] (
		[StateId]
	)
GO
ALTER TABLE [dbo].[ClientDocType] ADD 
	CONSTRAINT [FK_ClientDocType_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[Department] ADD 
	CONSTRAINT [FK_Department_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[DocumentStatus] ADD 
	CONSTRAINT [FK_DocumentStatus_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[EmployeeProfile] ADD 
	CONSTRAINT [FK_EmployeeProfile_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[ExchangeRate] ADD 
	CONSTRAINT [FK_ExchangeRate_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[MoneyType] ADD 
	CONSTRAINT [FK_MoneyType_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[PaymentType] ADD 
	CONSTRAINT [FK_PaymentType_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[ProductType] ADD 
	CONSTRAINT [FK_ProductType_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[ProviderDocType] ADD 
	CONSTRAINT [FK_ProviderDocType_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[UserInfo] ADD 
	CONSTRAINT [FK_UserInfo_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[Warehouse] ADD 
	CONSTRAINT [FK_Warehouse_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	)
GO
ALTER TABLE [dbo].[Employee] ADD 
	CONSTRAINT [FK_Employee_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_Employee_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	),
	CONSTRAINT [FK_Employee_Department] FOREIGN KEY 
	(
		[DepartmentId]
	) REFERENCES [dbo].[Department] (
		[DepartmentId]
	),
	CONSTRAINT [FK_Employee_EmployeeProfile] FOREIGN KEY 
	(
		[EmployeeProfileId]
	) REFERENCES [dbo].[EmployeeProfile] (
		[EmployeeProfileId]
	),
	CONSTRAINT [FK_Employee_State] FOREIGN KEY 
	(
		[StateId]
	) REFERENCES [dbo].[State] (
		[StateId]
	)
GO
ALTER TABLE [dbo].[Client] ADD 
	CONSTRAINT [FK_Client_ClientContact] FOREIGN KEY 
	(
		[PrimaryContactId]
	) REFERENCES [dbo].[ClientContact] (
		[ContactId]
	),
	CONSTRAINT [FK_Client_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_Client_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	),
	CONSTRAINT [FK_Client_State] FOREIGN KEY 
	(
		[StateId]
	) REFERENCES [dbo].[State] (
		[StateId]
	)
GO
ALTER TABLE [dbo].[ClientContact] ADD 
	CONSTRAINT [FK_ClientContact_Client] FOREIGN KEY 
	(
		[ClientId]
	) REFERENCES [dbo].[Client] (
		[ClientId]
	),
	CONSTRAINT [FK_ClientContact_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ClientContact_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	),
	CONSTRAINT [FK_ClientContact_State] FOREIGN KEY 
	(
		[StateId]
	) REFERENCES [dbo].[State] (
		[StateId]
	)
GO
ALTER TABLE [dbo].[ClientDocDetail] ADD 
	CONSTRAINT [FK_ClientDocDetail_ClientDocument] FOREIGN KEY 
	(
		[DocumentId]
	) REFERENCES [dbo].[ClientDocument] (
		[DocumentId]
	),
	CONSTRAINT [FK_ClientDocDetail_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ClientDocDetail_Product] FOREIGN KEY 
	(
		[ProductId]
	) REFERENCES [dbo].[Product] (
		[ProductId]
	)
GO
ALTER TABLE [dbo].[ClientDocument] ADD 
	CONSTRAINT [FK_ClientDocument_Client] FOREIGN KEY 
	(
		[ClientId]
	) REFERENCES [dbo].[Client] (
		[ClientId]
	),
	CONSTRAINT [FK_ClientDocument_ClientDocType] FOREIGN KEY 
	(
		[DocTypeId]
	) REFERENCES [dbo].[ClientDocType] (
		[DocTypeId]
	),
	CONSTRAINT [FK_ClientDocument_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ClientDocument_DocumentStatus] FOREIGN KEY 
	(
		[DocumentStatusId]
	) REFERENCES [dbo].[DocumentStatus] (
		[DocumentStatusId]
	),
	CONSTRAINT [FK_ClientDocument_Employee] FOREIGN KEY 
	(
		[EmployeeId]
	) REFERENCES [dbo].[Employee] (
		[EmployeeId]
	),
	CONSTRAINT [FK_ClientDocument_PaymentType] FOREIGN KEY 
	(
		[PaymentTypeId]
	) REFERENCES [dbo].[PaymentType] (
		[PaymentTypeId]
	)
GO
ALTER TABLE [dbo].[ClientPayment] ADD 
	CONSTRAINT [FK_ClientPayment_Client] FOREIGN KEY 
	(
		[ClientId]
	) REFERENCES [dbo].[Client] (
		[ClientId]
	),
	CONSTRAINT [FK_ClientPayment_ClientDocument_Credit] FOREIGN KEY 
	(
		[CreditDocumentId]
	) REFERENCES [dbo].[ClientDocument] (
		[DocumentId]
	),
	CONSTRAINT [FK_ClientPayment_ClientDocument_Debit] FOREIGN KEY 
	(
		[DebitDocumentId]
	) REFERENCES [dbo].[ClientDocument] (
		[DocumentId]
	),
	CONSTRAINT [FK_ClientPayment_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ClientPayment_MoneyType] FOREIGN KEY 
	(
		[MoneyTypeId]
	) REFERENCES [dbo].[MoneyType] (
		[MoneyTypeId]
	)
GO
ALTER TABLE [dbo].[Commission] ADD 
	CONSTRAINT [FK_Commission_ClientDocument] FOREIGN KEY 
	(
		[DocumentId]
	) REFERENCES [dbo].[ClientDocument] (
		[DocumentId]
	),
	CONSTRAINT [FK_Commission_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_Commission_Employee] FOREIGN KEY 
	(
		[EmployeeId]
	) REFERENCES [dbo].[Employee] (
		[EmployeeId]
	)
GO
ALTER TABLE [dbo].[Product] ADD 
	CONSTRAINT [FK_Product_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_Product_ProductType] FOREIGN KEY 
	(
		[ProductTypeId]
	) REFERENCES [dbo].[ProductType] (
		[ProductTypeId]
	),
	CONSTRAINT [FK_Product_Provider] FOREIGN KEY 
	(
		[ProviderId]
	) REFERENCES [dbo].[Provider] (
		[ProviderId]
	),
	CONSTRAINT [FK_Product_Warehouse] FOREIGN KEY 
	(
		[WarehouseId]
	) REFERENCES [dbo].[Warehouse] (
		[WarehouseId]
	)
GO
ALTER TABLE [dbo].[Provider] ADD 
	CONSTRAINT [FK_Provider_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_Provider_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	),
	CONSTRAINT [FK_Provider_ProviderContact] FOREIGN KEY 
	(
		[PrimaryContactId]
	) REFERENCES [dbo].[ProviderContact] (
		[ContactId]
	),
	CONSTRAINT [FK_Provider_State] FOREIGN KEY 
	(
		[StateId]
	) REFERENCES [dbo].[State] (
		[StateId]
	)
GO
ALTER TABLE [dbo].[ProviderContact] ADD 
	CONSTRAINT [FK_ProviderContact_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ProviderContact_Country] FOREIGN KEY 
	(
		[CountryId]
	) REFERENCES [dbo].[Country] (
		[CountryId]
	),
	CONSTRAINT [FK_ProviderContact_Provider] FOREIGN KEY 
	(
		[ProviderId]
	) REFERENCES [dbo].[Provider] (
		[ProviderId]
	),
	CONSTRAINT [FK_ProviderContact_State] FOREIGN KEY 
	(
		[StateId]
	) REFERENCES [dbo].[State] (
		[StateId]
	)
GO
ALTER TABLE [dbo].[ProviderDocument] ADD 
	CONSTRAINT [FK_ProviderDocument_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ProviderDocument_DocumentStatus] FOREIGN KEY 
	(
		[DocumentStatusId]
	) REFERENCES [dbo].[DocumentStatus] (
		[DocumentStatusId]
	),
	CONSTRAINT [FK_ProviderDocument_PaymentType] FOREIGN KEY 
	(
		[PaymentTypeId]
	) REFERENCES [dbo].[PaymentType] (
		[PaymentTypeId]
	),
	CONSTRAINT [FK_ProviderDocument_Provider] FOREIGN KEY 
	(
		[ProviderId]
	) REFERENCES [dbo].[Provider] (
		[ProviderId]
	),
	CONSTRAINT [FK_ProviderDocument_ProviderDocType] FOREIGN KEY 
	(
		[DocTypeId]
	) REFERENCES [dbo].[ProviderDocType] (
		[DocTypeId]
	)
GO
ALTER TABLE [dbo].[ProviderPayment] ADD 
	CONSTRAINT [FK_ProviderPayment_Company] FOREIGN KEY 
	(
		[CompanyId]
	) REFERENCES [dbo].[Company] (
		[CompanyId]
	),
	CONSTRAINT [FK_ProviderPayment_MoneyType] FOREIGN KEY 
	(
		[MoneyTypeId]
	) REFERENCES [dbo].[MoneyType] (
		[MoneyTypeId]
	),
	CONSTRAINT [FK_ProviderPayment_Provider] FOREIGN KEY 
	(
		[ProviderId]
	) REFERENCES [dbo].[Provider] (
		[ProviderId]
	),
	CONSTRAINT [FK_ProviderPayment_ProviderDocument_Credit] FOREIGN KEY 
	(
		[CreditDocumentId]
	) REFERENCES [dbo].[ProviderDocument] (
		[DocumentId]
	),
	CONSTRAINT [FK_ProviderPayment_ProviderDocument_Debit] FOREIGN KEY 
	(
		[DebitDocumentId]
	) REFERENCES [dbo].[ProviderDocument] (
		[DocumentId]
	)
GO
SET QUOTED_IdENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Country
AS
SELECT     CountryId, Name, USER_NAME(InsertUser) AS InsertUser, InsertDate, USER_NAME(LastUpdateUser) AS LastUpdateUser, LastUpdateDate, 
                      RowInfo
FROM         dbo.Country
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Country]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_State
AS
SELECT     dbo.State.StateId, dbo.State.CountryId, dbo.Country.Name AS Country, dbo.State.Name, USER_NAME(dbo.State.InsertUser) 
                      AS InsertUser, dbo.State.InsertDate, USER_NAME(dbo.State.LastUpdateUser) AS LastUpdateUser, dbo.State.LastUpdateDate, dbo.State.RowInfo
FROM         dbo.State INNER JOIN
                      dbo.Country ON dbo.State.CountryId = dbo.Country.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_State]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Company
AS
SELECT     dbo.Company.CompanyId, dbo.Company.Name, dbo.Company.Address, dbo.Company.City, dbo.Company.StateId, 
                      dbo.Company.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.Company.PostalCode, dbo.Company.Phone, dbo.Company.Fax, 
                      dbo.Company.Website, dbo.Company.EmailAddress, dbo.Company.Tax, dbo.Company.Discount, dbo.Company.MultipleCurrency, 
                      dbo.Company.Culture, dbo.Company.LocalSign, dbo.Company.ForeignSign, dbo.Company.LocalName, dbo.Company.ForeignName, 
                      USER_NAME(dbo.Company.InsertUser) AS InsertUser, dbo.Company.InsertDate, USER_NAME(dbo.Company.LastUpdateUser) AS LastUpdateUser, 
                      dbo.Company.LastUpdateDate, dbo.Company.RowInfo
FROM         dbo.Company INNER JOIN
                      dbo.Country ON dbo.Company.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.Company.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Company]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.profit_vw_ClientDocType
AS
SELECT     dbo.ClientDocType.DocTypeId, dbo.ClientDocType.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ClientDocType.Name, dbo.ClientDocType.IsDebit, USER_NAME(dbo.ClientDocType.InsertUser) AS InsertUser, 
                      dbo.ClientDocType.InsertDate, USER_NAME(dbo.ClientDocType.LastUpdateUser) AS LastUpdateUser, dbo.ClientDocType.LastUpdateDate, 
                      dbo.ClientDocType.RowInfo
FROM         dbo.ClientDocType INNER JOIN
                      dbo.Company ON dbo.ClientDocType.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ClientDocType]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Department
AS
SELECT     dbo.Department.CompanyId, dbo.Department.DepartmentId, dbo.Company.Name AS Company, dbo.Department.Name, 
                      dbo.Department.Location, USER_NAME(dbo.Department.InsertUser) AS InsertUser, dbo.Department.InsertDate, 
                      USER_NAME(dbo.Department.LastUpdateUser) AS LastUpdateUser, dbo.Department.LastUpdateDate, dbo.Department.RowInfo
FROM         dbo.Department INNER JOIN
                      dbo.Company ON dbo.Department.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Department]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_DocumentStatus
AS
SELECT     dbo.DocumentStatus.DocumentStatusId, dbo.DocumentStatus.CompanyId, dbo.Company.Name AS Company, 
                      dbo.DocumentStatus.Name, USER_NAME(dbo.DocumentStatus.InsertUser) AS InsertUser, dbo.DocumentStatus.InsertDate, 
                      USER_NAME(dbo.DocumentStatus.LastUpdateUser) AS LastUpdateUser, dbo.DocumentStatus.LastUpdateDate, dbo.DocumentStatus.RowInfo
FROM         dbo.DocumentStatus INNER JOIN
                      dbo.Company ON dbo.DocumentStatus.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_DocumentStatus]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_EmployeeProfile
AS
SELECT     dbo.EmployeeProfile.EmployeeProfileId, dbo.EmployeeProfile.CompanyId, dbo.Company.Name AS Company, 
                      dbo.EmployeeProfile.Name, dbo.EmployeeProfile.Commission, USER_NAME(dbo.EmployeeProfile.InsertUser) AS InsertUser, 
                      dbo.EmployeeProfile.InsertDate, USER_NAME(dbo.EmployeeProfile.LastUpdateUser) AS LastUpdateUser, dbo.EmployeeProfile.LastUpdateDate, 
                      dbo.EmployeeProfile.RowInfo
FROM         dbo.EmployeeProfile INNER JOIN
                      dbo.Company ON dbo.EmployeeProfile.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_EmployeeProfile]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ExchangeRate
AS
SELECT     dbo.ExchangeRate.ExchangeRateId, dbo.ExchangeRate.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ExchangeRate.RefreshDate, dbo.ExchangeRate.Amount, USER_NAME(dbo.ExchangeRate.InsertUser) AS InsertUser, 
                      dbo.ExchangeRate.InsertDate, USER_NAME(dbo.ExchangeRate.LastUpdateUser) AS LastUpdateUser, dbo.ExchangeRate.LastUpdateDate, 
                      dbo.ExchangeRate.RowInfo
FROM         dbo.ExchangeRate INNER JOIN
                      dbo.Company ON dbo.ExchangeRate.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ExchangeRate]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_MoneyType
AS
SELECT     dbo.MoneyType.MoneyTypeId, dbo.MoneyType.CompanyId, dbo.Company.Name AS Company, dbo.MoneyType.Name, 
                      USER_NAME(dbo.MoneyType.InsertUser) AS InsertUser, dbo.MoneyType.InsertDate, USER_NAME(dbo.MoneyType.LastUpdateUser) AS LastUpdateUser, 
                      dbo.MoneyType.LastUpdateDate, dbo.MoneyType.RowInfo
FROM         dbo.MoneyType INNER JOIN
                      dbo.Company ON dbo.MoneyType.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_MoneyType]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_PaymentType
AS
SELECT     dbo.PaymentType.PaymentTypeId, dbo.PaymentType.CompanyId, dbo.Company.Name AS Company, 
                      dbo.PaymentType.Name, dbo.PaymentType.Period, USER_NAME(dbo.PaymentType.InsertUser) AS InsertUser, dbo.PaymentType.InsertDate, 
                      USER_NAME(dbo.PaymentType.LastUpdateUser) AS LastUpdateUser, dbo.PaymentType.LastUpdateDate, dbo.PaymentType.RowInfo
FROM         dbo.PaymentType INNER JOIN
                      dbo.Company ON dbo.PaymentType.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_PaymentType]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ProductType
AS
SELECT     dbo.ProductType.ProductTypeId, dbo.ProductType.CompanyId, dbo.Company.Name AS Company, dbo.ProductType.Name, 
                      USER_NAME(dbo.ProductType.InsertUser) AS InsertUser, dbo.ProductType.InsertDate, USER_NAME(dbo.ProductType.LastUpdateUser) AS LastUpdateUser, 
                      dbo.ProductType.LastUpdateDate, dbo.ProductType.RowInfo
FROM         dbo.ProductType INNER JOIN
                      dbo.Company ON dbo.ProductType.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ProductType]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ProviderDocType
AS
SELECT     dbo.ProviderDocType.DocTypeId, dbo.ProviderDocType.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderDocType.Name, dbo.ProviderDocType.IsDebit, USER_NAME(dbo.ProviderDocType.InsertUser) AS InsertUser, 
                      dbo.ProviderDocType.InsertDate, USER_NAME(dbo.ProviderDocType.LastUpdateUser) AS LastUpdateUser, dbo.ProviderDocType.LastUpdateDate,
                      dbo.ProviderDocType.RowInfo
FROM         dbo.ProviderDocType INNER JOIN
                      dbo.Company ON dbo.ProviderDocType.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ProviderDocType]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_UserInfo
AS
SELECT     dbo.UserInfo.UserInfoId, dbo.UserInfo.CompanyId, dbo.Company.Name AS Company, dbo.UserInfo.FirstName, dbo.UserInfo.LastName, 
                      dbo.UserInfo.SidName, dbo.UserInfo.Culture, dbo.UserInfo.Role, USER_NAME(dbo.UserInfo.InsertUser) AS InsertUser, dbo.UserInfo.InsertDate, 
                      USER_NAME(dbo.UserInfo.LastUpdateUser) AS LastUpdateUser, dbo.UserInfo.LastUpdateDate, dbo.UserInfo.RowInfo
FROM         dbo.UserInfo INNER JOIN
                      dbo.Company ON dbo.UserInfo.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_UserInfo]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Warehouse
AS
SELECT     dbo.Warehouse.WarehouseId, dbo.Warehouse.CompanyId, dbo.Company.Name AS Company, dbo.Warehouse.Name, 
                      dbo.Warehouse.Location, USER_NAME(dbo.Warehouse.InsertUser) AS InsertUser, dbo.Warehouse.InsertDate, 
                      USER_NAME(dbo.Warehouse.LastUpdateUser) AS LastUpdateUser, dbo.Warehouse.LastUpdateDate, dbo.Warehouse.RowInfo
FROM         dbo.Warehouse INNER JOIN
                      dbo.Company ON dbo.Warehouse.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Warehouse]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Employee
AS
SELECT     dbo.Employee.EmployeeId, dbo.Employee.CompanyId, dbo.Employee.DepartmentId, dbo.Employee.EmployeeProfileId, 
                      dbo.Company.Name AS Company, dbo.Department.Name AS Department, dbo.EmployeeProfile.Name AS EmployeeProfile, dbo.Employee.FirstName, 
                      dbo.Employee.LastName, dbo.Employee.Title, dbo.Employee.IdNumber, dbo.Employee.Address, dbo.Employee.City, dbo.Employee.StateId, 
                      dbo.Employee.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.Employee.Gender, dbo.Employee.PostalCode, 
                      dbo.Employee.Phone, dbo.Employee.Fax, dbo.Employee.MobilePhone, dbo.Employee.EmailAddress, dbo.Employee.Birthday, dbo.Employee.IsActive, 
                      dbo.Employee.MaritalStatus, dbo.Employee.DateHired, dbo.Employee.Deductions, dbo.Employee.Salary, dbo.Employee.ContactName, 
                      dbo.Employee.ContactPhone, USER_NAME(dbo.Employee.InsertUser) AS InsertUser, dbo.Employee.InsertDate, 
                      USER_NAME(dbo.Employee.LastUpdateUser) AS LastUpdateUser, dbo.Employee.LastUpdateDate, dbo.Employee.RowInfo
FROM         dbo.Employee INNER JOIN
                      dbo.Company ON dbo.Employee.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Department ON dbo.Employee.DepartmentId = dbo.Department.DepartmentId AND 
                      dbo.Company.CompanyId = dbo.Department.CompanyId INNER JOIN
                      dbo.EmployeeProfile ON dbo.Employee.EmployeeProfileId = dbo.EmployeeProfile.EmployeeProfileId AND 
                      dbo.Company.CompanyId = dbo.EmployeeProfile.CompanyId INNER JOIN
                      dbo.State ON dbo.Employee.StateId = dbo.State.StateId INNER JOIN
                      dbo.Country ON dbo.Employee.CountryId = dbo.Country.CountryId AND dbo.State.CountryId = dbo.Country.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Employee]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Client
AS
SELECT     dbo.Client.ClientId, dbo.Client.CompanyId, dbo.Company.Name AS Company, dbo.Client.Name, dbo.Client.Address, dbo.Client.City, 
                      dbo.Client.StateId, dbo.Client.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.Client.PrimaryContactId, dbo.Client.PostalCode, 
                      dbo.Client.Phone, dbo.Client.Fax, dbo.Client.Website, dbo.Client.EmailAddress, dbo.Client.CreditLimit, dbo.Client.Balance, dbo.Client.IsActive, 
                      USER_NAME(dbo.Client.InsertUser) AS InsertUser, dbo.Client.InsertDate, USER_NAME(dbo.Client.LastUpdateUser) AS LastUpdateUser, dbo.Client.LastUpdateDate, 
                      dbo.Client.RowInfo
FROM         dbo.Client INNER JOIN
                      dbo.Company ON dbo.Client.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.Client.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.Client.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Client]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ClientContact
AS
SELECT     dbo.ClientContact.ContactId, dbo.ClientContact.ClientId, dbo.ClientContact.CompanyId, dbo.Company.Name AS Company, dbo.ClientContact.FirstName, 
                      dbo.ClientContact.LastName, dbo.ClientContact.Title, dbo.ClientContact.IdNumber, dbo.ClientContact.Address, dbo.ClientContact.City, 
                      dbo.ClientContact.StateId, dbo.ClientContact.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, dbo.ClientContact.Gender, 
                      dbo.ClientContact.PostalCode, dbo.ClientContact.Phone, dbo.ClientContact.Fax, dbo.ClientContact.MobilePhone, dbo.ClientContact.EmailAddress, 
                      dbo.ClientContact.Birthday, dbo.ClientContact.IsActive, USER_NAME(dbo.ClientContact.InsertUser) AS InsertUser, dbo.ClientContact.InsertDate, 
                      USER_NAME(dbo.ClientContact.LastUpdateUser) AS LastUpdateUser, dbo.ClientContact.LastUpdateDate, dbo.ClientContact.RowInfo
FROM         dbo.ClientContact INNER JOIN
                      dbo.Company ON dbo.ClientContact.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.ClientContact.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.ClientContact.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ClientContact]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ClientDocDetail
AS
SELECT     dbo.ClientDocDetail.DocumentId, dbo.ClientDocDetail.ProductId, dbo.ClientDocDetail.CompanyId, 
                      dbo.Company.Name AS Company, dbo.Product.Name AS Product, dbo.ClientDocDetail.Quantity, dbo.ClientDocDetail.Tax, 
                      dbo.ClientDocDetail.Discount, dbo.ClientDocDetail.UnitPrice, dbo.ClientDocDetail.RowInfo
FROM         dbo.ClientDocDetail INNER JOIN
                      dbo.Company ON dbo.ClientDocDetail.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Product ON dbo.ClientDocDetail.ProductId = dbo.Product.ProductId AND dbo.Company.CompanyId = dbo.Product.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ClientDocDetail]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ClientDocument
AS
SELECT     dbo.ClientDocument.DocumentId, dbo.ClientDocument.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ClientDocument.DocTypeId, dbo.ClientDocument.DocumentStatusId, dbo.ClientDocument.ClientId, dbo.ClientDocument.EmployeeId, 
                      dbo.ClientDocument.PaymentTypeId, dbo.ClientDocType.Name AS DocType, dbo.DocumentStatus.Name AS Status, dbo.Client.Name AS Client, 
                      dbo.PaymentType.Name AS PaymentType, dbo.Employee.LastName + ', ' + dbo.Employee.FirstName AS Employee, dbo.ClientDocument.Commission, 
                      dbo.ClientDocument.CommissionPaid, dbo.ClientDocument.DocConsecutive, dbo.ClientDocument.DocDate, dbo.ClientDocument.OtherCost, 
                      dbo.ClientDocument.Discount, dbo.ClientDocument.Tax, dbo.ClientDocument.Amount, dbo.ClientDocument.Remarks, 
                      dbo.ClientDocument.ExchangeRate, USER_NAME(dbo.ClientDocument.InsertUser) AS InsertUser, dbo.ClientDocument.InsertDate, 
                      USER_NAME(dbo.ClientDocument.LastUpdateUser) AS LastUpdateUser, dbo.ClientDocument.LastUpdateDate, dbo.ClientDocument.RowInfo
FROM         dbo.ClientDocument INNER JOIN
                      dbo.ClientDocType ON dbo.ClientDocument.DocTypeId = dbo.ClientDocType.DocTypeId INNER JOIN
                      dbo.DocumentStatus ON dbo.ClientDocument.DocumentStatusId = dbo.DocumentStatus.DocumentStatusId INNER JOIN
                      dbo.Client ON dbo.ClientDocument.ClientId = dbo.Client.ClientId INNER JOIN
                      dbo.PaymentType ON dbo.ClientDocument.PaymentTypeId = dbo.PaymentType.PaymentTypeId INNER JOIN
                      dbo.Employee ON dbo.ClientDocument.EmployeeId = dbo.Employee.EmployeeId INNER JOIN
                      dbo.Company ON dbo.ClientDocument.CompanyId = dbo.Company.CompanyId AND dbo.ClientDocType.CompanyId = dbo.Company.CompanyId AND 
                      dbo.Client.CompanyId = dbo.Company.CompanyId AND dbo.DocumentStatus.CompanyId = dbo.Company.CompanyId AND 
                      dbo.Employee.CompanyId = dbo.Company.CompanyId AND dbo.PaymentType.CompanyId = dbo.Company.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ClientDocument]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ClientPayment
AS
SELECT     dbo.ClientPayment.ClientPaymentId, dbo.ClientPayment.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ClientPayment.ClientId, dbo.Client.Name AS Client, dbo.ClientPayment.CreditDocumentId, dbo.ClientPayment.DebitDocumentId, 
                      dbo.ClientPayment.MoneyTypeId, dbo.MoneyType.Name AS MoneyType, dbo.ClientPayment.PaymentDate, dbo.ClientPayment.Amount, 
                      dbo.ClientPayment.Remarks, dbo.ClientPayment.ExchangeRate, USER_NAME(dbo.ClientPayment.InsertUser) AS InsertUser, 
                      dbo.ClientPayment.InsertDate, USER_NAME(dbo.ClientPayment.LastUpdateUser) AS LastUpdateUser, dbo.ClientPayment.LastUpdateDate,
                      dbo.ClientPayment.RowInfo
FROM         dbo.ClientPayment INNER JOIN
                      dbo.Company ON dbo.ClientPayment.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Client ON dbo.ClientPayment.ClientId = dbo.Client.ClientId AND dbo.Company.CompanyId = dbo.Client.CompanyId INNER JOIN
                      dbo.MoneyType ON dbo.ClientPayment.MoneyTypeId = dbo.MoneyType.MoneyTypeId AND 
                      dbo.Company.CompanyId = dbo.MoneyType.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ClientPayment]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Commission
AS
SELECT     dbo.Commission.CommissionId, dbo.Commission.CompanyId, dbo.Company.Name AS Company, dbo.Commission.EmployeeId, 
                      dbo.Employee.LastName AS EmployeeLN, dbo.Employee.FirstName AS EmployeeFN, dbo.Commission.DocumentId, dbo.ClientDocument.Amount AS DocAmount, 
                      dbo.Commission.DocDate, dbo.Commission.Amount, dbo.Commission.ExchangeRate, USER_NAME(dbo.Commission.InsertUser) AS InsertUser, 
                      dbo.Commission.InsertDate, USER_NAME(dbo.Commission.LastUpdateUser) AS LastUpdateUser, dbo.Commission.LastUpdateDate,
                      dbo.Commission.RowInfo
FROM         dbo.Commission INNER JOIN
                      dbo.Company ON dbo.Commission.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Employee ON dbo.Commission.EmployeeId = dbo.Employee.EmployeeId AND dbo.Company.CompanyId = dbo.Employee.CompanyId INNER JOIN
                      dbo.ClientDocument ON dbo.Commission.DocumentId = dbo.ClientDocument.DocumentId AND 
                      dbo.Company.CompanyId = dbo.ClientDocument.CompanyId AND dbo.Employee.EmployeeId = dbo.ClientDocument.EmployeeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Commission]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Product
AS
SELECT     dbo.Product.ProductId, dbo.Product.CompanyId, dbo.Company.Name AS Company, dbo.Product.ProductTypeId, 
                      dbo.Product.ProviderId, dbo.Product.WarehouseId, dbo.ProductType.Name AS ProductType, dbo.Provider.Name AS Provider, 
                      dbo.Warehouse.Name AS Warehouse, dbo.Product.Name, dbo.Product.UnitsInStock, dbo.Product.UnitPrice, dbo.Product.IsActive, 
                      USER_NAME(dbo.Product.InsertUser) AS InsertUser, dbo.Product.InsertDate, USER_NAME(dbo.Product.LastUpdateUser) AS LastUpdateUser, 
                      dbo.Product.LastUpdateDate, dbo.Product.RowInfo
FROM         dbo.Product INNER JOIN
                      dbo.Company ON dbo.Product.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.ProductType ON dbo.Product.ProductTypeId = dbo.ProductType.ProductTypeId AND 
                      dbo.Company.CompanyId = dbo.ProductType.CompanyId INNER JOIN
                      dbo.Provider ON dbo.Product.ProviderId = dbo.Provider.ProviderId AND dbo.Company.CompanyId = dbo.Provider.CompanyId INNER JOIN
                      dbo.Warehouse ON dbo.Product.WarehouseId = dbo.Warehouse.WarehouseId AND dbo.Company.CompanyId = dbo.Warehouse.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Product]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_Provider
AS
SELECT     dbo.Provider.ProviderId, dbo.Provider.CompanyId, dbo.Company.Name AS Company, dbo.Provider.Name, dbo.Provider.Address, 
                      dbo.Provider.City, dbo.Provider.StateId, dbo.Provider.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, 
                      dbo.Provider.PrimaryContactId, dbo.Provider.PostalCode, dbo.Provider.Phone, dbo.Provider.Fax, dbo.Provider.Website, dbo.Provider.EmailAddress, 
                      dbo.Provider.CreditLimit, dbo.Provider.Balance, dbo.Provider.IsActive, USER_NAME(dbo.Provider.InsertUser) AS InsertUser, dbo.Provider.InsertDate, 
                      USER_NAME(dbo.Provider.LastUpdateUser) AS LastUpdateUser, dbo.Provider.LastUpdateDate, dbo.Provider.RowInfo
FROM         dbo.Provider INNER JOIN
                      dbo.Company ON dbo.Provider.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.Provider.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.Provider.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_Provider]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ProviderContact
AS
SELECT     dbo.ProviderContact.ContactId, dbo.ProviderContact.ProviderId, dbo.ProviderContact.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderContact.FirstName, dbo.ProviderContact.LastName, dbo.ProviderContact.Title, dbo.ProviderContact.IdNumber, dbo.ProviderContact.Address, 
                      dbo.ProviderContact.City, dbo.ProviderContact.StateId, dbo.ProviderContact.CountryId, dbo.State.Name AS State, dbo.Country.Name AS Country, 
                      dbo.ProviderContact.Gender, dbo.ProviderContact.PostalCode, dbo.ProviderContact.Phone, dbo.ProviderContact.Fax, 
                      dbo.ProviderContact.MobilePhone, dbo.ProviderContact.EmailAddress, dbo.ProviderContact.Birthday, dbo.ProviderContact.IsActive, 
                      USER_NAME(dbo.ProviderContact.InsertUser) AS InsertUser, dbo.ProviderContact.InsertDate, USER_NAME(dbo.ProviderContact.LastUpdateUser) 
                      AS LastUpdateUser, dbo.ProviderContact.LastUpdateDate, dbo.ProviderContact.RowInfo
FROM         dbo.ProviderContact INNER JOIN
                      dbo.Company ON dbo.ProviderContact.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Country ON dbo.ProviderContact.CountryId = dbo.Country.CountryId INNER JOIN
                      dbo.State ON dbo.ProviderContact.StateId = dbo.State.StateId AND dbo.Country.CountryId = dbo.State.CountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ProviderContact]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ProviderDocument
AS
SELECT     dbo.ProviderDocument.DocumentId, dbo.ProviderDocument.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderDocument.DocTypeId, dbo.ProviderDocument.DocumentStatusId, dbo.ProviderDocument.ProviderId, 
                      dbo.ProviderDocument.PaymentTypeId, dbo.ProviderDocType.Name AS DocType, dbo.DocumentStatus.Name AS Status, 
                      dbo.Provider.Name AS Provider, dbo.PaymentType.Name AS PaymentType, dbo.ProviderDocument.DocDate, dbo.ProviderDocument.DocConsecutive, 
                      dbo.ProviderDocument.OtherCost, dbo.ProviderDocument.Discount, dbo.ProviderDocument.Tax, dbo.ProviderDocument.Amount, 
                      dbo.ProviderDocument.Remarks, dbo.ProviderDocument.ExchangeRate, USER_NAME(dbo.ProviderDocument.InsertUser) AS InsertUser, 
                      dbo.ProviderDocument.InsertDate, USER_NAME(dbo.ProviderDocument.LastUpdateUser) AS LastUpdateUser, dbo.ProviderDocument.LastUpdateDate, 
                      dbo.ProviderDocument.RowInfo
FROM         dbo.ProviderDocument INNER JOIN
                      dbo.Company ON dbo.ProviderDocument.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.ProviderDocType ON dbo.ProviderDocument.DocTypeId = dbo.ProviderDocType.DocTypeId AND 
                      dbo.Company.CompanyId = dbo.ProviderDocType.CompanyId INNER JOIN
                      dbo.DocumentStatus ON dbo.ProviderDocument.DocumentStatusId = dbo.DocumentStatus.DocumentStatusId AND 
                      dbo.Company.CompanyId = dbo.DocumentStatus.CompanyId INNER JOIN
                      dbo.PaymentType ON dbo.ProviderDocument.PaymentTypeId = dbo.PaymentType.PaymentTypeId AND 
                      dbo.Company.CompanyId = dbo.PaymentType.CompanyId INNER JOIN
                      dbo.Provider ON dbo.ProviderDocument.ProviderId = dbo.Provider.ProviderId AND dbo.Company.CompanyId = dbo.Provider.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ProviderDocument]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
CREATE VIEW dbo.profit_vw_ProviderPayment
AS
SELECT     dbo.ProviderPayment.ProviderPaymentId, dbo.ProviderPayment.CompanyId, dbo.Company.Name AS Company, 
                      dbo.ProviderPayment.ProviderId, dbo.Provider.Name AS Provider, dbo.ProviderPayment.DebitDocumentId, dbo.ProviderPayment.CreditDocumentId, 
                      dbo.ProviderPayment.MoneyTypeId, dbo.MoneyType.Name AS MoneyType, dbo.ProviderPayment.PaymentDate, dbo.ProviderPayment.Amount, 
                      dbo.ProviderPayment.Remarks, dbo.ProviderPayment.ExchangeRate, USER_NAME(dbo.ProviderPayment.InsertUser) AS InsertUser, 
                      dbo.ProviderPayment.InsertDate, USER_NAME(dbo.ProviderPayment.LastUpdateUser) AS LastUpdateUser, dbo.ProviderPayment.LastUpdateDate,
                      dbo.ProviderPayment.RowInfo
FROM         dbo.ProviderPayment INNER JOIN
                      dbo.Company ON dbo.ProviderPayment.CompanyId = dbo.Company.CompanyId INNER JOIN
                      dbo.Provider ON dbo.ProviderPayment.ProviderId = dbo.Provider.ProviderId AND dbo.Company.CompanyId = dbo.Provider.CompanyId INNER JOIN
                      dbo.MoneyType ON dbo.ProviderPayment.MoneyTypeId = dbo.MoneyType.MoneyTypeId AND 
                      dbo.Company.CompanyId = dbo.MoneyType.CompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  SELECT  ON [dbo].[profit_vw_ProviderPayment]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Country_Delete 
(	@pCountryId int 
 )
AS
	Delete Country
	Where
		[CountryId] = @pCountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Country_Insert 
(	@pCountryId int OUTPUT,
	@pName varchar (50)   
 )
AS
	Insert into Country
		([Name], [InsertUser], [InsertDate])
	Values
		(@pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pCountryId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Country_Read
(	@pCountryId int
 )
AS
	Select
		[CountryId],
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	Country
	Where [CountryId] = @pCountryId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Country_Update 
(	@pCountryId int,
	@pName varchar (50),
	@pRowInfo timestamp
 )
AS
	Update Country
	Set 	
		[Name] = @pName, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[CountryId] = @pCountryId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Country
		Where [CountryId] = @pCountryId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Country_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_State_Delete 
(	@pStateId int
 )
AS
	Delete State
	Where
		[StateId] = @pStateId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_State_Insert 
(	@pStateId int OUTPUT,
	@pCountryId int,
	@pName varchar (50) 
 )
AS
	Insert into State
		([CountryId], [Name], [InsertUser], [InsertDate])
	Values
		(@pCountryId, @pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pStateId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_State_Read
(	@pStateId int
 )
AS
	Select
		[StateId],
		[CountryId],
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	State
	Where [StateId] = @pStateId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_State_Update
(	@pStateId int,
	@pCountryId int,
	@pName varchar (50),
	@pRowInfo timestamp
 )
AS
	Update State
	Set 	
		[CountryId] = @pCountryId,
		[Name] = @pName, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[StateId] = @pStateId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From State
		Where [StateId] = @pStateId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_State_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.profit_sp_Company_Delete 
(	@pCompanyId int
 )
AS
	Delete Company
	Where
		[CompanyId] = @pCompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Company_Insert 
(	@pCompanyId int OUTPUT,
	@pName varchar(50),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pTax money,
	@pDiscount money,
	@pMultipleCurrency bit,
	@pCulture varchar(5),
	@pLocalSign varchar(1),
	@pForeignSign varchar(1),
	@pLocalName varchar(25),
	@pForeignName varchar(25)
 )
AS
	Insert into Company
		([Name], [Address], [City], [StateId], [CountryId], [PostalCode], [Phone], [Fax], [Website], [EmailAddress], [Tax], [Discount], [MultipleCurrency], [Culture], [LocalSign], [ForeignSign], [LocalName], [ForeignName], [InsertUser], [InsertDate])
	Values
		(@pName, @pAddress, @pCity, @pStateId, @pCountryId, @pPostalCode, @pPhone, @pFax, @pWebsite, @pEmailAddress, @pTax, @pDiscount, @pMultipleCurrency, @pCulture, @pLocalSign, @pForeignSign, @pLocalName, @pForeignName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pCompanyId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Company_Read
(	@pCompanyId int
 )
AS
	Select 
		[CompanyId], 
		[Name], 
		[Address], 
		[City],
		[StateId], 
		[CountryId], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[Website], 
		[EmailAddress], 
		[Tax], 
		[Discount], 
		[MultipleCurrency],
		[Culture],
		[LocalSign], 
		[ForeignSign], 
		[LocalName], 
		[ForeignName],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From Company
	Where [CompanyId] = @pCompanyId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Company_Update
(	@pCompanyId int,
	@pName varchar(50),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pTax money,
	@pDiscount money,
	@pMultipleCurrency bit,
	@pCulture varchar(5),
	@pLocalSign varchar(1),
	@pForeignSign varchar(1),
	@pLocalName varchar(25),
	@pForeignName varchar(25),
	@pRowInfo timestamp
 )
AS
	Update Company
	Set
		[Name] = @pName, [Address] = @pAddress, [City] = @pCity, [StateId] = @pStateId, [CountryId] = @pCountryId, [PostalCode] = @pPostalCode, [Phone] = @pPhone, [Fax] = @pFax, [Website] = @pWebsite, [EmailAddress] = @pEmailAddress, [Tax] = @pTax, [Discount] = @pDiscount, [MultipleCurrency] = @pMultipleCurrency, [Culture] = @pCulture, [LocalSign] = @pLocalSign, [ForeignSign] = @pForeignSign, [LocalName] = @pLocalName, [ForeignName] = @pForeignName, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
	Where
		[CompanyId] = @pCompanyId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Company
		Where [CompanyId] = @pCompanyId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Company_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocType_Delete 
(	@pDocTypeId int
 )
AS
	Delete ClientDocType
	Where
		[DocTypeId] = @pDocTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocType_Insert 
(	@pDocTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50),
	@pIsDebit bit 
 )
AS
	Insert into ClientDocType
		([CompanyId], [Name], [IsDebit], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pIsDebit, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocType_Read
(	@pDocTypeId int
 )
AS
	Select
		[DocTypeId],
		[CompanyId], 
		[Name],
		[IsDebit],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	ClientDocType
	Where
		[DocTypeId] = @pDocTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocType_Update
(	@pDocTypeId int,
	@pCompanyId int,
	@pName varchar (50),
	@pIsDebit bit,
	@pRowInfo timestamp
 )
AS
	Update ClientDocType
	Set
		[CompanyId] = @pCompanyId, 
		[Name] = @pName, 
		[IsDebit] = @pIsDebit, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[DocTypeId] = @pDocTypeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientDocType
		Where [DocTypeId] = @pDocTypeId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocType_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Department_Delete 
(	@pDepartmentId int 
 )
AS
	Delete Department
	Where
		[DepartmentId] = @pDepartmentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Department_Insert 
(	@pDepartmentId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) ,
	@pLocation varchar (200) 
 )
AS
	Insert into Department
		([CompanyId], [Name], [Location], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pLocation, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDepartmentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IdENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Department_Read
(	@pDepartmentId int
 )
AS
	Select
		[DepartmentId],
		[CompanyId],
		[Name],
		[Location],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	Department
	Where [DepartmentId] = @pDepartmentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Department_Update
(	@pDepartmentId int,
	@pCompanyId int,
	@pName varchar (50) ,
	@pLocation varchar (200),
	@pRowInfo timestamp
 )
AS
	Update Department
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[Location] = @pLocation, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[DepartmentId] = @pDepartmentId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Department
		Where [DepartmentId] = @pDepartmentId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Department_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_DocumentStatus_Delete 
(	@pDocumentStatusId int
 )
AS
	Delete DocumentStatus
	Where	[DocumentStatusId] = @pDocumentStatusId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_DocumentStatus_Insert 
(	@pDocumentStatusId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) 
 )
AS
	Insert into DocumentStatus
		([CompanyId], [Name], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocumentStatusId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_DocumentStatus_Read
(	@pDocumentStatusId int
 )
AS
	Select
		[DocumentStatusId],
		[CompanyId], 
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	DocumentStatus
	Where [DocumentStatusId] = @pDocumentStatusId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_DocumentStatus_Update
(	@pDocumentStatusId int,
	@pCompanyId int,
	@pName varchar (50),
	@pRowInfo timestamp
 )
AS
	Update DocumentStatus
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where	[DocumentStatusId] = @pDocumentStatusId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From DocumentStatus
		Where [DocumentStatusId] = @pDocumentStatusId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_DocumentStatus_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Delete 
(	@pEmployeeProfileId int 
)
AS
	Delete EmployeeProfile
	Where 
		([EmployeeProfileId] = @pEmployeeProfileId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Insert 
(	@pEmployeeProfileId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) ,
	@pCommission money
 )
AS
	Insert into EmployeeProfile
		([CompanyId], [Name], [Commission], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pCommission, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pEmployeeProfileId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Read
(	@pEmployeeProfileId int
 )
AS
	Select
		[EmployeeProfileId], 
		[CompanyId], 
		[Name], 
		[Commission], 
		user_name([InsertUser]) AS InsertUser,
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From
		 EmployeeProfile
	Where [EmployeeProfileId] = @pEmployeeProfileId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_EmployeeProfile_Update
(	@pEmployeeProfileId int,
	@pCompanyId int,
	@pName varchar (50) ,
	@pCommission money,
	@pRowInfo timestamp
 )
AS
	Update EmployeeProfile
	Set
		[CompanyId] = @pCompanyId, [Name] = @pName, [Commission] = @pCommission, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
	Where 
		[EmployeeProfileId] = @pEmployeeProfileId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From EmployeeProfile
		Where [EmployeeProfileId] = @pEmployeeProfileId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_EmployeeProfile_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ExchangeRate_Delete 
(	@pExchangeRateId int   
 )
AS
	Delete ExchangeRate
	Where
		([ExchangeRateId] = @pExchangeRateId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ExchangeRate_Insert 
(	@pExchangeRateId int OUTPUT,
	@pCompanyId int,
	@pAmount money   
 )
AS
	Insert into ExchangeRate
		([CompanyId], [RefreshDate], [Amount], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, getdate(), @pAmount, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pExchangeRateId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ExchangeRate_Read
(	@pExchangeRateId int
 )
AS
	Select
		[ExchangeRateId], 
		[CompanyId],
		[RefreshDate], 
		[Amount], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From ExchangeRate
	Where [ExchangeRateId] = @pExchangeRateId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ExchangeRate_Update
(	@pExchangeRateId int ,
	@pCompanyId int,
	@pRefreshDate datetime,
	@pAmount money,
	@pRowInfo timestamp
 )
AS
	Update ExchangeRate
	Set
		[CompanyId] = @pCompanyId, [RefreshDate] = @pRefreshDate, [Amount] = @pAmount, [LastUpdateUser] = user_id(), [InsertDate] = getdate()
	Where
		[ExchangeRateId] = @pExchangeRateId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ExchangeRate
		Where [ExchangeRateId] = @pExchangeRateId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ExchangeRate_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.profit_sp_GetExchangeRate(
	@pCompanyId int,
	@pDocDate datetime,
	@pExchangeRate money Output) 
AS
	Declare @MultipleCurrency bit, @MaxExchangeRate int, @sqlError int
	Set @MultipleCurrency = 0
	Set @pExchangeRate = 1
	
	Select @MultipleCurrency = [MultipleCurrency] From Company Where CompanyId = @pCompanyId
	
	if (@@ERROR = 0) And (@MultipleCurrency = 1)
	Begin
		SELECT     @pExchangeRate = Amount
		FROM         dbo.ExchangeRate
		WHERE     (CompanyId = @pCompanyId) AND (RefreshDate =
		                          (SELECT     MAX(RefreshDate)
		                            FROM          dbo.ExchangeRate
		                            WHERE      ( CONVERT(Char(10), RefreshDate,101) <= CONVERT(Char(10), @pDocDate,101)) )
			      )
	End
	
	If (@pExchangeRate <= 0.00) Or (@pExchangeRate Is Null)
		Set @pExchangeRate = 1

	Return @@ERROR
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_GetExchangeRate]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_GetExchangeRate]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_MoneyType_Delete 
(	@pMoneyTypeId int
 )
AS
	Delete MoneyType
	Where	[MoneyTypeId] = @pMoneyTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_MoneyType_Insert 
(	@pMoneyTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) 
 )
AS
	Insert into MoneyType
		([CompanyId], [Name], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pMoneyTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_MoneyType_Read
(	@pMoneyTypeId int
 )
AS
	Select
		[MoneyTypeId],
		[CompanyId], 
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	MoneyType
	Where [MoneyTypeId] = @pMoneyTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_MoneyType_Update
(	@pMoneyTypeId int,
	@pCompanyId int,
	@pName varchar (50),
	@pRowInfo timestamp
 )
AS
	Update MoneyType
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where	[MoneyTypeId] = @pMoneyTypeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From MoneyType
		Where [MoneyTypeId] = @pMoneyTypeId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_MoneyType_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_PaymentType_Delete 
(	@pPaymentTypeId int
 )
AS
	Delete PaymentType
	Where	[PaymentTypeId] = @pPaymentTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_PaymentType_Insert 
(	@pPaymentTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) ,
	@pPeriod smallint
 )
AS
	Insert into PaymentType
		([CompanyId], [Name], [Period], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pPeriod, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pPaymentTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.profit_sp_PaymentType_Update
(	@pPaymentTypeId int,
	@pCompanyId int,
	@pName varchar (50) ,
	@pPeriod smallint,
	@pRowInfo timestamp
 )
AS
	Update PaymentType
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[Period] = @pPeriod,
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where	[PaymentTypeId] = @pPaymentTypeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From PaymentType
		Where [PaymentTypeId] = @pPaymentTypeId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_PaymentType_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProductType_Delete 
(	@pProductTypeId int
 )
AS
	Delete ProductType
	Where	[ProductTypeId] = @pProductTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProductType_Insert 
(	@pProductTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) 
 )
AS
	Insert into ProductType
		([CompanyId], [Name], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pProductTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProductType_Read
(	@pProductTypeId int
 )
AS
	Select
		[ProductTypeId],
		[CompanyId],
		[Name],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	ProductType
	Where [ProductTypeId] = @pProductTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProductType_Update
(	@pProductTypeId int,
	@pCompanyId int,
	@pName varchar (50),
	@pRowInfo timestamp
 )
AS
	Update ProductType
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where	[ProductTypeId] = @pProductTypeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ProductType
		Where [ProductTypeId] = @pProductTypeId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProductType_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocType_Delete 
(	@pDocTypeId int
 )
AS
	Delete ProviderDocType
	Where
		[DocTypeId] = @pDocTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocType_Insert 
(	@pDocTypeId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50),
	@pIsDebit bit 
 )
AS
	Insert into ProviderDocType
		([CompanyId], [Name], [IsDebit], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pIsDebit, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocTypeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocType_Read 
(	@pDocTypeId int
 )
AS
	Select
		[DocTypeId],
		[CompanyId], 
		[Name],
		[IsDebit],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	ProviderDocType
	Where [DocTypeId] = @pDocTypeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocType_Update
(	@pDocTypeId int,
	@pCompanyId int,
	@pName varchar (50) ,
	@pIsDebit bit,
	@pRowInfo timestamp
 )
AS
	Update ProviderDocType
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[IsDebit] = @pIsDebit, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[DocTypeId] = @pDocTypeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ProviderDocType
		Where [DocTypeId] = @pDocTypeId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocType_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_UserInfo_Delete 
(	@pUserInfoId int 
 )
AS
	Delete UserInfo
	Where
		[UserInfoId] = @pUserInfoId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_UserInfo_Insert
(	@pUserInfoId int OUTPUT,
	@pCompanyId int,
	@pFirstName varchar (50),
	@pLastName varchar(50),
	@pCulture varchar(5),
	@pRole smallint
 )
AS
	Insert into UserInfo
		([CompanyId], [FirstName], [LastName], [SidName], [Culture], [Role], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pFirstName, @pLastName, suser_sname(), @pCulture, @pRole, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pUserInfoId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_UserInfo_Read 
(	@pUserInfoId int,
	@pSidName varchar(25)
 )
AS
if Not(@pUserInfoId IS Null)
	Select
		[UserInfoId],
		[CompanyId],
		[FirstName],
		[LastName],
		[SidName],
		[Culture],
		[Role],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	UserInfo
	Where [UserInfoId] = @pUserInfoId
else
	Select
		[UserInfoId],
		[CompanyId],
		[FirstName],
		[LastName],
		[SidName],
		[Culture],
		[Role],
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	UserInfo
	Where [SidName] = @pSidName
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_UserInfo_Update
(	@pUserInfoId int,
	@pCompanyId int,
	@pFirstName varchar (50),
	@pLastName varchar(50),
	@pCulture varchar(5),
	@pRole smallint,
	@pRowInfo timestamp
 )
AS
	Update UserInfo
	Set
		[CompanyId] = @pCompanyId,
		[FirstName] = @pFirstName, 
		[LastName] = @pLastName,
		[Culture] = @pCulture,
		[Role] = @pRole,
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[UserInfoId] = @pUserInfoId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From UserInfo
		Where [UserInfoId] = @pUserInfoId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_UserInfo_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Warehouse_Delete 
(	@pWarehouseId int 
 )
AS
	Delete Warehouse
	Where
		[WarehouseId] = @pWarehouseId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Warehouse_Insert 
(	@pWarehouseId int OUTPUT,
	@pCompanyId int,
	@pName varchar (50) ,
	@pLocation varchar (200) 
 )
AS
	Insert into Warehouse
		([CompanyId], [Name], [Location], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pName, @pLocation, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pWarehouseId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.profit_sp_Warehouse_Read 
(	@pWarehouseId int
 )
AS
	Select
		[WarehouseId],
		[CompanyId],
		[Name],
		[Location]  ,
		user_name([InsertUser]) AS InsertUser,
		[InsertDate],
		user_name([LastUpdateUser]) AS LastUpdateUser,
		[LastUpdateDate],
		[RowInfo]
	From	Warehouse
	Where [WarehouseId] = @pWarehouseId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Warehouse_Update
(	@pWarehouseId int,
	@pCompanyId int,
	@pName varchar (50) ,
	@pLocation varchar (200),
	@pRowInfo timestamp
 )
AS
	Update Warehouse
	Set
		[CompanyId] = @pCompanyId,
		[Name] = @pName, 
		[Location] = @pLocation, 
		[LastUpdateUser] = user_id(), 
		[LastUpdateDate] = getdate()
	Where
		[WarehouseId] = @pWarehouseId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Warehouse
		Where [WarehouseId] = @pWarehouseId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Warehouse_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Employee_Delete 
(	@pEmployeeId int
 )
AS
	Delete Employee
	Where
		( [EmployeeId] = @pEmployeeId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Employee_Insert 
(	@pEmployeeId int OUTPUT,
	@pCompanyId int,
	@pDepartmentId int,
	@pEmployeeProfileId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime,
	@pMaritalStatus varchar(1),
	@pDateHired datetime, 
	@pDeductions money,
	@pSalary money,
	@pContactName varchar(50),
	@pContactPhone varchar(25)
 )
AS
	Insert into Employee
		([CompanyId], [DepartmentId], [EmployeeProfileId], [FirstName], [LastName], [Title], [IdNumber], [Address], [City], [StateId], [CountryId], [Gender], [PostalCode], [Phone], [Fax], [MobilePhone], [EmailAddress], [Birthday], [MaritalStatus], [DateHired], [Deductions], [Salary], [ContactName], [ContactPhone], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pDepartmentId, @pEmployeeProfileId, @pFirstName, @pLastName, @pTitle, @pIdNumber, @pAddress, @pCity, @pStateId, @pCountryId, @pGender, @pPostalCode, @pPhone, @pFax, @pMobilePhone, @pEmailAddress, @pBirthday, @pMaritalStatus, @pDateHired, @pDeductions, @pSalary, @pContactName, @pContactPhone, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pEmployeeId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Employee_Read
(	@pEmployeeId int
 )
AS
	Select 
		[EmployeeId], 
		[CompanyId], 
		[DepartmentId], 
		[EmployeeProfileId], 
		[FirstName], 
		[LastName], 
		[Title],
		[IdNumber], 
		[Address], 
		[City],
		[StateId], 
		[CountryId], 
		[Gender], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[MobilePhone], 
		[EmailAddress],
		[Birthday], 
		[IsActive], 
		[MaritalStatus], 
		[DateHired], 
		[Deductions], 
		[Salary], 
		[ContactName], 
		[ContactPhone], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From Employee
	Where [EmployeeId] = @pEmployeeId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Employee_Update
(	@pEmployeeId int,
	@pCompanyId int,
	@pDepartmentId int,
	@pEmployeeProfileId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime,
	@pIsActive bit,
	@pMaritalStatus varchar(1),
	@pDateHired datetime, 
	@pDeductions money,
	@pSalary money,
	@pContactName varchar(50),
	@pContactPhone varchar(25),
	@pRowInfo timestamp
 )
AS
	Update Employee
	Set
		[CompanyId] = @pCompanyId, [DepartmentId] = @pDepartmentId, [EmployeeProfileId] = @pEmployeeProfileId, [FirstName] = @pFirstName, [LastName] = @pLastName, [Title] = @pTitle, [IdNumber] = @pIdNumber, [Address] = @pAddress, [City] = @pCity, [StateId] = @pStateId, [CountryId] = @pCountryId, [Gender] = @pGender, [PostalCode] = @pPostalCode, [Phone] = @pPhone, [Fax] = @pFax, [MobilePhone] = @pMobilePhone, [EmailAddress] = @pEmailAddress, [Birthday] = @pBirthday, [IsActive] = @pIsActive, [MaritalStatus] = @pMaritalStatus, [DateHired] = @pDateHired, [Deductions] = @pDeductions, [Salary] = @pSalary, [ContactName] = @pContactName, [ContactPhone] = @pContactPhone, [LastUpdateUser] = user_id(), [LastUpdateDate]  = getdate()
	Where
		[EmployeeId] = @pEmployeeId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Employee
		Where [EmployeeId] = @pEmployeeId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Employee_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientContact_Delete 
(	@pContactId int
 )
AS
	Delete ClientContact
	Where
		[ContactId]=@pContactId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientContact_Insert 
(	@pContactId int OUTPUT,
	@pClientId int,
	@pCompanyId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime
 )
AS
	Insert into ClientContact
		([ClientId], [CompanyId], [FirstName], [LastName], [Title], [IdNumber], [Address], [City], [StateId], [CountryId], [Gender], [PostalCode], [Phone], [Fax], [MobilePhone], [EmailAddress], [Birthday], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pClientId, @pCompanyId, @pFirstName, @pLastName, @pTitle,  @pIdNumber, @pAddress, @pCity, @pStateId, @pCountryId, @pGender, @pPostalCode, @pPhone, @pFax, @pMobilePhone, @pEmailAddress, @pBirthday, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pContactId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientContact_Read
(	@pContactId int
 )
AS
	Select
		[ContactId],
		[ClientId],
		[CompanyId], 
		[FirstName], 
		[LastName], 
		[Title],
		[IdNumber],
		[Address], 
		[StateId], 
		[CountryId], 
		[Gender], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[MobilePhone], 
		[EmailAddress], 
		[Birthday], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ClientContact
	Where  [ContactId] = @pContactId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientContact_Update
(	@pContactId int,
	@pClientId int,
	@pCompanyId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime,
	@pIsActive bit,
	@pRowInfo timestamp
 )
AS
	Update ClientContact
	Set
		[ClientId] = @pClientId, [CompanyId] = @pCompanyId, [FirstName]=@pFirstName, [LastName]=@pLastName, [Title] = @pTitle, [IdNumber] = @pIdNumber, [Address]=@pAddress, [City] = @pCity, [StateId]=@pStateId, [CountryId]=@pCountryId, [Gender]=@pGender, [PostalCode]=@pPostalCode, [Phone]=@pPhone, [Fax]=@pFax, [MobilePhone]=@pMobilePhone, [EmailAddress]=@pEmailAddress, [Birthday]=@pBirthday, [IsActive]=@pIsActive, [LastUpdateUser]=user_id(), [LastUpdateDate]=getdate()
	Where
		 [ContactId]=@pContactId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientContact
		Where [ContactId]=@pContactId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientContact_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Delete 
(	@pDocumentId int,
	@pProductId int
 )
AS
if Not(@pProductId Is Null)
	Delete ClientDocDetail
	Where
		[DocumentId]  = @pDocumentId  AND [ProductId]  = @pProductId
else
	Delete ClientDocDetail
	Where
		[DocumentId]  = @pDocumentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Insert 
(	@pDocumentId int,
	@pProductId int,
	@pCompanyId int,
	@pQuantity int,
	@pTax money, 
	@pDiscount money,
	@pUnitPrice money
 )
AS
	Insert into ClientDocDetail
		([DocumentId] , [ProductId] , [CompanyId], [Quantity] , [Tax] , [Discount] , [UnitPrice] )
	Values
		(@pDocumentId, @pProductId, @pCompanyId, @pQuantity, @pTax, @pDiscount, @pUnitPrice)

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
		RAISERROR ('PDE#50003',16,1)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Read
(	@pDocumentId int,
	@pProductId int
 )
AS
	Select
		DocumentId,
		ProductId,
		CompanyId,
		Quantity,
		Tax,
		Discount,
		UnitPrice,
		[RowInfo]
	From	ClientDocDetail
	Where
		[DocumentId] = @pDocumentId And [ProductId] = @pProductId
	Order By [DocumentId], [ProductId]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocDetail_Update
(	@pDocumentId int,
	@pProductId int,
	@pCompanyId int,
	@pQuantity int,
	@pTax money, 
	@pDiscount money,
	@pUnitPrice money,
	@pRowInfo timestamp
 )
AS
	Update ClientDocDetail
	Set
		[CompanyId] = @pCompanyId, [Quantity]  = @pQuantity, [Tax] = @pTax, [Discount] = @pDiscount, [UnitPrice] = @pUnitPrice
	Where
		[DocumentId]  = @pDocumentId AND [ProductId] = @pProductId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientDocDetail
		Where [DocumentId]  = @pDocumentId AND [ProductId] = @pProductId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocDetail_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocument_Delete 
(	@pDocumentId int 
 )
AS
	Delete ClientDocument 
	Where
		([DocumentId] = @pDocumentId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocument_Insert 
(	@pDocumentId int OUTPUT,
	@pCompanyId int,
	@pDocTypeId int,
	@pDocumentStatusId int,
	@pClientId int, 
	@pEmployeeId int,
	@pPaymentTypeId int,
	@pCommission money,
	@pCommissionPaid bit,
	@pDocDate datetime,
	@pDocConsecutive int,
	@pOtherCost money,
	@pDiscount money,
	@pTax money,
	@pAmount money,
	@pRemarks varchar(200)
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Insert into ClientDocument 
			([CompanyId], [DocTypeId], [DocumentStatusId], [ClientId], [EmployeeId], [PaymentTypeId], [Commission], [CommissionPaid], [DocDate], [DocConsecutive], [OtherCost], [Discount], [Tax], [Amount], [Remarks], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pDocTypeId, @pDocumentStatusId, @pClientId, @pEmployeeId, @pPaymentTypeId, @pCommission, @pCommissionPaid, @pDocDate, @pDocConsecutive, @pOtherCost, @pDiscount, @pTax, @pAmount, @pRemarks, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocumentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocument_Read
(	@pDocumentId int
 )
AS
	Select
		[DocumentId], 
		[CompanyId],
		[DocTypeId], 
		[DocumentStatusId],
		[ClientId], 
		[EmployeeId], 
		[PaymentTypeId],
		[Commission], 
		[CommissionPaid],
		[DocDate], 
		[DocConsecutive],
		[OtherCost], 
		[Discount], 
		[Tax], 
		[Amount],
		[Remarks],
		[ExchangeRate], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ClientDocument
	Where [DocumentId] = @pDocumentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientDocument_Update
(	@pDocumentId int,
	@pCompanyId int,
	@pDocTypeId int,
	@pDocumentStatusId int,
	@pClientId int, 
	@pEmployeeId int,
	@pPaymentTypeId int,
	@pCommission money,
	@pCommissionPaid bit,
	@pDocDate datetime,
	@pDocConsecutive int,
	@pOtherCost money,
	@pDiscount money,
	@pTax money,
	@pAmount money,
	@pRemarks varchar(200),
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [DocDate], @ExchangeRate = [ExchangeRate] From ClientDocument Where ([DocumentId] = @pDocumentId)

	/* Only change the ExchangeRate if Amount or Date have been changed */
	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pDocDate)) And (@@ERROR = 0) )
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update ClientDocument 
		Set
			[CompanyId] = @pCompanyId, [DocTypeId] = @pDocTypeId, [DocumentStatusId] = @pDocumentStatusId, [ClientId] = @pClientId, [EmployeeId] = @pEmployeeId, [PaymentTypeId] = @pPaymentTypeId, [Commission] = @pCommission, [CommissionPaid] = @pCommissionPaid, [DocDate] = @pDocDate, [DocConsecutive] = @pDocConsecutive, [OtherCost] = @pOtherCost, [Discount] = @pDiscount, [Tax] = @pTax, [Amount] = @pAmount, [Remarks] = @pRemarks, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
		Where
			[DocumentId] = @pDocumentId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientDocument
		Where [DocumentId] = @pDocumentId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientDocument_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientPayment_Delete 
(	@pClientPaymentId int 
 )
AS
	Delete ClientPayment
	Where
		([ClientPaymentId] = @pClientPaymentId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientPayment_Insert 
(	@pClientPaymentId int OUTPUT,
	@pCompanyId int,
	@pClientId int,
	@pCreditDocumentId int,
	@pDebitDocumentId int,
	@pMoneyTypeId int,
	@pPaymentDate datetime,
	@pAmount money,
	@pRemarks varchar(200)
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pPaymentDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Insert into ClientPayment
			([CompanyId], [ClientId], [CreditDocumentId], [DebitDocumentId], [MoneyTypeId], [PaymentDate], [Amount], [Remarks], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pClientId, @pCreditDocumentId, @pDebitDocumentId, @pMoneyTypeId, @pPaymentDate, @pAmount, @pRemarks, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pClientPaymentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientPayment_Read
(	@pClientPaymentId int
 )
AS
	Select 
		[ClientPaymentId],
		[CompanyId],
		[ClientId], 
		[CreditDocumentId], 
		[DebitDocumentId], 
		[MoneyTypeId],
		[PaymentDate],
		[Amount], 
		[Remarks],
		[ExchangeRate],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ClientPayment
	Where [ClientPaymentId] = @pClientPaymentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ClientPayment_Update
(	@pClientPaymentId int,
	@pCompanyId int,
	@pClientId int  ,
	@pCreditDocumentId int,
	@pDebitDocumentId int,
	@pMoneyTypeId int,
	@pPaymentDate datetime,
	@pAmount money,
	@pRemarks varchar(200),
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [PaymentDate], @ExchangeRate = [ExchangeRate] From ClientPayment Where ([ClientPaymentId] = @pClientPaymentId)

	/* Only change the ExchangeRate if Amount or Date have been changed */
	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pPaymentDate)) And (@@ERROR = 0) )
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pPaymentDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update ClientPayment
		Set
			[ClientId] = @pClientId, [CompanyId] = @pCompanyId, [CreditDocumentId] = @pCreditDocumentId, [DebitDocumentId] = @pDebitDocumentId, [MoneyTypeId] = @pMoneyTypeId, [PaymentDate] = @pPaymentDate, [Amount] = @pAmount, [Remarks] = @pRemarks, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] =  user_id(), [LastUpdateDate] = getdate()
		Where
			[ClientPaymentId] = @pClientPaymentId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ClientPayment
		Where [ClientPaymentId] = @pClientPaymentId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ClientPayment_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Client_Delete 
(	@pClientId int
 )
AS
	Delete Client
	Where
		([ClientId] = @pClientId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Client_Insert 
(	@pClientId int OUTPUT,
	@pCompanyId int ,  
	@pPrimaryContactId int,
	@pName varchar(50),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,	
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pCreditLimit money
 )
AS
	Insert into Client
		([CompanyId], [PrimaryContactId], [Name], [Address], [City], [StateId], [CountryId], [PostalCode], [Phone], [Fax], [Website], [EmailAddress], [CreditLimit], [Balance], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pPrimaryContactId, @pName, @pAddress, @pCity, @pStateId, @pCountryId, @pPostalCode, @pPhone, @pFax, @pWebsite, @pEmailAddress, @pCreditLimit, 0, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pClientId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Client_Read
(	@pClientId int
 )
AS
	Select
		[ClientId], 
		[CompanyId], 
		[PrimaryContactId], 
		[Name], 
		[Address], 
		[City],
		[StateId], 
		[CountryId], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[Website], 
		[EmailAddress], 
		[CreditLimit], 
		[Balance], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	Client
	Where [ClientId] = @pClientId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Client_Update
(	@pClientId int ,
	@pCompanyId int ,  
	@pPrimaryContactId int, 
	@pName varchar(50),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pCreditLimit money,
	@pBalance money, 
	@pIsActive bit,
	@pRowInfo timestamp
 )
AS
	Update Client
	Set
		[CompanyId] = @pCompanyId, [PrimaryContactId] = @pPrimaryContactId, [Name] = @pName, [Address] = @pAddress, [City] = @pCity, [StateId] = @pStateId, [CountryId] = @pCountryId, [PostalCode] = @pPostalCode, [Phone] = @pPhone, [Fax] = @pFax, [Website] = @pWebsite, [EmailAddress] = @pEmailAddress, [CreditLimit] = @pCreditLimit, [Balance] = @pBalance, [IsActive] = @pIsActive, [LastUpdateUser] = user_id(), [InsertDate] = getdate()
	Where
		[ClientId] = @pClientId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Client
		Where [ClientId] = @pClientId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Client_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Commission_Delete 
(	@pCommissionId int
 )
AS
	Delete Commission
	Where
		[CommissionId] = @pCommissionId

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Commission_Insert 
(	@pCommissionId int OUTPUT,
	@pCompanyId int,
	@pEmployeeId int,
	@pDocumentId int,
	@pDocDate datetime,
	@pAmount money
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Insert into Commission
			([CompanyId], [EmployeeId], [DocumentId], [DocDate], [Amount], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pEmployeeId, @pDocumentId, @pDocDate, @pAmount, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pCommissionId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Commission_Update
(	@pCommissionId int,
	@pCompanyId int,
	@pEmployeeId int,
	@pDocumentId int,
	@pDocDate datetime,
	@pAmount money,
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [DocDate], @ExchangeRate = [ExchangeRate] From Commission Where ([CommissionId] = @pCommissionId)

	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pDocDate)) And (@@ERROR = 0) )
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update Commission
		Set
			[CompanyId] = @pCompanyId, [EmployeeId] = @pEmployeeId, [DocumentId] = @pDocumentId, [DocDate] = @pDocDate, [Amount] = @pAmount, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
		Where
			[CommissionId] = @pCommissionId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Commission
		Where [CommissionId] = @pCommissionId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Commission_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Product_Delete 
(	@pProductId int
 )
AS
	Delete Product
	Where
		([ProductId] = @pProductId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Product_Insert 
(	@pProductId int OUTPUT,
	@pCompanyId int,
	@pProductTypeId int,
	@pProviderId int,
	@pWarehouseId int,
	@pName varchar(50),
	@pUnitsInStock int,
	@pUnitPrice money
 )
AS
	Insert into Product
		([CompanyId], [ProductTypeId], [ProviderId], [WarehouseId], [Name], [UnitsInStock], [UnitPrice], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pProductTypeId, @pProviderId, @pWarehouseId, @pName, @pUnitsInStock, @pUnitPrice, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pProductId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE dbo.profit_sp_Product_Read
(	@pProductId int
 )
AS
	Select 
		[ProductId], 
		[CompanyId], 
		[ProductTypeId], 
		[ProviderId], 
		[WarehouseId], 
		[Name], 
		[UnitsInStock], 
		[UnitPrice], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From Product
	Where [ProductId] = @pProductId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Product_Update
(	@pProductId int,
	@pCompanyId int,
	@pProductTypeId int,
	@pProviderId int,
	@pWarehouseId int,
	@pName varchar(50),
	@pUnitsInStock int,
	@pUnitPrice money,
	@pIsActive bit,
	@pRowInfo timestamp
 )
AS
	Update Product
	Set
		[CompanyId] = @pCompanyId, [ProductTypeId] = @pProductTypeId, [ProviderId] = @pProviderId, [WarehouseId] = @pWarehouseId, [Name] = @pName, [UnitsInStock] = @pUnitsInStock, [UnitPrice] = @pUnitPrice, [IsActive] = @pIsActive, [LastUpdateUser] = user_id(), [InsertDate] = getdate()
	Where
		[ProductId] = @pProductId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Product
		Where [ProductId] = @pProductId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Product_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderContact_Delete 
(	@pContactId int
 )
AS
	Delete ProviderContact
	Where
		[ContactId]=@pContactId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderContact_Insert 
(	@pContactId int OUTPUT,
	@pProviderId int, 
	@pCompanyId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime
 )
AS
	Insert into ProviderContact
		([ProviderId], [CompanyId], [FirstName], [LastName], [Title], [IdNumber], [Address], [City], [StateId], [CountryId], [Gender], [PostalCode], [Phone], [Fax], [MobilePhone], [EmailAddress], [Birthday], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pProviderId, @pCompanyId, @pFirstName, @pLastName, @pTitle, @pIdNumber, @pAddress, @pCity, @pStateId, @pCountryId, @pGender, @pPostalCode, @pPhone, @pFax, @pMobilePhone, @pEmailAddress, @pBirthday, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pContactId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderContact_Read 
(	@pContactId int
 )
AS
	Select
		[ContactId],
		[ProviderId],
		[CompanyId],
		[FirstName], 
		[LastName], 
		[Title],
		[IdNumber],
		[City],
		[Address], 
		[StateId], 
		[CountryId], 
		[Gender], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[MobilePhone], 
		[EmailAddress], 
		[Birthday], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ProviderContact
	Where [ContactId] = @pContactId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderContact_Update
(	@pContactId int,
	@pProviderId int, 
	@pCompanyId int,
	@pFirstName varchar(50),
	@pLastName varchar(50),
	@pTitle varchar(25),
	@pIdNumber varchar(25),
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,
	@pGender varchar(1),
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pMobilePhone varchar(25),
	@pEmailAddress varchar(50),
	@pBirthday datetime,
	@pIsActive bit,
	@pRowInfo timestamp
 )
AS
	Update ProviderContact
	Set
		[ProviderId]= @pProviderId, [CompanyId] = @pCompanyId, [FirstName]=@pFirstName, [LastName]=@pLastName, [Title] = @pTitle, [IdNumber] = @pIdNumber, [Address]=@pAddress, [City] = @pCity, [StateId]=@pStateId, [CountryId]=@pCountryId, [Gender]=@pGender, [PostalCode]=@pPostalCode, [Phone]=@pPhone, [Fax]=@pFax, [MobilePhone]=@pMobilePhone, [EmailAddress]=@pEmailAddress, [Birthday]=@pBirthday, [IsActive]=@pIsActive, [LastUpdateUser]=user_id(), [LastUpdateDate]=getdate()
	Where
		[ContactId]=@pContactId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ProviderContact
		Where [ContactId]=@pContactId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderContact_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocument_Delete 
(	@pDocumentId int 
 )
AS
	Delete ProviderDocument 
	Where
		([DocumentId] = @pDocumentId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocument_Insert 
(	@pDocumentId int OUTPUT,
	@pCompanyId int,
	@pDocTypeId int,
	@pDocumentStatusId int,
	@pProviderId int, 
	@pPaymentTypeId int,
	@pDocDate datetime,
	@pDocConsecutive int,
	@pOtherCost money,
	@pDiscount money,
	@pTax money,
	@pAmount money,
	@pRemarks varchar(200)
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT 

	if @@ERROR = 0 
		Insert into ProviderDocument 
			([CompanyId], [DocTypeId], [DocumentStatusId], [ProviderId], [PaymentTypeId], [DocDate], [DocConsecutive], [OtherCost], [Discount], [Tax], [Amount], [Remarks], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pDocTypeId, @pDocumentStatusId, @pProviderId, @pPaymentTypeId, @pDocDate, @pDocConsecutive, @pOtherCost, @pDiscount, @pTax, @pAmount, @pRemarks, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pDocumentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocument_Read
(	@pDocumentId int
 )
AS
	Select
		[DocumentId], 
		[CompanyId],
		[DocTypeId], 
		[DocumentStatusId],
		[ProviderId], 
		[PaymentTypeId], 
		[DocDate], 
		[DocConsecutive],
		[OtherCost], 
		[Discount], 
		[Tax], 
		[Amount], 
		[Remarks], 
		[ExchangeRate],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ProviderDocument
	Where [DocumentId] = @pDocumentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderDocument_Update
(	@pDocumentId int,
	@pCompanyId int,
	@pDocTypeId int,
	@pDocumentStatusId int,
	@pProviderId int, 
	@pPaymentTypeId int,
	@pDocDate datetime,
	@pDocConsecutive int,
	@pOtherCost money,
	@pDiscount money,
	@pTax money,
	@pAmount money,
	@pRemarks varchar(200),
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [DocDate], @ExchangeRate = [ExchangeRate] From ProviderDocument Where ([DocumentId] = @pDocumentId)

	/* Only change the ExchangeRate if Amount or Date have been changed */
	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pDocDate)) And (@@ERROR = 0))
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pDocDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update ProviderDocument 
		Set
			[CompanyId] = @pCompanyId, [DocTypeId] = @pDocTypeId, [DocumentStatusId] = @pDocumentStatusId, [ProviderId] = @pProviderId, [PaymentTypeId] = @pPaymentTypeId, [DocDate] = @pDocDate, [DocConsecutive] = @pDocConsecutive, [OtherCost] = @pOtherCost, [Discount] = @pDiscount, [Tax] = @pTax, [Amount] = @pAmount, [Remarks] = @pRemarks, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] = user_id(), [LastUpdateDate] = getdate()
		Where
			[DocumentId] = @pDocumentId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ProviderDocument
		Where [DocumentId] = @pDocumentId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderDocument_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Delete 
(	@pProviderPaymentId int 
 )
AS
	Delete ProviderPayment
	Where
		([ProviderPaymentId] = @pProviderPaymentId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Insert 
(	@pProviderPaymentId int OUTPUT,
	@pCompanyId int,
	@pProviderId int  ,
	@pDebitDocumentId int,
	@pCreditDocumentId int,
	@pMoneyTypeId int,
	@pPaymentDate datetime,
	@pAmount money,
	@pRemarks varchar(200)
 )
AS
	Declare @ExchangeRate decimal(19,4)
	Exec [profit_sp_GetExchangeRate] @pCompanyId, @pPaymentDate, @ExchangeRate OUTPUT 

	if @@ERROR = 0 
		Insert into ProviderPayment
			([CompanyId], [ProviderId], [CreditDocumentId], [DebitDocumentId], [MoneyTypeId] , [PaymentDate], [Amount], [Remarks], [ExchangeRate], [InsertUser], [InsertDate])
		Values
			(@pCompanyId, @pProviderId, @pCreditDocumentId, @pDebitDocumentId, @pMoneyTypeId, @pPaymentDate, @pAmount, @pRemarks, @ExchangeRate, user_id(), getdate())
	else
		Return @@ERROR

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pProviderPaymentId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Read
(	@pProviderPaymentId int
 )
AS
	Select 
		[ProviderPaymentId],
		[CompanyId],
		[ProviderId], 
		[DebitDocumentId], 
		[CreditDocumentId], 
		[MoneyTypeId],
		[PaymentDate],
		[Amount], 
		[Remarks],
		[ExchangeRate],
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	ProviderPayment
	Where [ProviderPaymentId] = @pProviderPaymentId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_ProviderPayment_Update
(	@pProviderPaymentId int,
	@pCompanyId int,
	@pProviderId int  ,
	@pDebitDocumentId int,
	@pCreditDocumentId int,
	@pMoneyTypeId int,
	@pPaymentDate datetime,
	@pAmount money,
	@pRemarks varchar(200),
	@pRowInfo timestamp
 )
AS
	Declare @CurrentAmount  money
	Declare @CurrentDate datetime
	Declare @ExchangeRate decimal(19,4)

	Select @CurrentAmount = [Amount], @CurrentDate = [PaymentDate], @ExchangeRate = [ExchangeRate] From ProviderPayment Where ([ProviderPaymentId] = @pProviderPaymentId)

	/* Only change the ExchangeRate if Amount or Date have been changed */
	if ( ((@CurrentAmount <> @pAmount) Or (@CurrentDate <> @pPaymentDate)) And (@@ERROR = 0))
		Exec [profit_sp_GetExchangeRate] @pCompanyId, @pPaymentDate, @ExchangeRate OUTPUT

	if @@ERROR = 0
		Update ProviderPayment
		Set
			[CompanyId] = @pCompanyId, [ProviderId] = @pProviderId, [CreditDocumentId] = @pCreditDocumentId, [DebitDocumentId] = @pDebitDocumentId, [MoneyTypeId] = @pMoneyTypeId, [PaymentDate] = @pPaymentDate, [Amount] = @pAmount, [Remarks] = @pRemarks, [ExchangeRate] = @ExchangeRate, [LastUpdateUser] =  user_id(), [LastUpdateDate] = getdate()
		Where
			[ProviderPaymentId] = @pProviderPaymentId AND [RowInfo] = @pRowInfo
	else
		Return @@ERROR

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From ProviderPayment
		Where [ProviderPaymentId] = @pProviderPaymentId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_ProviderPayment_Update]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Provider_Delete 
(	@pProviderId int 
 )
AS
	Delete Provider
	Where
		([ProviderId] = @pProviderId)
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Delete]  TO [profit_role_datadelete]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Delete]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Provider_Insert 
(	@pProviderId int OUTPUT,
	@pCompanyId int ,  
	@pPrimaryContactId int , 
	@pName varchar(50),	
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,	
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pCreditLimit money
 )
AS
	Insert into Provider
		([CompanyId], [PrimaryContactId], [Name], [Address], [City], [StateId], [CountryId], [PostalCode], [Phone], [Fax], [Website], [EmailAddress], [CreditLimit], [Balance], [IsActive], [InsertUser], [InsertDate])
	Values
		(@pCompanyId, @pPrimaryContactId, @pName, @pAddress, @pCity, @pStateId, @pCountryId, @pPostalCode, @pPhone, @pFax, @pWebsite, @pEmailAddress, @pCreditLimit, 0, 1, user_id(), getdate())

	if (@@ROWCOUNT = 1 And @@ERROR = 0)
		Select @pProviderId = SCOPE_IDENTITY()
	else
		Begin
			-- An error has occurred while trying to insert this record.
			RAISERROR ('PDE#50003',16,1)
			Return @@ERROR
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Insert]  TO [profit_role_datainsert]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Insert]  TO [profit_role_fullaccess]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Provider_Read
(	@pProviderId int
 )
AS
	Select
		[ProviderId], 
		[CompanyId], 
		[PrimaryContactId], 
		[Name], 
		[Address], 
		[City],
		[StateId], 
		[CountryId], 
		[PostalCode], 
		[Phone], 
		[Fax], 
		[Website], 
		[EmailAddress], 
		[CreditLimit], 
		[Balance], 
		[IsActive], 
		user_name([InsertUser]) AS InsertUser, 
		[InsertDate], 
		user_name([LastUpdateUser]) AS LastUpdateUser, 
		[LastUpdateDate],
		[RowInfo]
	From	Provider
	Where [ProviderId] = @pProviderId
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Read]  TO [profit_role_fullaccess]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Read]  TO [profit_role_datareader]
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO
CREATE PROCEDURE dbo.profit_sp_Provider_Update
(	@pProviderId int  ,
	@pCompanyId int ,  
	@pPrimaryContactId int , 
	@pName varchar(50),	
	@pAddress varchar(200),
	@pCity varchar(25),
	@pStateId int,
	@pCountryId int,	
	@pPostalCode varchar(25),
	@pPhone varchar(25),
	@pFax varchar(25),
	@pWebsite varchar(50),
	@pEmailAddress varchar(50),
	@pCreditLimit money,
	@pBalance money, 
	@pIsActive bit,
	@pRowInfo timestamp
 )
AS
	Update Provider
	Set
		[CompanyId] = @pCompanyId, [PrimaryContactId] = @pPrimaryContactId, [Name] = @pName, [Address] = @pAddress, [City] = @pCity, [StateId] = @pStateId, [CountryId] = @pCountryId, [PostalCode] = @pPostalCode, [Phone] = @pPhone, [Fax] = @pFax, [Website] = @pWebsite, [EmailAddress] = @pEmailAddress, [CreditLimit] = @pCreditLimit, [Balance] = @pBalance, [IsActive] = @pIsActive, [LastUpdateUser] = user_id(), [InsertDate] = getdate()
	Where
		[ProviderId] = @pProviderId AND [RowInfo] = @pRowInfo

	if Not(@@ROWCOUNT = 1 And @@ERROR = 0)
	Begin
		Declare @CurrentRowInfo timestamp

		Select @CurrentRowInfo = [RowInfo]
		From Provider
		Where [ProviderId] = @pProviderId

		If @CurrentRowInfo Is Null
		Begin
			-- Incorrect ID or Record has already been deleted !
			RAISERROR ('PDE#50004',16,1)
			Return @@ERROR
		End

		If Not @CurrentRowInfo Is Null And Not @CurrentRowInfo = @pRowInfo
			Begin
				-- You have attempted to update a record that has already been changed.
				RAISERROR ('PDE#50001',16,1)
				Return @@ERROR
			End
		Else
			Begin
				-- An error has occurred while trying to update this record.
				RAISERROR ('PDE#50002',16,1)
				Return @@ERROR
			End
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Update]  TO [profit_role_dataupdate]
GO
GRANT  EXECUTE  ON [dbo].[profit_sp_Provider_Update]  TO [profit_role_fullaccess]
GO
