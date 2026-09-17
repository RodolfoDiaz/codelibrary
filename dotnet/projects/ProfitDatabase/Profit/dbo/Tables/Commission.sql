CREATE TABLE [dbo].[Commission] (
    [CommissionId]   INT        IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT        NOT NULL,
    [EmployeeId]     INT        NOT NULL,
    [DocumentId]     INT        NOT NULL,
    [DocDate]        DATETIME   NOT NULL,
    [Amount]         MONEY      NOT NULL,
    [ExchangeRate]   MONEY      NOT NULL,
    [InsertUser]     INT        NOT NULL,
    [InsertDate]     DATETIME   NOT NULL,
    [LastUpdateUser] INT        NULL,
    [LastUpdateDate] DATETIME   NULL,
    [RowInfo]        ROWVERSION NULL,
    CONSTRAINT [PK_Commission] PRIMARY KEY CLUSTERED ([CommissionId] ASC),
    CONSTRAINT [CK_Commission_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_Commission_ExchangeRate] CHECK ([ExchangeRate]>(0)),
    CONSTRAINT [FK_Commission_ClientDocument] FOREIGN KEY ([DocumentId]) REFERENCES [dbo].[ClientDocument] ([DocumentId]),
    CONSTRAINT [FK_Commission_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_Commission_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Employee] ([EmployeeId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Commission_Company]
    ON [dbo].[Commission]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Commission_CompanyEmployee]
    ON [dbo].[Commission]([CompanyId] ASC, [EmployeeId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Commission] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Commission] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Commission] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Commission] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Commission] TO [profit_role_datareader]
    AS [dbo];

