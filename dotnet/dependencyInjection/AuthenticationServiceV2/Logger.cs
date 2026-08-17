// Case 1: File Logger
public class FileAuditLogger : IAuditLogger
{
    private readonly string _filePath;

    public FileAuditLogger(string filePath = "audit.log")
    {
        _filePath = filePath;
    }

    public void LogAudit(string message)
    {
        File.AppendAllText(_filePath, $"[FILE LOG] [{DateTime.UtcNow}] {message}{Environment.NewLine}");
    }
}

// Case 2: On-Premise SQL Database Logger
public class SqlDatabaseAuditLogger : IAuditLogger
{
    private readonly string _connectionString;

    public SqlDatabaseAuditLogger(string connectionString)
    {
        _connectionString = connectionString;
    }

    public void LogAudit(string message)
    {
        // TODO: Insert audit trail record into an on-premise SQL Database table
        Console.WriteLine($"[SQL DB LOG] Connected to '{_connectionString}' -> Saved: {message}");
    }
}

// Case 3: Cloud-Based Repository Logger
public class CloudAuditLogger : IAuditLogger
{
    private readonly string _apiKey;

    public CloudAuditLogger(string apiKey)
    {
        _apiKey = apiKey;
    }

    public void LogAudit(string message)
    {
        // TODO: Send audit payload over HTTP to a cloud logging API (e.g., Azure Monitor, AWS CloudWatch)
        Console.WriteLine($"[CLOUD LOG] Sent to cloud endpoint via API Key '{_apiKey}' -> Saved: {message}");
    }
}