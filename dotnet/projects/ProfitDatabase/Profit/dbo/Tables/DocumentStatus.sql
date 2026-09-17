CREATE TABLE [dbo].[DocumentStatus] (
    [DocumentStatusId] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT          NOT NULL,
    [Name]             VARCHAR (50) NOT NULL,
    [InsertUser]       INT          NOT NULL,
    [InsertDate]       DATETIME     NOT NULL,
    [LastUpdateUser]   INT          NULL,
    [LastUpdateDate]   DATETIME     NULL,
    [RowInfo]          ROWVERSION   NULL,
    CONSTRAINT [PK_DocumentStatus] PRIMARY KEY CLUSTERED ([DocumentStatusId] ASC),
    CONSTRAINT [FK_DocumentStatus_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_DocumentStatus_Company]
    ON [dbo].[DocumentStatus]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[DocumentStatus] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[DocumentStatus] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[DocumentStatus] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[DocumentStatus] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[DocumentStatus] TO [profit_role_datareader]
    AS [dbo];

