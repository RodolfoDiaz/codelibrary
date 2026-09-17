CREATE TABLE [dbo].[EmployeeProfile] (
    [EmployeeProfileId] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT          NOT NULL,
    [Name]              VARCHAR (50) NOT NULL,
    [Commission]        MONEY        CONSTRAINT [DF_EmployeeProfile_Commission] DEFAULT ((0)) NOT NULL,
    [InsertUser]        INT          NOT NULL,
    [InsertDate]        DATETIME     NOT NULL,
    [LastUpdateUser]    INT          NULL,
    [LastUpdateDate]    DATETIME     NULL,
    [RowInfo]           ROWVERSION   NULL,
    CONSTRAINT [PK_EmployeeProfile] PRIMARY KEY CLUSTERED ([EmployeeProfileId] ASC),
    CONSTRAINT [CK_EmployeeProfile_Commission] CHECK ([Commission]>=(0) AND [Commission]<=(1)),
    CONSTRAINT [FK_EmployeeProfile_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId])
);


GO
CREATE NONCLUSTERED INDEX [IX_EmployeeProfile_Company]
    ON [dbo].[EmployeeProfile]([CompanyId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[EmployeeProfile] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[EmployeeProfile] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[EmployeeProfile] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[EmployeeProfile] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[EmployeeProfile] TO [profit_role_datareader]
    AS [dbo];

