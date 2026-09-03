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
            using (HashAlgorithm hashAlgorithm = algorithm switch
            {
                ServiceProvider.MD5 => MD5.Create(),
                ServiceProvider.SHA1 => SHA1.Create(),
                ServiceProvider.SHA256 => SHA256.Create(),
                ServiceProvider.SHA384 => SHA384.Create(),
                ServiceProvider.SHA512 => SHA512.Create(),
                _ => throw new ArgumentException("Unknown hash algorithm", nameof(algorithm))
            })
            {
                byte[] data = hashAlgorithm.ComputeHash(inputBytes);

                // Create a new StringBuilder to collect the bytes and create a string.
                StringBuilder sBuilder = new StringBuilder();

                // Loop through each byte of the hashed data 
                // and format each one as a hexadecimal string.
                for (int i = 0; i < data.Length; i++)
                {
                    sBuilder.Append(data[i].ToString("X2"));
                }

                // Return the hexadecimal string.
                return sBuilder.ToString();
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
