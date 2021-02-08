using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System;
using System.IO;
using System.Threading.Tasks;

namespace BlobQuickstartV12
{
    class Program
    {
        static async Task Main()
        {
          string connectionString = Environment.GetEnvironmentVariable("AZURE_STORAGE_CONNECTION_STRING");
          // Create a BlobServiceClient object which will be used to create a container client
          BlobServiceClient blobServiceClient = new BlobServiceClient(connectionString);

          //Create a unique name for the container
          string containerName = "quickstartblobs" + Guid.NewGuid().ToString();

          // Create the container and return a container client object
          BlobContainerClient containerClient = await blobServiceClient.CreateBlobContainerAsync(containerName);

          // Create a local file in the ./data/ directory for uploading and downloading
          string localPath = "./data/";
          string fileName = "quickstart" + Guid.NewGuid().ToString() + ".txt";
          string localFilePath = Path.Combine(localPath, fileName);

          // Write text to the file
          await File.WriteAllTextAsync(localFilePath, "Hello, World!");

          // Get a reference to a blob
          BlobClient blobClient = containerClient.GetBlobClient(fileName);

          Console.WriteLine("Uploading to Blob storage as blob:\n\t {0}\n", blobClient.Uri);

          // Open the file and upload its data
          using FileStream uploadFileStream = File.OpenRead(localFilePath);
          await blobClient.UploadAsync(uploadFileStream, true);
          uploadFileStream.Close();

          Console.WriteLine("Listing blobs...");

          // List all blobs in the container
          await foreach (BlobItem blobItem in containerClient.GetBlobsAsync())
          {
              Console.WriteLine("\t" + blobItem.Name);
          }
        }
    }
}