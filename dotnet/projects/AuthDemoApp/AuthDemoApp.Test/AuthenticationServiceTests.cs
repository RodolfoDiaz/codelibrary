using AuthDemoApp.Core.Models;
using AuthDemoApp.Core.Services;
using Xunit;

namespace AuthDemoApp.Test;

public class AuthenticationServiceTests
{
    private readonly IPasswordHasher _passwordHasher;

    public AuthenticationServiceTests()
    {
        _passwordHasher = new PasswordHasher();
    }

    private MockAuthenticationService CreateTestServiceWithSeedData()
    {
        var seedUsers = new List<User>
        {
            new()
            {
                Id = 1,
                FirstName = "Jane",
                LastName = "Doe",
                Email = "jane.doe@example.com",
                Password = _passwordHasher.HashPassword("SecureP@ss123")
            }
        };

        return new MockAuthenticationService(_passwordHasher, seedUsers);
    }

    [Fact]
    public async Task AuthenticateAsync_ValidCredentials_ReturnsUser()
    {
        var service = CreateTestServiceWithSeedData();

        var result = await service.AuthenticateAsync("jane.doe@example.com", "SecureP@ss123");

        Assert.NotNull(result);
        Assert.Equal("Jane", result.FirstName);
        Assert.Equal("jane.doe@example.com", result.Email);
    }

    [Fact]
    public async Task AuthenticateAsync_InvalidPassword_ReturnsNull()
    {
        var service = CreateTestServiceWithSeedData();

        var result = await service.AuthenticateAsync("jane.doe@example.com", "WrongPassword");

        Assert.Null(result);
    }

    [Fact]
    public async Task AuthenticateAsync_NonExistentEmail_ReturnsNull()
    {
        var service = CreateTestServiceWithSeedData();

        var result = await service.AuthenticateAsync("unknown@example.com", "SecureP@ss123");

        Assert.Null(result);
    }

    [Fact]
    public async Task RegisterAsync_NewUser_RegistersSuccessfullyAndCanAuthenticate()
    {
        var service = CreateTestServiceWithSeedData();
        var newUser = new User { FirstName = "John", LastName = "Smith", Email = "john.smith@example.com" };

        bool registered = await service.RegisterAsync(newUser, "MyNewP@ss456");
        var authenticatedUser = await service.AuthenticateAsync("john.smith@example.com", "MyNewP@ss456");

        Assert.True(registered);
        Assert.NotNull(authenticatedUser);
        Assert.Equal("John", authenticatedUser.FirstName);
    }

    [Fact]
    public async Task RegisterAsync_DuplicateEmail_ReturnsFalse()
    {
        var service = CreateTestServiceWithSeedData();
        var duplicateUser = new User { FirstName = "Jane", LastName = "Copy", Email = "jane.doe@example.com" };

        bool registered = await service.RegisterAsync(duplicateUser, "AnyPassword123");

        Assert.False(registered);
    }
}