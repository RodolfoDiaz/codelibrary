CREATE TABLE [dbo].[MoneyType] (
    [MoneyTypeId]    INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_MoneyType] PRIMARY KEY CLUSTERED ([MoneyTypeId] ASC),
    CONSTRAINT [FK_MoneyType_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_MoneyType_Company]
    ON [dbo].[MoneyType]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[MoneyType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[MoneyType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[MoneyType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[MoneyType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[MoneyType] TO [profit_role_datareader]
    AS [dbo];

