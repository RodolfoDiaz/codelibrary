using Azure;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;
using System;
using System.Threading.Tasks;

namespace QueueApp
{
    class Program
    {
        static async Task Main(string[] args)
        {
          Console.WriteLine("Azure Queue Storage client library v12 - .NET quickstart sample\n");

          string connectionString = Environment.GetEnvironmentVariable("storageConnectionString");

          // ------> Create a queue

          // Create a unique name for the queue
          string queueName = "quickstartqueues-" + Guid.NewGuid().ToString();

          Console.WriteLine($"Creating queue: {queueName}");

          // Instantiate a QueueClient which will be
          // used to create and manipulate the queue
          QueueClient queueClient = new QueueClient(connectionString, queueName);

          // Create the queue
          await queueClient.CreateAsync();

          // ------> Add messages to a queue

          Console.WriteLine("\nAdding messages to the queue...");

          // Send several messages to the queue
          await queueClient.SendMessageAsync("First message");
          await queueClient.SendMessageAsync("Second message");

          // Save the receipt so we can update this message later
          SendReceipt receipt = await queueClient.SendMessageAsync("Third message");

          // ------> Peek at messages in a queue

          Console.WriteLine("\nPeek at the messages in the queue...");

          // Peek at messages in the queue
          PeekedMessage[] peekedMessages = await queueClient.PeekMessagesAsync(maxMessages: 10);

          foreach (PeekedMessage peekedMessage in peekedMessages)
          {
              // Display the message
              Console.WriteLine($"Message: {peekedMessage.MessageText}");
          }

          // ------> Update a message in a queue

          Console.WriteLine("\nUpdating the third message in the queue...");

          // Update a message using the saved receipt from sending the message
          await queueClient.UpdateMessageAsync(receipt.MessageId, receipt.PopReceipt, "Third message has been updated");

          // ------> Receive messages from a queue

          Console.WriteLine("\nReceiving messages from the queue...");

          // Get messages from the queue
          QueueMessage[] messages = await queueClient.ReceiveMessagesAsync(maxMessages: 10);

          // ------> Delete messages from a queue

          Console.WriteLine("\nPress Enter key to 'process' messages and delete them from the queue...");
          Console.ReadLine();

          // Process and delete messages from the queue
          foreach (QueueMessage message in messages)
          {
              // "Process" the message
              Console.WriteLine($"Message: {message.MessageText}");

              // Let the service know we're finished with
              // the message and it can be safely deleted.
              await queueClient.DeleteMessageAsync(message.MessageId, message.PopReceipt);
          }

          // ------> Delete a queue

          Console.WriteLine("\nPress Enter key to delete the queue...");
          Console.ReadLine();

          // Clean up
          Console.WriteLine($"Deleting queue: {queueClient.Name}");
          await queueClient.DeleteAsync();

          Console.WriteLine("Done");

        }
    }
}