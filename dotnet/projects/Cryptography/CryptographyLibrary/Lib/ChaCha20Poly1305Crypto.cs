using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace CryptographyLibrary.Lib
{
    static class ChaCha20Poly1305Crypto
    {
        private const int KeySize = 32;       // 256-bit key
        private const int NonceSize = 12;     // 96-bit nonce
        private const int TagSize = 16;       // 128-bit authentication tag
        private const int SaltSize = 16;      // 128-bit salt
        private const int Pbkdf2Iterations = 600_000; // OWASP recommended minimum for PBKDF2-HMAC-SHA256

        public static string Encrypt(string plainText, string password)
        {
            if (string.IsNullOrEmpty(plainText))
                throw new ArgumentNullException(nameof(plainText));
            if (string.IsNullOrEmpty(password))
                throw new ArgumentNullException(nameof(password));

            byte[] plainBytes = Encoding.UTF8.GetBytes(plainText);

            byte[] salt = RandomNumberGenerator.GetBytes(SaltSize);
            byte[] nonce = RandomNumberGenerator.GetBytes(NonceSize);

            // Derive 256-bit key using the non-obsolete static method
            byte[] key = DeriveKey(password, salt);

            byte[] cipherText = new byte[plainBytes.Length];
            byte[] tag = new byte[TagSize];

            using (var chacha = new ChaCha20Poly1305(key))
            {
                chacha.Encrypt(nonce, plainBytes, cipherText, tag);
            }

            using var ms = new MemoryStream();
            using var writer = new BinaryWriter(ms);
            writer.Write(salt);
            writer.Write(nonce);
            writer.Write(tag);
            writer.Write(cipherText);

            return Convert.ToBase64String(ms.ToArray());
        }

        public static string Decrypt(string cipherPayloadBase64, string password)
        {
            if (string.IsNullOrEmpty(cipherPayloadBase64))
                throw new ArgumentNullException(nameof(cipherPayloadBase64));
            if (string.IsNullOrEmpty(password))
                throw new ArgumentNullException(nameof(password));

            byte[] payload = Convert.FromBase64String(cipherPayloadBase64);

            if (payload.Length < SaltSize + NonceSize + TagSize)
                throw new CryptographicException("Invalid ciphertext payload length.");

            using var ms = new MemoryStream(payload);
            using var reader = new BinaryReader(ms);

            byte[] salt = reader.ReadBytes(SaltSize);
            byte[] nonce = reader.ReadBytes(NonceSize);
            byte[] tag = reader.ReadBytes(TagSize);
            byte[] cipherText = reader.ReadBytes(payload.Length - (SaltSize + NonceSize + TagSize));

            // Derive key using the exact same static PBKDF2 method
            byte[] key = DeriveKey(password, salt);

            byte[] plainBytes = new byte[cipherText.Length];

            using (var chacha = new ChaCha20Poly1305(key))
            {
                chacha.Decrypt(nonce, cipherText, tag, plainBytes);
            }

            return Encoding.UTF8.GetString(plainBytes);
        }

        /// <summary>
        /// Derives key using static Rfc2898DeriveBytes.Pbkdf2 (non-obsolete API).
        /// </summary>
        private static byte[] DeriveKey(string password, byte[] salt)
        {
            return Rfc2898DeriveBytes.Pbkdf2(
                password: password,
                salt: salt,
                iterations: Pbkdf2Iterations,
                hashAlgorithm: HashAlgorithmName.SHA256,
                outputLength: KeySize
            );
        }
    }
}