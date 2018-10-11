using System;
using System.Text;
using System.Web;

namespace CryptographyLibrary
{
    /// <summary>
    /// The purpose of encoding is to transform data so that it can be properly (and safely) consumed by a different type of system.
    /// </summary>
    public class TextEncoding
    {
        /// <summary>
        /// Encode to Base64 format
        /// </summary>
        /// <param name="plainText">Text to encode</param>
        /// <returns>Encoded text</returns>
        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = Encoding.UTF8.GetBytes(plainText);
            return Convert.ToBase64String(plainTextBytes);
        }

        /// <summary>
        /// Decode from Base64 format
        /// </summary>
        /// <param name="base64EncodedData">Text to decode</param>
        /// <returns>Decoded text</returns>
        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = Convert.FromBase64String(base64EncodedData);
            return Encoding.UTF8.GetString(base64EncodedBytes);
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
    }
}
