using System;
using System.Text;
using System.Security.Cryptography;
using System.IO;

namespace CryptographyLibrary.Lib
{
    static class CipherUtility
    {
        private const int PBKDF2_ITERATIONS = 10000; // Modern OWASP/NIST recommendation baseline is 600,000 iterations (PROD). For testing, we can use a lower value like 10,000 iterations.

        public static string Encrypt(SymmetricAlgorithm algorithm, string value, string password, string salt)
        {
            byte[] saltBytes = Encoding.Unicode.GetBytes(salt);
            byte[] rgbKey = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, PBKDF2_ITERATIONS, HashAlgorithmName.SHA256, algorithm.KeySize >> 3);
            byte[] rgbIV = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, PBKDF2_ITERATIONS, HashAlgorithmName.SHA256, algorithm.BlockSize >> 3);

            ICryptoTransform transform = algorithm.CreateEncryptor(rgbKey, rgbIV);

            using (MemoryStream buffer = new MemoryStream())
            {
                using (CryptoStream stream = new CryptoStream(buffer, transform, CryptoStreamMode.Write))
                {
                    using (StreamWriter writer = new StreamWriter(stream, Encoding.Unicode))
                    {
                        writer.Write(value);
                    }
                }

                return Convert.ToBase64String(buffer.ToArray());
            }
        }

        public static string Decrypt(SymmetricAlgorithm algorithm, string text, string password, string salt)
        {
            byte[] saltBytes = Encoding.Unicode.GetBytes(salt);
            byte[] rgbKey = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, PBKDF2_ITERATIONS, HashAlgorithmName.SHA256, algorithm.KeySize >> 3);
            byte[] rgbIV = Rfc2898DeriveBytes.Pbkdf2(password, saltBytes, PBKDF2_ITERATIONS, HashAlgorithmName.SHA256, algorithm.BlockSize >> 3);

            ICryptoTransform transform = algorithm.CreateDecryptor(rgbKey, rgbIV);

            using (MemoryStream buffer = new MemoryStream(Convert.FromBase64String(text)))
            {
                using (CryptoStream stream = new CryptoStream(buffer, transform, CryptoStreamMode.Read))
                {
                    using (StreamReader reader = new StreamReader(stream, Encoding.Unicode))
                    {
                        return reader.ReadToEnd();
                    }
                }
            }
        }
    }
}
