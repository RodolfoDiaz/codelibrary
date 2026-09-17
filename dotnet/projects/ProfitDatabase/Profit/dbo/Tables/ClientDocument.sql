CREATE TABLE [dbo].[ClientDocument] (
    [DocumentId]       INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT           NOT NULL,
    [DocTypeId]        INT           NOT NULL,
    [DocumentStatusId] INT           NOT NULL,
    [ClientId]         INT           NOT NULL,
    [EmployeeId]       INT           NOT NULL,
    [PaymentTypeId]    INT           NOT NULL,
    [Commission]       MONEY         CONSTRAINT [DF_Document_Commission] DEFAULT ((0)) NOT NULL,
    [CommissionPaid]   BIT           CONSTRAINT [DF_ClientDocument_IsCommissionPaid] DEFAULT ((0)) NOT NULL,
    [DocDate]          DATETIME      NOT NULL,
    [DocConsecutive]   INT           NOT NULL,
    [OtherCost]        MONEY         CONSTRAINT [DF_Document_OtherCost] DEFAULT ((0)) NULL,
    [Discount]         MONEY         CONSTRAINT [DF_Document_Discount] DEFAULT ((0)) NULL,
    [Tax]              MONEY         CONSTRAINT [DF_Document_Tax] DEFAULT ((0)) NULL,
    [Amount]           MONEY         NOT NULL,
    [Remarks]          VARCHAR (200) NULL,
    [ExchangeRate]     MONEY         NOT NULL,
    [InsertUser]       INT           NOT NULL,
    [InsertDate]       DATETIME      NOT NULL,
    [LastUpdateUser]   INT           NULL,
    [LastUpdateDate]   DATETIME      NULL,
    [RowInfo]          ROWVERSION    NULL,
    CONSTRAINT [PK_ClientDocument] PRIMARY KEY CLUSTERED ([DocumentId] ASC),
    CONSTRAINT [CK_ClientDocument_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_ClientDocument_Commission] CHECK ([Commission]>=(0)),
    CONSTRAINT [CK_ClientDocument_Discount] CHECK ([Discount]>=(0)),
    CONSTRAINT [CK_ClientDocument_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [CK_ClientDocument_OtherCost] CHECK ([OtherCost]>=(0)),
    CONSTRAINT [CK_ClientDocument_Tax] CHECK ([Tax]>=(0)),
    CONSTRAINT [FK_ClientDocument_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_ClientDocument_ClientDocType] FOREIGN KEY ([DocTypeId]) REFERENCES [dbo].[ClientDocType] ([DocTypeId]),
    CONSTRAINT [FK_ClientDocument_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ClientDocument_DocumentStatus] FOREIGN KEY ([DocumentStatusId]) REFERENCES [dbo].[DocumentStatus] ([DocumentStatusId]),
    CONSTRAINT [FK_ClientDocument_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Employee] ([EmployeeId]),
    CONSTRAINT [FK_ClientDocument_PaymentType] FOREIGN KEY ([PaymentTypeId]) REFERENCES [dbo].[PaymentType] ([PaymentTypeId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ClientDocument_Company]
    ON [dbo].[ClientDocument]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ClientDocument_CompanyClient]
    ON [dbo].[ClientDocument]([CompanyId] ASC, [ClientId] ASC);


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
GRANT DELETE
    ON OBJECT::[dbo].[ClientDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ClientDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ClientDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientDocument] TO [profit_role_datareader]
    AS [dbo];

