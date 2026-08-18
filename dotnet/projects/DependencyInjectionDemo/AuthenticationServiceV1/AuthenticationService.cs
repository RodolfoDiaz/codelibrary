public class AuthenticationService
{
    private readonly FileLogger _logger;

    public AuthenticationService()
    {
        // Tight coupling: Instantiating the concrete class directly
        _logger = new FileLogger();
    }

    public bool Authenticate(string username, string password)
    {
        // TODO: Implement core authentication logic...
        bool isValid = username == "admin" && password == "S3cre7";

        if (isValid)
        {
            _logger.Log($"Audit Trail: User '{username}' logged in successfully.");
        }
        else
        {
            _logger.Log($"Audit Trail: Failed login attempt for user '{username}'.");
        }

        return isValid;
    }
}