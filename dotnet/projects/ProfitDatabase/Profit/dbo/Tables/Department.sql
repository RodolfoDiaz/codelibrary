CREATE TABLE [dbo].[Department] (
    [DepartmentId]   INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT           NOT NULL,
    [Name]           VARCHAR (50)  NOT NULL,
    [Location]       VARCHAR (200) NULL,
    [InsertUser]     INT           NOT NULL,
    [InsertDate]     DATETIME      NOT NULL,
    [LastUpdateUser] INT           NULL,
    [LastUpdateDate] DATETIME      NULL,
    [RowInfo]        ROWVERSION    NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([DepartmentId] ASC),
    CONSTRAINT [FK_Department_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Department_Company]
    ON [dbo].[Department]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Department] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Department] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Department] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Department] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Department] TO [profit_role_datareader]
    AS [dbo];

