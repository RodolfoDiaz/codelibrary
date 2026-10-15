
/* ---------------------------------------------------------------------------
   Journal validation / posting
--------------------------------------------------------------------------- */
CREATE   PROCEDURE [Finance].[PostJournalEntry]
    @CompanyId int,
    @JournalEntryId bigint
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Debit decimal(19,4), @Credit decimal(19,4), @Status nvarchar(30);

    BEGIN TRANSACTION;

    SELECT @Status = StatusCode
    FROM [Finance].[JournalEntries] WITH (UPDLOCK, HOLDLOCK)
    WHERE CompanyId = @CompanyId
      AND JournalEntryId = @JournalEntryId;

    IF @Status IS NULL
        THROW 51030, 'Journal entry not found.', 1;

    IF @Status = N'POSTED'
    BEGIN
        COMMIT;
        RETURN;
    END;

    SELECT
        @Debit = SUM(DebitAmount),
        @Credit = SUM(CreditAmount)
    FROM [Finance].[JournalEntryLines]
    WHERE CompanyId = @CompanyId
      AND JournalEntryId = @JournalEntryId;

    IF ISNULL(@Debit,0) = 0 OR ISNULL(@Debit,0) <> ISNULL(@Credit,0)
        THROW 51031, 'Journal entry is not balanced.', 1;

    UPDATE [Finance].[JournalEntries]
       SET StatusCode = N'POSTED'
     WHERE CompanyId = @CompanyId
       AND JournalEntryId = @JournalEntryId;

    COMMIT;
END;
