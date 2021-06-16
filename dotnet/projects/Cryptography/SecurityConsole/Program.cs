using CryptographyLibrary;
using System;
using System.IO;

namespace SecurityConsole
{
    class Program
    {
        private const string plainText = "Hello World";
        private const string password = "W3@kPa$sw0dSAr3N0Tg*oD";
        private static string salt = DateTime.UtcNow.ToString();
        private const string filePath = @"C:\Windows\win.ini";

        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No argurment found. Use 'C' for CaesarCipher, 'H' to show Input Text Hash, 'F' to show File Hash, 'E' for show Symmetric Encryption example.");
            }
            else
            {
                string argument = args[0].ToString().ToUpper();
                if (argument == "C")
                {
                    ShowCaesarEncryption();
                }
                else if (argument == "H" || argument == "E")
                {
                    Console.Write("Enter a text (or hit Enter to continue with default): ");
                    string inputText = Console.ReadLine();
                    if (inputText == "")
                    {
                        inputText = plainText;
                    }

                    if (argument == "H")
                    {
                        HashTest(inputText);
                    }
                    else
                    {
                        SymmetricEncryptionTest(inputText);
                    }
                }
                else if (argument == "F")
                {
                    Console.Write("Enter a file path (or hit Enter to continue with default): ");
                    string inputFilePath = Console.ReadLine();
                    if (inputFilePath == "")
                    {
                        inputFilePath = filePath;
                    }
                    else
                    {
                        if (File.Exists(inputFilePath))
                        {
                            FileHashTest(inputFilePath); 
                        }
                        else
                        {
                            Console.Write("File not found!");
                        }
                    }
                }
                else
                {
                    Console.WriteLine("Argument is not valid.");
                }
            }
        }

        private static void HashTest(string inputText)
        {
            Console.WriteLine("--*-- Input Text Hash example --*--");
            ShowInputTextHash(Hash.ServiceProvider.MD5, inputText);
            ShowInputTextHash(Hash.ServiceProvider.SHA1, inputText);
            ShowInputTextHash(Hash.ServiceProvider.SHA256, inputText);
            ShowInputTextHash(Hash.ServiceProvider.SHA384, inputText);
            ShowInputTextHash(Hash.ServiceProvider.SHA512, inputText);
        }

        private static void FileHashTest(string inputFilePath)
        {
            Console.WriteLine("--*-- File Hash example --*--");
            ShowFileHash(Hash.ServiceProvider.MD5, inputFilePath);
            ShowFileHash(Hash.ServiceProvider.SHA1, inputFilePath);
            ShowFileHash(Hash.ServiceProvider.SHA256, inputFilePath);
            ShowFileHash(Hash.ServiceProvider.SHA384, inputFilePath);
            ShowFileHash(Hash.ServiceProvider.SHA512, inputFilePath);
        }

        private static void SymmetricEncryptionTest(string inputText)
        {
            Console.WriteLine("--*-- Symmetric Encryption example --*--");
            ShowSymmetricEncryption(SymmetricEncryption.ServiceProvider.AES, inputText);
            ShowSymmetricEncryption(SymmetricEncryption.ServiceProvider.DES, inputText);
            ShowSymmetricEncryption(SymmetricEncryption.ServiceProvider.RC2, inputText);
            ShowSymmetricEncryption(SymmetricEncryption.ServiceProvider.Rijndael, inputText);
            ShowSymmetricEncryption(SymmetricEncryption.ServiceProvider.TripleDES, inputText);
        }

        private static void ShowSymmetricEncryption(SymmetricEncryption.ServiceProvider algorithm, string inputText)
        {
            string encryptedText = SymmetricEncryption.Encrypt(algorithm, inputText, password, salt);
            string decryptedText = SymmetricEncryption.Decrypt(algorithm, encryptedText, password, salt);

            Console.WriteLine("---  Encryption Algorithm used {0}  ---", algorithm);
            Console.WriteLine("Encrypted Text:{0}", encryptedText);
            Console.WriteLine("Decrypted Text:{0}", decryptedText);
            Console.WriteLine();
        }

        private static void ShowInputTextHash(Hash.ServiceProvider algorithm, string inputText)
        {
            string hashValue = Hash.GetHash(algorithm, inputText);
            bool hashMatches = Hash.VerifyHash(algorithm, inputText, hashValue);

            if (hashMatches)
            {
                Console.WriteLine("The {0} hash for the input text: '{1}' is:\n{2}", algorithm, inputText, hashValue);
            }
            else
            {
                Console.WriteLine("Error!");
            }
            Console.WriteLine();
        }

        private static void ShowFileHash(Hash.ServiceProvider algorithm, string inputFilePath)
        {
            string hashForFile = Hash.GetHashFromFile(algorithm, inputFilePath);
            Console.WriteLine("The {0} checksum of file: {1} is:\n{2}", algorithm, inputFilePath, hashForFile);
            Console.WriteLine("You can compare the output above with the following PowerShell command: \nGet-FileHash {0} -Algorithm {1} | Format-List", inputFilePath, algorithm);
            Console.WriteLine();
        }

        private static void ShowCaesarEncryption()
        {
            Console.WriteLine("--*-- Caesar Encryption example --*--");
            Console.WriteLine("Type a string to encrypt (or hit Enter to continue with default): ");
            string inputText = Console.ReadLine();
            if (inputText == "")
            {
                inputText = plainText;
            }

            Console.WriteLine("Enter your Key value (numberic value)");
            string key = Console.ReadLine();
            int intKey = 0;
            if (!Int32.TryParse(key, out intKey))
            {
                intKey = -1;
            }

            Console.WriteLine("Encrypted Data with Caesar cipher by {0} spaces", intKey);

            string cipherText = CaesarCipher.Encipher(inputText, intKey);
            Console.WriteLine(cipherText);
            Console.Write("\n");

            Console.WriteLine("Decrypted Data:");

            string t = CaesarCipher.Decipher(cipherText, intKey);
            Console.WriteLine(t);
        }
    }
}
