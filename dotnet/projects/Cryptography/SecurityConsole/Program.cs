using CryptographyLibrary;
using System;

namespace SecurityConsole
{
    class Program
    {
        private const string plainText = "Hello World!";
        private const string password = "W3@kPa$sw0dSAr3N0Tg*oD";
        private static string salt = DateTime.UtcNow.ToString();
        private const string filePath = @"C:\Windows\win.ini";

        static void Main(string[] args)
        {
            //HashTest();
            //SymmetricEncryptionTest();
            ShowCaesarSample();
        }

        private static void HashTest()
        {
            ShowHashSample(Hash.ServiceProvider.MD5);
            ShowHashSample(Hash.ServiceProvider.SHA1);
            ShowHashSample(Hash.ServiceProvider.SHA256);
            ShowHashSample(Hash.ServiceProvider.SHA384);
            ShowHashSample(Hash.ServiceProvider.SHA512);
        }

        private static void SymmetricEncryptionTest()
        {
            ShowExample(SymmetricEncryption.ServiceProvider.AES);
            ShowExample(SymmetricEncryption.ServiceProvider.DES);
            ShowExample(SymmetricEncryption.ServiceProvider.RC2);
            ShowExample(SymmetricEncryption.ServiceProvider.Rijndael);
            ShowExample(SymmetricEncryption.ServiceProvider.TripleDES);
        }

        private static void ShowExample(SymmetricEncryption.ServiceProvider algorithm)
        {
            string encryptedText = SymmetricEncryption.Encrypt(algorithm, plainText, password, salt);
            string decryptedText = SymmetricEncryption.Decrypt(algorithm, encryptedText, password, salt);
            WriteToConsole(algorithm.ToString(), encryptedText, decryptedText);
        }

        private static void WriteToConsole(string algorithm, string encryptedText, string decryptedText)
        {
            Console.WriteLine("---  Encryption Algorithm used {0}  ---", algorithm);
            Console.WriteLine("Encrypted Text:{0}", encryptedText);
            Console.WriteLine("Decrypted Text:{0}", decryptedText);
            Console.WriteLine();
        }

        private static void ShowHashSample(Hash.ServiceProvider algorithm)
        {
            string hashValue = Hash.GetHash(algorithm, plainText);
            bool hashMatches = Hash.VerifyHash(algorithm, plainText, hashValue);
            string hashForFile = Hash.GetHashFromFile(algorithm, filePath);
            WriteToConsoleHash(algorithm.ToString(), hashValue, hashMatches, hashForFile);
        }

        private static void WriteToConsoleHash(string algorithm, string hash, bool hashMatches, string hashForFile)
        {
            Console.WriteLine("Generate the " + algorithm + " checksum of file: {0}", filePath);
            Console.WriteLine(algorithm + " checksum is: {0}", hashForFile);
            Console.WriteLine();

            Console.WriteLine("The " + algorithm + " hash of " + plainText + " is: " + hash + "");
            if (hashMatches)
            {
                Console.WriteLine("The hashes are the same.");
            }
            else
            {
                Console.WriteLine("The hashes are not same.");
            }
            Console.WriteLine();
        }

        private static void ShowCaesarSample()
        {
            Console.WriteLine("Type a string to encrypt:");
            string UserString = Console.ReadLine();

            Console.WriteLine("\n");

            Console.WriteLine("Enter your Key (numberic value)");
            int key = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("\n");


            Console.WriteLine("Encrypted Data");

            string cipherText = CaesarCipher.Encipher(UserString, key);
            Console.WriteLine(cipherText);
            Console.Write("\n");

            Console.WriteLine("Decrypted Data:");

            string t = CaesarCipher.Decipher(cipherText, key);
            Console.WriteLine(t);
            Console.Write("\n");

            Console.ReadKey();
        }
    }
}
