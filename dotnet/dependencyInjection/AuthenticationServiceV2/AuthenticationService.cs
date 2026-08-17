// 1. Abstraction
public interface IAuditLogger
{
    void LogAudit(string message);
}

// 2. The core service depends only on the interface (Dependency Inversion Principle)
public class AuthenticationService
{
    private readonly IAuditLogger _logger;

    // Dependency Injection via constructor
    public AuthenticationService(IAuditLogger logger)
    {
        _logger = logger;
    }

    public bool Authenticate(string username, string password)
    {
        // TODO: Implement core authentication logic...
        bool isValid = username == "admin" && password == "S3cre7";

        if (isValid)
        {
            _logger.LogAudit($"User '{username}' logged in successfully.");
        }
        else
        {
            _logger.LogAudit($"Failed login attempt for user '{username}'.");
        }

        return isValid;
    }
}