CREATE TABLE [dbo].[UserInfo] (
    [UserInfoId]     INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]      INT          NOT NULL,
    [FirstName]      VARCHAR (50) NULL,
    [LastName]       VARCHAR (50) NULL,
    [SidName]        VARCHAR (50) NOT NULL,
    [Culture]        VARCHAR (5)  NOT NULL,
    [Role]           SMALLINT     NOT NULL,
    [InsertUser]     INT          NOT NULL,
    [InsertDate]     DATETIME     NOT NULL,
    [LastUpdateUser] INT          NULL,
    [LastUpdateDate] DATETIME     NULL,
    [RowInfo]        ROWVERSION   NULL,
    CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED ([UserInfoId] ASC),
    CONSTRAINT [CK_UserInfo] CHECK ([Role]>=(0) AND [Role]<=(10)),
    CONSTRAINT [FK_UserInfo_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_UserInfo_Company]
    ON [dbo].[UserInfo]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[UserInfo] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[UserInfo] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[UserInfo] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[UserInfo] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[UserInfo] TO [profit_role_datareader]
    AS [dbo];

