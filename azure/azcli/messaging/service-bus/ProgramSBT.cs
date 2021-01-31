using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;

namespace ServiceBusTopicApp
{
  class Program
  {
    static string connectionString = Environment.GetEnvironmentVariable("primaryConnectionString");
    static string topicName = Environment.GetEnvironmentVariable("paramServiceBusTopic");
    static string subscriptionName = Environment.GetEnvironmentVariable("paramServiceBusSubscription");

    static async Task Main()
    {
        // send a message to the topic
        await SendMessageToTopicAsync();

        // send a batch of messages to the topic
        await SendMessageBatchToTopicAsync();

        Console.WriteLine("In the Azure portal, navigate to your Service Bus namespace and check the status of your subscription...");
        Console.ReadKey();

        // receive messages from the subscription
        await ReceiveMessagesFromSubscriptionAsync();
    }

    // ----> Send messages to a topic

    static async Task SendMessageToTopicAsync()
    {
        // create a Service Bus client 
        await using (ServiceBusClient client = new ServiceBusClient(connectionString))
        {
            // create a sender for the topic
            ServiceBusSender sender = client.CreateSender(topicName);
            await sender.SendMessageAsync(new ServiceBusMessage("Hello, World!"));
            Console.WriteLine($"Sent a single message to the topic: {topicName}");
        }
    }

    static Queue<ServiceBusMessage> CreateMessages()
    {
        // create a queue containing the messages and return it to the caller
        Queue<ServiceBusMessage> messages = new Queue<ServiceBusMessage>();
        messages.Enqueue(new ServiceBusMessage("First message"));
        messages.Enqueue(new ServiceBusMessage("Second message"));
        messages.Enqueue(new ServiceBusMessage("Third message"));
        return messages;
    }

    static async Task SendMessageBatchToTopicAsync()
    {
        // create a Service Bus client 
        await using (ServiceBusClient client = new ServiceBusClient(connectionString))
        {

            // create a sender for the topic 
            ServiceBusSender sender = client.CreateSender(topicName);

            // get the messages to be sent to the Service Bus topic
            Queue<ServiceBusMessage> messages = CreateMessages();

            // total number of messages to be sent to the Service Bus topic
            int messageCount = messages.Count;

            // while all messages are not sent to the Service Bus topic
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

            Console.WriteLine($"Sent a batch of {messageCount} messages to the topic: {topicName}");
        }
    }

    // ----> Receive messages from a subscription

    static async Task MessageHandler(ProcessMessageEventArgs args)
    {
        string body = args.Message.Body.ToString();
        Console.WriteLine($"Received: {body} from subscription: {subscriptionName}");

        // complete the message. messages is deleted from the queue. 
        await args.CompleteMessageAsync(args.Message);
    }

    static Task ErrorHandler(ProcessErrorEventArgs args)
    {
        Console.WriteLine(args.Exception.ToString());
        return Task.CompletedTask;
    }

    static async Task ReceiveMessagesFromSubscriptionAsync()
    {
        await using (ServiceBusClient client = new ServiceBusClient(connectionString))
        {
            // create a processor that we can use to process the messages
            ServiceBusProcessor processor = client.CreateProcessor(topicName, subscriptionName, new ServiceBusProcessorOptions());

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
