using System.Security.Cryptography;
using System.Text;

namespace CryptographyLibrary.Lib
{
    static class HashUtility
    {
        internal static string GetHash<THash>(byte[] input)
            where THash : HashAlgorithm, new()
        {
            using (var algorithm = new THash())
            {
                byte[] data = algorithm.ComputeHash(input);

                // Create a new Stringbuilder to collect the bytes and create a string.
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
    }
}
