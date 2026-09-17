CREATE TABLE [dbo].[ProviderDocument] (
    [DocumentId]       INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT           NOT NULL,
    [DocTypeId]        INT           NOT NULL,
    [DocumentStatusId] INT           NOT NULL,
    [ProviderId]       INT           NOT NULL,
    [PaymentTypeId]    INT           NOT NULL,
    [DocDate]          DATETIME      NOT NULL,
    [DocConsecutive]   INT           NOT NULL,
    [OtherCost]        MONEY         CONSTRAINT [DF_ProviderDoc_OtherCost] DEFAULT ((0)) NULL,
    [Discount]         MONEY         CONSTRAINT [DF_ProviderDoc_Discount] DEFAULT ((0)) NULL,
    [Tax]              MONEY         CONSTRAINT [DF_ProviderDoc_Tax] DEFAULT ((0)) NULL,
    [Amount]           MONEY         NOT NULL,
    [Remarks]          VARCHAR (200) NULL,
    [ExchangeRate]     MONEY         NOT NULL,
    [InsertUser]       INT           NOT NULL,
    [InsertDate]       DATETIME      NOT NULL,
    [LastUpdateUser]   INT           NULL,
    [LastUpdateDate]   DATETIME      NULL,
    [RowInfo]          ROWVERSION    NULL,
    CONSTRAINT [PK_ProviderDocument] PRIMARY KEY CLUSTERED ([DocumentId] ASC),
    CONSTRAINT [CK_ProviderDocument_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_ProviderDocument_Discount] CHECK ([Discount]>=(0)),
    CONSTRAINT [CK_ProviderDocument_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [CK_ProviderDocument_OtherCost] CHECK ([OtherCost]>=(0)),
    CONSTRAINT [CK_ProviderDocument_Tax] CHECK ([Tax]>=(0)),
    CONSTRAINT [FK_ProviderDocument_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ProviderDocument_DocumentStatus] FOREIGN KEY ([DocumentStatusId]) REFERENCES [dbo].[DocumentStatus] ([DocumentStatusId]),
    CONSTRAINT [FK_ProviderDocument_PaymentType] FOREIGN KEY ([PaymentTypeId]) REFERENCES [dbo].[PaymentType] ([PaymentTypeId]),
    CONSTRAINT [FK_ProviderDocument_Provider] FOREIGN KEY ([ProviderId]) REFERENCES [dbo].[Provider] ([ProviderId]),
    CONSTRAINT [FK_ProviderDocument_ProviderDocType] FOREIGN KEY ([DocTypeId]) REFERENCES [dbo].[ProviderDocType] ([DocTypeId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProviderDocument_Company]
    ON [dbo].[ProviderDocument]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProviderDocument_CompanyProvider]
    ON [dbo].[ProviderDocument]([CompanyId] ASC, [ProviderId] ASC);


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
GRANT DELETE
    ON OBJECT::[dbo].[ProviderDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ProviderDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProviderDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ProviderDocument] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProviderDocument] TO [profit_role_datareader]
    AS [dbo];

