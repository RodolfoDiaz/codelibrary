CREATE TABLE [Audit].[AuditLog] (
    [AuditLogId]      BIGINT           IDENTITY (1, 1) NOT NULL,
    [AuditDate]       DATETIME2 (3)    CONSTRAINT [DF_AuditLog_AuditDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [ActionType]      VARCHAR (10)     NOT NULL,
    [SchemaName]      [sysname]        NOT NULL,
    [TableName]       [sysname]        NOT NULL,
    [RecordId]        BIGINT           NULL,
    [CompanyId]       INT              NULL,
    [UserId]          INT              NULL,
    [ApplicationUser] NVARCHAR (256)   NULL,
    [ApplicationName] NVARCHAR (128)   NULL,
    [HostName]        NVARCHAR (128)   NULL,
    [IpAddress]       VARCHAR (48)     NULL,
    [SessionId]       INT              NULL,
    [CorrelationId]   UNIQUEIDENTIFIER NULL,
    [OldValues]       NVARCHAR (MAX)   NULL,
    [NewValues]       NVARCHAR (MAX)   NULL,
    [ChangedColumns]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED ([AuditLogId] ASC),
    CONSTRAINT [CK_AuditLog_Action] CHECK ([ActionType]='DELETE' OR [ActionType]='UPDATE' OR [ActionType]='INSERT'),
    CONSTRAINT [CK_AuditLog_ChangedJson] CHECK ([ChangedColumns] IS NULL OR isjson([ChangedColumns])=(1)),
    CONSTRAINT [CK_AuditLog_NewJson] CHECK ([NewValues] IS NULL OR isjson([NewValues])=(1)),
    CONSTRAINT [CK_AuditLog_OldJson] CHECK ([OldValues] IS NULL OR isjson([OldValues])=(1))
);


GO
CREATE NONCLUSTERED INDEX [IX_AuditLog_Record]
    ON [Audit].[AuditLog]([SchemaName] ASC, [TableName] ASC, [RecordId] ASC, [AuditDate] DESC)
    INCLUDE([ActionType], [CompanyId], [UserId]);


GO
CREATE NONCLUSTERED INDEX [IX_AuditLog_Company_Date]
    ON [Audit].[AuditLog]([CompanyId] ASC, [AuditDate] DESC)
    INCLUDE([SchemaName], [TableName], [RecordId], [ActionType], [UserId]);


GO
CREATE NONCLUSTERED INDEX [IX_AuditLog_User_Date]
    ON [Audit].[AuditLog]([UserId] ASC, [AuditDate] DESC)
    INCLUDE([SchemaName], [TableName], [RecordId], [ActionType], [CompanyId]);

