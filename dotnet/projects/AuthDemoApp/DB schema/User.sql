DROP TABLE [dbo].[User]
GO

CREATE TABLE [dbo].[User] (
    [ID]        INT           IDENTITY (1, 1) NOT NULL,
    [FirstName] NVARCHAR (50) NOT NULL,
    [LastName]  NVARCHAR (50) NOT NULL,
    [Email]     NVARCHAR (100) NOT NULL UNIQUE,
    [PasswordHash]  NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([ID] ASC)
)
GO