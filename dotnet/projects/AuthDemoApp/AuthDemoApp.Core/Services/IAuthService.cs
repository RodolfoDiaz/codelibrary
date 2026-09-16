using AuthDemoApp.Core.Models;

namespace AuthDemoApp.Core.Services;

public interface IAuthService
{
    Task<User?> AuthenticateAsync(string email, string password);
    Task<bool> RegisterAsync(User user, string rawPassword);
    Task<bool> UserExistsAsync(string email);
}