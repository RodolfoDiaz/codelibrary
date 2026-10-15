CREATE TABLE [Reference].[PaymentMethods] (
    [PaymentMethodId] INT            IDENTITY (1, 1) NOT NULL,
    [CompanyId]       INT            NOT NULL,
    [Code]            NVARCHAR (30)  NOT NULL,
    [Name]            NVARCHAR (100) NOT NULL,
    [PaymentTermDays] INT            CONSTRAINT [DF_PaymentMethods_Term] DEFAULT ((0)) NOT NULL,
    [IsActive]        BIT            CONSTRAINT [DF_PaymentMethods_IsActive] DEFAULT ((1)) NOT NULL,
    [RowVersion]      ROWVERSION     NOT NULL,
    CONSTRAINT [PK_PaymentMethods] PRIMARY KEY CLUSTERED ([PaymentMethodId] ASC),
    CONSTRAINT [CK_PaymentMethods_Term] CHECK ([PaymentTermDays]>=(0)),
    CONSTRAINT [FK_PaymentMethods_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [Core].[Companies] ([CompanyId]),
    CONSTRAINT [UQ_PaymentMethods] UNIQUE NONCLUSTERED ([CompanyId] ASC, [Code] ASC),
    CONSTRAINT [UQ_PaymentMethods_Company_Id] UNIQUE NONCLUSTERED ([CompanyId] ASC, [PaymentMethodId] ASC)
);

