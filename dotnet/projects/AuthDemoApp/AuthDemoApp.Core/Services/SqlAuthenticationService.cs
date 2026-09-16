using System.Data;
using AuthDemoApp.Core.Models;
using Microsoft.Data.SqlClient;

namespace AuthDemoApp.Core.Services;

///
/// Connects directly to MS SQL Server using ADO.NET (Microsoft.Data.SqlClient).
/// 
public class SqlAuthenticationService : IAuthService
{
    private readonly string _connectionString;
    private readonly IPasswordHasher _passwordHasher;

    public SqlAuthenticationService(string connectionString, IPasswordHasher passwordHasher)
    {
        _connectionString = connectionString;
        _passwordHasher = passwordHasher;
    }

    public async Task<User?> AuthenticateAsync(string email, string password)
    {
        const string query = "SELECT ID, FirstName, LastName, Email, Password FROM [User] WHERE Email = @Email";

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(query, connection);
        command.Parameters.AddWithValue("@Email", email);

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync(CommandBehavior.SingleRow);

        if (!await reader.ReadAsync()) return null;

        string storedHash = reader.GetString(4);
        if (!_passwordHasher.VerifyPassword(password, storedHash)) return null;

        return new User
        {
            Id = reader.GetInt32(0),
            FirstName = reader.GetString(1),
            LastName = reader.GetString(2),
            Email = reader.GetString(3),
            Password = storedHash
        };
    }

    public async Task<bool> RegisterAsync(User user, string rawPassword)
    {
        if (await UserExistsAsync(user.Email)) return false;

        string hashedPassword = _passwordHasher.HashPassword(rawPassword);
        const string query = @"
            INSERT INTO [User] (FirstName, LastName, Email, Password) 
            VALUES (@FirstName, @LastName, @Email, @Password)";

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(query, connection);
        command.Parameters.AddWithValue("@FirstName", user.FirstName);
        command.Parameters.AddWithValue("@LastName", user.LastName);
        command.Parameters.AddWithValue("@Email", user.Email);
        command.Parameters.AddWithValue("@Password", hashedPassword);

        await connection.OpenAsync();
        int rows = await command.ExecuteNonQueryAsync();
        return rows > 0;
    }

    public async Task<bool> UserExistsAsync(string email)
    {
        const string query = "SELECT COUNT(1) FROM [User] WHERE Email = @Email";

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(query, connection);
        command.Parameters.AddWithValue("@Email", email);

        await connection.OpenAsync();
        int count = Convert.ToInt32(await command.ExecuteScalarAsync());
        return count > 0;
    }
}