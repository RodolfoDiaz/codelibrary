using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace CryptographyLibrary
{
    /// <summary>
    /// Base64 is strictly a binary-to-text encoding scheme, not a security mechanism. 
    /// It uses no cryptographic keys or algorithms, offers zero confidentiality, 
    /// and must never be relied upon to protect sensitive information.
    /// </summary>
    /// <see cref="https://en.wikipedia.org/wiki/Base64"/>
    public class Base64Encoding
    {
        /// <summary>
        /// Encode Text to Base64 format.
        /// The purpose of this encoding is to transform data so that it can be 
        /// properly (and safely) consumed by a different type of system.
        /// </summary>
        /// <param name="plainText">Text to encode</param>
        /// <returns>Encoded text</returns>
        public static string Encode(string plainText)
        {
            if (string.IsNullOrEmpty(plainText))
                return string.Empty;

            var plainTextBytes = Encoding.UTF8.GetBytes(plainText);
            return Convert.ToBase64String(plainTextBytes);
        }

        /// <summary>
        /// Decode Text from Base64 format
        /// </summary>
        /// <param name="base64EncodedData">Text to decode</param>
        /// <returns>Decoded text</returns>
        public static string Decode(string base64EncodedData)
        {
            if (string.IsNullOrEmpty(base64EncodedData))
                return string.Empty;

            var base64EncodedBytes = Convert.FromBase64String(base64EncodedData);
            return Encoding.UTF8.GetString(base64EncodedBytes);
        }

        /// <summary>
        /// Try-decode pattern to safely handle invalid Base64 input without throwing exceptions.
        /// </summary>
        public static bool TryDecode(string base64EncodedData, out string result)
        {
            result = string.Empty;
            if (string.IsNullOrWhiteSpace(base64EncodedData))
                return false;

            Span<byte> buffer = new byte[base64EncodedData.Length];
            if (Convert.TryFromBase64String(base64EncodedData, buffer, out int bytesWritten))
            {
                result = Encoding.UTF8.GetString(buffer[..bytesWritten]);
                return true;
            }

            return false;
        }

        /// <summary>
        /// Encodes a URL string
        /// </summary>
        /// <param name="str">The string to encode</param>
        /// <returns>Encoded string</returns>
        public static string URLEncode(string str)
        {
            return HttpUtility.UrlEncode(str);
        }

        /// <summary>
        /// Converts a string that has been encoded into a decoded string
        /// </summary>
        /// <param name="str">The string to decode</param>
        /// <returns>Decoded string</returns>
        public static string URLDecode(string str)
        {
            return HttpUtility.UrlDecode(str);
        }

        /// <summary>
        /// Converts a string into HTML-encoded string
        /// </summary>
        /// <param name="str">The string to encode</param>
        /// <returns>Encoded string</returns>
        public static string HTMLEncode(string str)
        {
            return HttpUtility.HtmlEncode(str);
        }

        /// <summary>
        /// Converts a string that has been encoded for HTTP transmission into a decoded string
        /// </summary>
        /// <param name="str">The string to decode</param>
        /// <returns>Decoded string</returns>
        public static string HTMLDecode(string str)
        {
            return HttpUtility.HtmlDecode(str);
        }

        /// <summary>
        /// Encodes an image or binary file on disk into a Base64 string.
        /// </summary>
        public static string EncodeFileToBase64(string filePath)
        {
            if (!File.Exists(filePath))
            {
                throw new ArgumentException("File path is not valid.");
            }

            byte[] fileBytes = File.ReadAllBytes(filePath);
            return Convert.ToBase64String(fileBytes);
        }

        /// <summary>
        /// Encodes a raw byte array (e.g., from an Image stream or API response) into Base64.
        /// </summary>
        public static string EncodeBytesToBase64(byte[] imageBytes)
        {
            return Convert.ToBase64String(imageBytes);
        }

        /// <summary>
        /// Decodes a Base64 string and saves it back to an image or binary file.
        /// </summary>
        public static void DecodeBase64ToFile(string base64String, string outputPath)
        {
            byte[] fileBytes = Convert.FromBase64String(base64String);
            File.WriteAllBytes(outputPath, fileBytes);
        }

        /// <summary>
        /// Generates a Data URL string suitable for direct HTML `<img>` tag src attributes.
        /// </summary>
        public static string ToDataUrl(byte[] imageBytes, string mimeType = "image/png")
        {
            string base64 = Convert.ToBase64String(imageBytes);
            return $"data:{mimeType};base64,{base64}";
        }

        /// <summary>
        /// Encodes large files using a stream to minimize memory usage in .NET.
        /// </summary>
        public static async Task EncodeLargeFileAsync(string inputFilePath, TextWriter writer)
        {
            if (!File.Exists(inputFilePath))
            {
                throw new ArgumentException("File path is not valid.");
            }

            await using FileStream fileStream = File.OpenRead(inputFilePath);
            using var transform = new System.Security.Cryptography.ToBase64Transform();
            byte[] inputBuffer = new byte[3072]; // Must be a multiple of 3 for Base64 blocks
            byte[] outputBuffer = new byte[transform.OutputBlockSize];

            int bytesRead;
            while ((bytesRead = await fileStream.ReadAsync(inputBuffer, 0, inputBuffer.Length)) > 0)
            {
                if (bytesRead == inputBuffer.Length)
                {
                    transform.TransformBlock(inputBuffer, 0, bytesRead, outputBuffer, 0);
                    await writer.WriteAsync(System.Text.Encoding.ASCII.GetString(outputBuffer));
                }
                else
                {
                    byte[] finalBlock = transform.TransformFinalBlock(inputBuffer, 0, bytesRead);
                    await writer.WriteAsync(System.Text.Encoding.ASCII.GetString(finalBlock));
                }
            }
        }
    }
}
