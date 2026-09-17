CREATE TABLE [dbo].[ClientPayment] (
    [ClientPaymentId]  INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT           NOT NULL,
    [ClientId]         INT           NOT NULL,
    [CreditDocumentId] INT           NOT NULL,
    [DebitDocumentId]  INT           NOT NULL,
    [MoneyTypeId]      INT           NOT NULL,
    [PaymentDate]      DATETIME      NOT NULL,
    [Amount]           MONEY         NOT NULL,
    [Remarks]          VARCHAR (200) NULL,
    [ExchangeRate]     MONEY         NOT NULL,
    [InsertUser]       INT           NOT NULL,
    [InsertDate]       DATETIME      NOT NULL,
    [LastUpdateUser]   INT           NULL,
    [LastUpdateDate]   DATETIME      NULL,
    [RowInfo]          ROWVERSION    NULL,
    CONSTRAINT [PK_ClientPayment] PRIMARY KEY CLUSTERED ([ClientPaymentId] ASC),
    CONSTRAINT [CK_ClientPayment_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_ClientPayment_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_ClientPayment_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_ClientPayment_ClientDocument_Credit] FOREIGN KEY ([CreditDocumentId]) REFERENCES [dbo].[ClientDocument] ([DocumentId]),
    CONSTRAINT [FK_ClientPayment_ClientDocument_Debit] FOREIGN KEY ([DebitDocumentId]) REFERENCES [dbo].[ClientDocument] ([DocumentId]),
    CONSTRAINT [FK_ClientPayment_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_ClientPayment_MoneyType] FOREIGN KEY ([MoneyTypeId]) REFERENCES [dbo].[MoneyType] ([MoneyTypeId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ClientPayment_Company]
    ON [dbo].[ClientPayment]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ClientPayment_CompanyClient]
    ON [dbo].[ClientPayment]([CompanyId] ASC, [ClientId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ClientPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ClientPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ClientPayment] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ClientPayment] TO [profit_role_datareader]
    AS [dbo];

