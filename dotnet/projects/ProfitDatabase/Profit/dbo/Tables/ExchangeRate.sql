CREATE TABLE [dbo].[ExchangeRate] (
    [ExchangeRateId] INT        IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT        NOT NULL,
    [RefreshDate]    DATETIME   NOT NULL,
    [Amount]         MONEY      NOT NULL,
    [InsertUser]     INT        NOT NULL,
    [InsertDate]     DATETIME   NOT NULL,
    [LastUpdateUser] INT        NULL,
    [LastUpdateDate] DATETIME   NULL,
    [RowInfo]        ROWVERSION NULL,
    CONSTRAINT [PK_ExchangeRate] PRIMARY KEY CLUSTERED ([ExchangeRateId] ASC),
    CONSTRAINT [CK_ExchangeRate] CHECK ([Amount]>(0)),
    CONSTRAINT [FK_ExchangeRate_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ExchangeRate_Company]
    ON [dbo].[ExchangeRate]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[ExchangeRate] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[ExchangeRate] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ExchangeRate] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[ExchangeRate] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[ExchangeRate] TO [profit_role_datareader]
    AS [dbo];

