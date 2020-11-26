using CryptographyLibrary.Lib;
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
            /// Rijndael symmetric encryption algorithm.
            /// </summary>
            /// <see cref="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.rijndael"/>
            Rijndael,
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
            switch (algorithm)
            {
                case ServiceProvider.AES:
                    return CipherUtility.Encrypt<AesManaged>(plainText, password, salt);
                case ServiceProvider.DES:
                    return CipherUtility.Encrypt<DESCryptoServiceProvider>(plainText, password, salt);
                case ServiceProvider.RC2:
                    return CipherUtility.Encrypt<RC2CryptoServiceProvider>(plainText, password, salt);
                case ServiceProvider.Rijndael:
                    return CipherUtility.Encrypt<RijndaelManaged>(plainText, password, salt);
                case ServiceProvider.TripleDES:
                    return CipherUtility.Encrypt<TripleDESCryptoServiceProvider>(plainText, password, salt);
                default:
                    return null;
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
            switch (algorithm)
            {
                case ServiceProvider.AES:
                    return CipherUtility.Decrypt<AesManaged>(encryptedText, password, salt);
                case ServiceProvider.DES:
                    return CipherUtility.Decrypt<DESCryptoServiceProvider>(encryptedText, password, salt);
                case ServiceProvider.RC2:
                    return CipherUtility.Decrypt<RC2CryptoServiceProvider>(encryptedText, password, salt);
                case ServiceProvider.Rijndael:
                    return CipherUtility.Decrypt<RijndaelManaged>(encryptedText, password, salt);
                case ServiceProvider.TripleDES:
                    return CipherUtility.Decrypt<TripleDESCryptoServiceProvider>(encryptedText, password, salt);
                default:
                    return null;
            }
        }
    }
}
