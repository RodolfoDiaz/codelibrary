using AuthDemoApp.Core.Models;

namespace AuthDemoApp.Core.Services;

///
/// In-memory mock service designed for xUnit tests without requiring SQL Server connection.
/// 
public class MockAuthenticationService : IAuthService
{
    private readonly List<User> _users;
    private readonly IPasswordHasher _passwordHasher;

    public MockAuthenticationService(IPasswordHasher passwordHasher, IEnumerable<User>? seedUsers = null)
    {
        _passwordHasher = passwordHasher;
        _users = seedUsers?.ToList() ?? new List<User>();
    }

    public Task<User?> AuthenticateAsync(string email, string password)
    {
        var user = _users.FirstOrDefault(u => u.Email.Equals(email, StringComparison.OrdinalIgnoreCase));
        if (user == null) return Task.FromResult<User?>(null);

        bool isValid = _passwordHasher.VerifyPassword(password, user.Password);
        return Task.FromResult(isValid ? user : null);
    }

    public Task<bool> RegisterAsync(User user, string rawPassword)
    {
        if (_users.Any(u => u.Email.Equals(user.Email, StringComparison.OrdinalIgnoreCase)))
            return Task.FromResult(false);

        user.Id = _users.Count + 1;
        user.Password = _passwordHasher.HashPassword(rawPassword);
        _users.Add(user);

        return Task.FromResult(true);
    }

    public Task<bool> UserExistsAsync(string email)
    {
        return Task.FromResult(_users.Any(u => u.Email.Equals(email, StringComparison.OrdinalIgnoreCase)));
    }
}