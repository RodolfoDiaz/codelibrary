CREATE TABLE [Reference].[TaxCodes] (
    [TaxCodeId]     INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]     INT            NOT NULL,
    [Code]          NVARCHAR (30)  NOT NULL,
    [Name]          NVARCHAR (100) NOT NULL,
    [Rate]          DECIMAL (9, 4) NOT NULL,
    [IsRecoverable] BIT            CONSTRAINT [DF_TaxCodes_Recoverable] DEFAULT ((0)) NOT NULL,
    [IsActive]      BIT            CONSTRAINT [DF_TaxCodes_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]    ROWVERSION     NOT NULL,
    CONSTRAINT [PK_TaxCodes] PRIMARY KEY CLUSTERED ([TaxCodeId] ASC),
    CONSTRAINT [CK_TaxCodes_Rate] CHECK ([Rate]>=(0)),
    CONSTRAINT [FK_TaxCodes_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_TaxCodes] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC),
    CONSTRAINT [UQ_TaxCodes_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [TaxCodeId] ASC)
);

