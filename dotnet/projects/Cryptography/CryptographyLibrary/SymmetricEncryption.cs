using CryptographyLibrary.Lib;
using System;
using System.Security.Cryptography;

namespace CryptographyLibrary
{
    /// <summary>
    /// Symmetric-key algorithms are algorithms for cryptography that use the same cryptographic keys for both encryption of plaintext and decryption of ciphertext.
    /// </summary>
    /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.symmetricalgorithm"/>
    public static class SymmetricEncryption
    {
        public enum ServiceProvider
        {
            /// <summary>
            /// AES (Advanced Encryption Standard). It is the recommended option.
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.aes"/>
            AES,
            /// <summary>
            /// ChaCha20-Poly1305 is a stream cipher and message authentication code combination that is designed to be fast and secure.
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.chacha20poly1305"/>
            ChaCha20Poly1305,
            /// <summary>
            /// DES symmetric encryption algorithm. Use DES only for compatibility with legacy applications and data.
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.des"/>
            DES,
            /// <summary>
            /// RC2 symmetric encryption algorithm. Use RC2 only for compatibility with legacy applications and data.
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.rc2"/>
            RC2,
            /// <summary>
            /// Triple DES (Data Encryption Standard). Use TripleDES only for compatibility with legacy applications and data.
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.tripledes"/>
            TripleDES
        }

        /// <summary>
        /// Encrypt method
        /// </summary>
        /// <param name="algorithm">Encryption algorithm to use</param>
        /// <param name="plainText">A message or text to encrypt</param>
        /// <param name="password">A password is a word or string of characters used for user authentication to prove identity or access approval to gain access to a resource, which is to be kept secret from those not allowed access.</param>
        /// <param name="salt">In cryptography, a salt is random data that is used as an additional input to a one-way function that "hashes" data, a password or passphrase.</param>
        /// <returns>Encrypted text</returns>
        public static string Encrypt(ServiceProvider algorithm, string plainText, string password, string salt)
        {
            if (algorithm == ServiceProvider.ChaCha20Poly1305)
            {
                return ChaCha20Poly1305Crypto.Encrypt(plainText, password);
            }
            else
            {
                using (SymmetricAlgorithm symmetricAlgorithm = CreateAlgorithm(algorithm))
                {
                    return CipherUtility.Encrypt(symmetricAlgorithm, plainText, password, salt);
                }
            }
        }

        /// <summary>
        /// Decrypt method
        /// </summary>
        /// <param name="algorithm">Encryption algorithm to use</param>
        /// <param name="encryptedText">Encrypted text to decrypt</param>
        /// <param name="password">A password is a word or string of characters used for user authentication to prove identity or access approval to gain access to a resource, which is to be kept secret from those not allowed access.</param>
        /// <param name="salt">In cryptography, a salt is random data that is used as an additional input to a one-way function that "hashes" data, a password or passphrase.</param>
        /// <returns>Decrypted text (plain text)</returns>
        public static string Decrypt(ServiceProvider algorithm, string encryptedText, string password, string salt)
        {
            if (algorithm == ServiceProvider.ChaCha20Poly1305)
            {
                return ChaCha20Poly1305Crypto.Decrypt(encryptedText, password);
            }
            else
            {
                using (SymmetricAlgorithm symmetricAlgorithm = CreateAlgorithm(algorithm))
                {
                    return CipherUtility.Decrypt(symmetricAlgorithm, encryptedText, password, salt);
                }

            }
        }

        /// <summary>
        /// Create a symmetric algorithm instance using the factory pattern
        /// </summary>
        private static SymmetricAlgorithm CreateAlgorithm(ServiceProvider algorithm)
        {
            return algorithm switch
            {
                ServiceProvider.AES => Aes.Create(),
                ServiceProvider.DES => DES.Create(),
                ServiceProvider.RC2 => RC2.Create(),
                ServiceProvider.TripleDES => TripleDES.Create(),
                _ => throw new ArgumentException("Unknown algorithm", nameof(algorithm))
            };
        }
    }
}
