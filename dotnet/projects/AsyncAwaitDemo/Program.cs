using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;

namespace AsyncAwaitDemo;

class Program
{
    private static readonly HttpClient client = new();

    static async Task Main(string[] args)
    {
        Console.WriteLine("=== Async/Await C# Demonstration ===\n");

        Stopwatch stopwatch = Stopwatch.StartNew();

        // 1. Single asynchronous task execution
        await FetchSingleUrlAsync("https://api.github.com");

        // 2. Parallel asynchronous execution using Task.WhenAll
        await FetchMultipleUrlsParallelAsync();

        // 3. Exception handling in async code
        await HandleAsyncExceptionAsync();

        stopwatch.Stop();
        Console.WriteLine($"\nAll tasks completed in {stopwatch.ElapsedMilliseconds} ms.");
    }

    /// <summary>
    /// Demonstrates fetching a single URL asynchronously with custom HTTP headers.
    /// </summary>
    private static async Task FetchSingleUrlAsync(string url)
    {
        Console.WriteLine($"[1] Fetching single URL asynchronously: {url}...");

        try
        {
            // Set User-Agent as required by GitHub API
            using var request = new HttpRequestMessage(HttpMethod.Get, url);
            request.Headers.Add("User-Agent", "CSharp-Async-ConsoleApp");

            HttpResponseMessage response = await client.SendAsync(request);
            response.EnsureSuccessStatusCode();

            string content = await response.Content.ReadAsStringAsync();
            Console.WriteLine($"    -> Success! Received {content.Length} characters.\n");
        }
        catch (HttpRequestException ex)
        {
            Console.WriteLine($"    -> Request failed: {ex.Message}\n");
        }
    }

    /// <summary>
    /// Demonstrates launching multiple asynchronous tasks in parallel using Task.WhenAll.
    /// </summary>
    private static async Task FetchMultipleUrlsParallelAsync()
    {
        Console.WriteLine("[2] Fetching multiple simulated workloads in parallel...");

        Stopwatch sw = Stopwatch.StartNew();

        // Start multiple tasks concurrently without immediately awaiting them
        Task<string> task1 = SimulateWorkAsync("Task A", 1500);
        Task<string> task2 = SimulateWorkAsync("Task B", 800);
        Task<string> task3 = SimulateWorkAsync("Task C", 1200);

        // Await all tasks to finish concurrently
        string[] results = await Task.WhenAll(task1, task2, task3);

        sw.Stop();

        foreach (string result in results)
        {
            Console.WriteLine($"    -> {result}");
        }

        Console.WriteLine($"    -> Parallel execution completed in {sw.ElapsedMilliseconds} ms (not 3500ms).\n");
    }

    /// <summary>
    /// Helper method simulating a non-blocking I/O operation (e.g., database call, network fetch).
    /// </summary>
    private static async Task<string> SimulateWorkAsync(string name, int delayMs)
    {
        // Task.Delay delays the execution without blocking the CPU thread
        await Task.Delay(delayMs);
        return $"{name} finished after {delayMs} ms.";
    }

    /// <summary>
    /// Demonstrates standard exception handling in async method pipelines.
    /// </summary>
    private static async Task HandleAsyncExceptionAsync()
    {
        Console.WriteLine("[3] Demonstrating async exception handling...");

        try
        {
            await FaultyOperationAsync();
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine($"    -> Caught expected exception: {ex.Message}\n");
        }
    }

    private static async Task FaultyOperationAsync()
    {
        await Task.Delay(200); // Simulate some work
        throw new InvalidOperationException("Something went wrong during the async operation.");
    }
}