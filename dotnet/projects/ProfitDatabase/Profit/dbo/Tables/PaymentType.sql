CREATE TABLE [dbo].[PaymentType] (
    [PaymentTypeId]  INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [Period]         SMALLINT     CONSTRAINT [DF_PaymentType_Period] DEFAULT ((0)) NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED ([PaymentTypeId] ASC),
    CONSTRAINT [CK_PaymentType_Period] CHECK ([Period]>=(0)),
    CONSTRAINT [FK_PaymentType_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_PaymentType_Company]
    ON [dbo].[PaymentType]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[PaymentType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[PaymentType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[PaymentType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[PaymentType] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[PaymentType] TO [profit_role_datareader]
    AS [dbo];

