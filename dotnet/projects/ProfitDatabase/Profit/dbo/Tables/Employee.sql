CREATE TABLE [dbo].[Employee] (
    [EmployeeId]        INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]         INT           NOT NULL,
    [DepartmentId]      INT           NOT NULL,
    [EmployeeProfileId] INT           NOT NULL,
    [FirstName]         VARCHAR (50)  NOT NULL,
    [LastName]          VARCHAR (50)  NOT NULL,
    [Title]             VARCHAR (25)  NULL,
    [IdNumber]          VARCHAR (25)  NULL,
    [Address]           VARCHAR (200) NULL,
    [City]              VARCHAR (25)  NULL,
    [StateId]           INT           NOT NULL,
    [CountryId]         INT           NOT NULL,
    [Gender]            VARCHAR (1)   NULL,
    [PostalCode]        VARCHAR (25)  NULL,
    [Phone]             VARCHAR (25)  NULL,
    [Fax]               VARCHAR (25)  NULL,
    [MobilePhone]       VARCHAR (25)  NULL,
    [EmailAddress]      VARCHAR (50)  NULL,
    [Birthday]          DATETIME      NULL,
    [IsActive]          BIT           NOT NULL,
    [MaritalStatus]     VARCHAR (1)   NULL,
    [DateHired]         DATETIME      NULL,
    [Deductions]        MONEY         CONSTRAINT [DF_Employee_Deductions] DEFAULT ((0)) NULL,
    [Salary]            MONEY         CONSTRAINT [DF_Employee_Salary] DEFAULT ((0)) NULL,
    [ContactName]       VARCHAR (50)  NULL,
    [ContactPhone]      VARCHAR (25)  NULL,
    [InsertUser]        INT           NOT NULL,
    [InsertDate]        DATETIME      NOT NULL,
    [LastUpdateUser]    INT           NULL,
    [LastUpdateDate]    DATETIME      NULL,
    [RowInfo]           ROWVERSION    NULL,
    CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([EmployeeId] ASC),
    CONSTRAINT [CK_Employee_Birthday] CHECK ([Birthday]<getdate()),
    CONSTRAINT [CK_Employee_DateHired] CHECK ([DateHired]<(getdate()+(1))),
    CONSTRAINT [CK_Employee_Deductions] CHECK ([Deductions]>=(0)),
    CONSTRAINT [CK_Employee_Salary] CHECK ([Salary]>=(0)),
    CONSTRAINT [FK_Employee_Company] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([CompanyId]),
    CONSTRAINT [FK_Employee_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Country] ([CountryId]),
    CONSTRAINT [FK_Employee_Department] FOREIGN KEY ([DepartmentId]) REFERENCES [dbo].[Department] ([DepartmentId]),
    CONSTRAINT [FK_Employee_EmployeeProfile] FOREIGN KEY ([EmployeeProfileId]) REFERENCES [dbo].[EmployeeProfile] ([EmployeeProfileId]),
    CONSTRAINT [FK_Employee_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Employee_Company]
    ON [dbo].[Employee]([CompanyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Employee_CompanyCountry]
    ON [dbo].[Employee]([CompanyId] ASC, [CountryId] ASC);


GO
GRANT DELETE
    ON OBJECT::[dbo].[Employee] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[Employee] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Employee] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[Employee] TO [profit_role_fullaccess]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Employee] TO [profit_role_datareader]
    AS [dbo];

