

/* ---------------------------------------------------------------------------
   Generic optimistic-concurrency helper
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Core].[TouchUpdatedAt]
    @TableName sysname,
    @IdColumn sysname,
    @IdValue bigint
AS
BEGIN
    SET NOCOUNT ON;
    /* Intentionally restricted: application tables should use rowversion.
       This procedure is retained only as a controlled extension point. */
    THROW 51001, 'Use rowversion-based updates instead of manually touching audit timestamps.', 1;
END;
