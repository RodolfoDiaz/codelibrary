CREATE TABLE [dbo].[ProviderPayment] (
    [ProviderPaymentId] INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT           NOT NULL,
    [ProviderId]        INT           NOT NULL,
    [DebitDocumentId]   INT           NOT NULL,
    [CreditDocumentId]  INT           NOT NULL,
    [MoneyTypeId]       INT           NOT NULL,
    [PaymentDate]       DATETIME      NOT NULL,
    [Amount]            MONEY         NOT NULL,
    [Remarks]           VARCHAR (200) NULL,
    [ExchangeRate]      MONEY         NOT NULL,
    [InsertUser]        INT           NOT NULL,
    [InsertDate]        DATETIME      NOT NULL,
    [LastUpdateUser]    INT           NULL,
    [LastUpdateDate]    DATETIME      NULL,
    [RowInfo]           ROWVERSION    NULL,
    CONSTRAINT [PK_ProviderPayment] PRIMARY KEY CLUSTERED ([ProviderPaymentId] ASC),
    CONSTRAINT [CK_ProviderPayment_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_ProviderPayment_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_ProviderPayment_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ProviderPayment_MoneyType] FOREIGN KEY ([MoneyTypeId]) REFERENCES [dbo].[MoneyType] ([MoneyTypeId]),
    CONSTRAINT [FK_ProviderPayment_Provider] FOREIGN KEY ([ProviderId]) REFERENCES [dbo].[Provider] ([ProviderId]),
    CONSTRAINT [FK_ProviderPayment_ProviderDocument_Credit] FOREIGN KEY ([CreditDocumentId]) REFERENCES [dbo].[ProviderDocument] ([DocumentId]),
    CONSTRAINT [FK_ProviderPayment_ProviderDocument_Debit] FOREIGN KEY ([DebitDocumentId]) REFERENCES [dbo].[ProviderDocument] ([DocumentId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProviderPayment_Company]
    ON [dbo].[ProviderPayment]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProviderPayment_CompanyProvider]
    ON [dbo].[ProviderPayment]([CompanyId] ASC, [ProviderId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ProviderPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ProviderPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProviderPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ProviderPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ProviderPayment] TO [profit_role_datareader]
    AS [dbo];

