using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;

namespace ServiceBusQueueApp
{
  class Program
  {
    static string connectionString = Environment.GetEnvironmentVariable("primaryConnectionString");
    static string queueName = Environment.GetEnvironmentVariable("queueName");

    static async Task Main()
    {
      // send a message to the queue
      await SendMessageAsync();

      // send a batch of messages to the queue
      await SendMessageBatchAsync();

      Console.WriteLine("In the Azure portal, navigate to your Service Bus namespace and check the status of your queue...");
      Console.ReadKey();

      // receive message from the queue
      await ReceiveMessagesAsync();
    }

    // ----> Send messages to a queue

    static async Task SendMessageAsync()
    {
      // create a Service Bus client 
      await using (ServiceBusClient client = new ServiceBusClient(connectionString))
      {
        // create a sender for the queue 
        ServiceBusSender sender = client.CreateSender(queueName);

        // create a message that we can send
        ServiceBusMessage message = new ServiceBusMessage("Hello world!");

        // send the message
        await sender.SendMessageAsync(message);
        Console.WriteLine($"Sent a single message to the queue: {queueName}");
      }
    }

    static Queue<ServiceBusMessage> CreateMessages()
    {
      // create a queue containing the messages and return it to the caller
      Queue<ServiceBusMessage> messages = new Queue<ServiceBusMessage>();
      messages.Enqueue(new ServiceBusMessage("First message in the batch"));
      messages.Enqueue(new ServiceBusMessage("Second message in the batch"));
      messages.Enqueue(new ServiceBusMessage("Third message in the batch"));
      return messages;
    }

    static async Task SendMessageBatchAsync()
    {
      // create a Service Bus client 
      await using (ServiceBusClient client = new ServiceBusClient(connectionString))
      {
        // create a sender for the queue 
        ServiceBusSender sender = client.CreateSender(queueName);

        // get the messages to be sent to the Service Bus queue
        Queue<ServiceBusMessage> messages = CreateMessages();

        // total number of messages to be sent to the Service Bus queue
        int messageCount = messages.Count;

        // while all messages are not sent to the Service Bus queue
        while (messages.Count > 0)
        {
          // start a new batch 
          using ServiceBusMessageBatch messageBatch = await sender.CreateMessageBatchAsync();

          // add the first message to the batch
          if (messageBatch.TryAddMessage(messages.Peek()))
          {
            // dequeue the message from the .NET queue once the message is added to the batch
            messages.Dequeue();
          }
          else
          {
            // if the first message can't fit, then it is too large for the batch
            throw new Exception($"Message {messageCount - messages.Count} is too large and cannot be sent.");
          }

          // add as many messages as possible to the current batch
          while (messages.Count > 0 && messageBatch.TryAddMessage(messages.Peek()))
          {
            // dequeue the message from the .NET queue as it has been added to the batch
            messages.Dequeue();
          }

          // now, send the batch
          await sender.SendMessagesAsync(messageBatch);

          // if there are any remaining messages in the .NET queue, the while loop repeats 
        }

        Console.WriteLine($"Sent a batch of {messageCount} messages to the topic: {queueName}");
      }
    }


    // ----> Receive messages from a queue

    // handle received messages
    static async Task MessageHandler(ProcessMessageEventArgs args)
    {
      string body = args.Message.Body.ToString();
      Console.WriteLine($"Received: {body}");

      // complete the message. messages is deleted from the queue. 
      await args.CompleteMessageAsync(args.Message);
    }

    // handle any errors when receiving messages
    static Task ErrorHandler(ProcessErrorEventArgs args)
    {
      Console.WriteLine(args.Exception.ToString());
      return Task.CompletedTask;
    }

    static async Task ReceiveMessagesAsync()
    {
      await using (ServiceBusClient client = new ServiceBusClient(connectionString))
      {
        // create a processor that we can use to process the messages
        ServiceBusProcessor processor = client.CreateProcessor(queueName, new ServiceBusProcessorOptions());

        // add handler to process messages
        processor.ProcessMessageAsync += MessageHandler;

        // add handler to process any errors
        processor.ProcessErrorAsync += ErrorHandler;

        // start processing 
        await processor.StartProcessingAsync();

        Console.WriteLine("Wait for a minute and then press any key to end the processing");
        Console.ReadKey();

        // stop processing 
        Console.WriteLine("\nStopping the receiver...");
        await processor.StopProcessingAsync();
        Console.WriteLine("Stopped receiving messages");
      }
    }

  }
}
