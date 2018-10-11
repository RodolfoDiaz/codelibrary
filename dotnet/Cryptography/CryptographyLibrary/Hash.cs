using CryptographyLibrary.Lib;
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace CryptographyLibrary
{
    /// <summary>
    /// Hashing serves the purpose of ensuring integrity, i.e. making it so that if something is changed you can know that it’s changed. 
    /// </summary>
    public class Hash
    {
        public enum ServiceProvider
        {
            /// <summary>
            /// MD5 hash algorithm
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.md5"/>
            MD5,
            /// <summary>
            /// SHA1 hash algorithm
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.sha1"/>
            SHA1,
            /// <summary>
            /// SHA256 hash algorithm
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.sha256"/>
            SHA256,
            /// <summary>
            /// SHA384 hash algorithm
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.sha384"/>
            SHA384,
            /// <summary>
            /// SHA512 hash algorithm
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.sha512"/>
            SHA512
        }

        public static string GetHash(ServiceProvider algorithm, string input)
        {
            // Convert the input string to a byte array
            byte[] inputBytes = Encoding.UTF8.GetBytes(input);
            return GetHash(algorithm, inputBytes);
        }

        public static string GetHash(ServiceProvider algorithm, byte[] inputBytes)
        {
            switch (algorithm)
            {
                case ServiceProvider.MD5:
                    return HashUtility.GetHash<MD5CryptoServiceProvider>(inputBytes);
                case ServiceProvider.SHA1:
                    return HashUtility.GetHash<SHA1CryptoServiceProvider>(inputBytes);
                case ServiceProvider.SHA256:
                    return HashUtility.GetHash<SHA256CryptoServiceProvider>(inputBytes);
                case ServiceProvider.SHA384:
                    return HashUtility.GetHash<SHA384CryptoServiceProvider>(inputBytes);
                case ServiceProvider.SHA512:
                    return HashUtility.GetHash<SHA512CryptoServiceProvider>(inputBytes);
                default:
                    return null;
            }
        }

        public static bool VerifyHash(ServiceProvider algorithm, string input, string hash)
        {
            // Hash the input.
            string hashOfInput = GetHash(algorithm, input);

            // Create a StringComparer and compare the hashes.
            StringComparer comparer = StringComparer.OrdinalIgnoreCase;

            if (0 == comparer.Compare(hashOfInput, hash))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static string GetHashFromFile(ServiceProvider algorithm, string filePath)
        {
            if (!File.Exists(filePath))
            {
                throw new ArgumentException("File path is not valid.");
            }
            byte[] inputBytes = File.ReadAllBytes(filePath);
            return GetHash(algorithm, inputBytes);
        }
    }
}
