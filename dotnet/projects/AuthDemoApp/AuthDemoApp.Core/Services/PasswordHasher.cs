using System.Security.Cryptography;

namespace AuthDemoApp.Core.Services;

public interface IPasswordHasher
{
    string HashPassword(string password);
    bool VerifyPassword(string password, string hashedPassword);
}

///
/// Password hashing uses PBKDF2 with HMAC-SHA256 and a secure random 
/// salt to ensure passwords are never stored in plain text.
/// 
public class PasswordHasher : IPasswordHasher
{
    private const int SaltSize = 16;
    private const int KeySize = 32;
    private const int Iterations = 100_000;
    private static readonly HashAlgorithmName Algorithm = HashAlgorithmName.SHA256;

    public string HashPassword(string password)
    {
        byte[] salt = RandomNumberGenerator.GetBytes(SaltSize);
        byte[] hash = Rfc2898DeriveBytes.Pbkdf2(password, salt, Iterations, Algorithm, KeySize);

        byte[] result = new byte[SaltSize + KeySize];
        Buffer.BlockCopy(salt, 0, result, 0, SaltSize);
        Buffer.BlockCopy(hash, 0, result, SaltSize, KeySize);

        return Convert.ToBase64String(result);
    }

    public bool VerifyPassword(string password, string hashedPassword)
    {
        byte[] decodedHash = Convert.FromBase64String(hashedPassword);
        if (decodedHash.Length != SaltSize + KeySize) return false;

        byte[] salt = new byte[SaltSize];
        Buffer.BlockCopy(decodedHash, 0, salt, 0, SaltSize);

        byte[] expectedHash = new byte[KeySize];
        Buffer.BlockCopy(decodedHash, SaltSize, expectedHash, 0, KeySize);

        byte[] actualHash = Rfc2898DeriveBytes.Pbkdf2(password, salt, Iterations, Algorithm, KeySize);

        return CryptographicOperations.FixedTimeEquals(actualHash, expectedHash);
    }
}