using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;

namespace blob_quickstart
{
    class Program
    {
        public static async Task Main()
        {
            Console.WriteLine("Azure Blob Storage - .NET quickstart sample\n");

            await ProcessAsync();

            Console.WriteLine("Press any key to exit the sample application.");
            Console.ReadLine();
        }

        private static async Task ProcessAsync()
        {
          string storageConnectionString = Environment.GetEnvironmentVariable("AZURE_STORAGE_CONNECTION_STRING");

          // Check whether the connection string can be parsed.
          CloudStorageAccount storageAccount;
          if (CloudStorageAccount.TryParse(storageConnectionString, out storageAccount))
          {
              // If the connection string is valid, proceed with operations against Blob
              // storage here.
              // Create the CloudBlobClient that represents the 
              // Blob storage endpoint for the storage account.
              CloudBlobClient cloudBlobClient = storageAccount.CreateCloudBlobClient();

              // Create a container called 'test-text-container' and 
              // append a GUID value to it to make the name unique.
              CloudBlobContainer cloudBlobContainer = 
                  cloudBlobClient.GetContainerReference("test-text-container" + 
                      Guid.NewGuid().ToString());
              await cloudBlobContainer.CreateAsync();

              // Set the permissions so the blobs are public.
              BlobContainerPermissions permissions = new BlobContainerPermissions
              {
                  PublicAccess = BlobContainerPublicAccessType.Blob
              };
              await cloudBlobContainer.SetPermissionsAsync(permissions);
              // Create a file in your local MyDocuments folder to upload to a blob.
              string localPath = "./data/";
              string localFileName = "QuickStart_" + Guid.NewGuid().ToString() + ".txt";
              string sourceFile = Path.Combine(localPath, localFileName);
              // Write text to the file.
              File.WriteAllText(sourceFile, "Hello, World! - v11");

              Console.WriteLine("Temp file = {0}", sourceFile);
              Console.WriteLine("Uploading to Blob storage as blob '{0}'", localFileName);

              // Get a reference to the blob address, then upload the file to the blob.
              // Use the value of localFileName for the blob name.
              CloudBlockBlob cloudBlockBlob = cloudBlobContainer.GetBlockBlobReference(localFileName);
              await cloudBlockBlob.UploadFromFileAsync(sourceFile);

              // List the blobs in the container.
              Console.WriteLine("List blobs in container.");
              BlobContinuationToken blobContinuationToken = null;
              do
              {
                  var results = await cloudBlobContainer.ListBlobsSegmentedAsync(null, blobContinuationToken);
                  // Get the value of the continuation token returned by the listing call.
                  blobContinuationToken = results.ContinuationToken;
                  foreach (IListBlobItem item in results.Results)
                  {
                      Console.WriteLine(item.Uri);
                  }
              } while (blobContinuationToken != null); // Loop while the continuation token is not null.
          }
          else
          {
              // Otherwise, let the user know that they need to define the environment variable.
              Console.WriteLine(
                  "A connection string has not been defined in the system environment variables. " +
                  "Add an environment variable named 'AZURE_STORAGE_CONNECTION_STRING' with your storage " +
                  "connection string as a value.");
              Console.WriteLine("Press any key to exit the application.");
              Console.ReadLine();
          }
        }
    }
}