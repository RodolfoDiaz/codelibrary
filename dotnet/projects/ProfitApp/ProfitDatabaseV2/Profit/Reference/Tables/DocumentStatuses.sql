CREATE TABLE [Reference].[DocumentStatuses] (
    [DocumentStatusId] INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]        INT            NOT NULL,
    [Code]             NVARCHAR (30)  NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [IsPosted]         BIT            CONSTRAINT [DF_DocumentStatuses_IsPosted] DEFAULT ((0)) NOT NULL,
    [IsActive]         BIT            CONSTRAINT [DF_DocumentStatuses_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]       ROWVERSION     NOT NULL,
    CONSTRAINT [PK_DocumentStatuses] PRIMARY KEY CLUSTERED ([DocumentStatusId] ASC),
    CONSTRAINT [FK_DocumentStatuses_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_DocumentStatuses] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC)
);

