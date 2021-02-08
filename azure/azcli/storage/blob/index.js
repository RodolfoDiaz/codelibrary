#!/usr/bin/env node

const { BlobServiceClient } = require('@azure/storage-blob');

const storageAccountConnectionString =
  process.env.AZURE_STORAGE_CONNECTION_STRING;
const blobServiceClient = BlobServiceClient.fromConnectionString(
  storageAccountConnectionString
);

async function main() {
  // Create a container (folder) if it does not exist
  const containerName = 'testcontainer';
  const containerClient = blobServiceClient.getContainerClient(containerName);
  const createContainerResponse = await containerClient.createIfNotExists();
  console.log(
    `Create container ${containerName} successfully`,
    createContainerResponse.succeeded
  );

  // Upload image file
  const filename = 'docs-and-friends-selfie-stick.png';
  const blockBlobClient1 = containerClient.getBlockBlobClient(filename);
  const uploadBlobResponse1 = await blockBlobClient1.uploadFile(filename);
  console.log(
    'Blob was uploaded successfully. requestId: ',
    uploadBlobResponse1.requestId
  );

  // Create a unique name for the blob
  const blobName = 'testFile.txt';

  // Get a block blob client
  const blockBlobClient2 = containerClient.getBlockBlobClient(blobName);
  // Upload data to the blob
  const data = 'Hello World!';
  const uploadBlobResponse = await blockBlobClient2.upload(data, data.length);
  console.log(
    'Blob was uploaded successfully. requestId: ',
    uploadBlobResponse.requestId
  );

  // Get a list of all the blobs in the container
  let blobs = containerClient.listBlobsFlat();
  for await (const blob of blobs) {
    console.log(
      `${blob.name} --> Created: ${blob.properties.createdOn}   Size: ${blob.properties.contentLength}`
    );
  }
}
main();
