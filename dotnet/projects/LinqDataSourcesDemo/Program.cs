using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Xml.Linq;

namespace LinqDataSourcesDemo;

// ===================================================================
// Domain Models
// ===================================================================
public record Product(int Id, string Name, string Category, decimal Price);
public record Order(int OrderId, int ProductId, int Quantity);

internal class Program
{
    private static void Main(string[] args)
    {
        Console.WriteLine("=== C# LINQ Across Multiple Data Sources ===\n");

        QueryInMemoryObjects();
        QueryXmlData();
        QueryJsonData();
        QueryStringData();
        QueryJoinedCollections();

        Console.WriteLine("\nPress any key to exit...");
        Console.ReadKey();
    }

    // ---------------------------------------------------------------
    // 1. LINQ to Objects (In-Memory Lists)
    // ---------------------------------------------------------------
    private static void QueryInMemoryObjects()
    {
        Console.WriteLine("--- 1. LINQ to Objects (In-Memory List) ---");

        List<Product> products = new()
        {
            new Product(1, "Laptop", "Electronics", 1200.00m),
            new Product(2, "Smartphone", "Electronics", 800.00m),
            new Product(3, "Desk Chair", "Furniture", 150.00m),
            new Product(4, "Monitor", "Electronics", 300.00m),
            new Product(5, "Coffee Table", "Furniture", 85.00m)
        };

        // Query Syntax: Electronics costing > $500
        var expensiveElectronics = from p in products
                                   where p.Category == "Electronics" && p.Price > 500
                                   orderby p.Price descending
                                   select p;

        Console.WriteLine("Expensive Electronics (Query Syntax):");
        foreach (var p in expensiveElectronics)
        {
            Console.WriteLine($"  - {p.Name}: ${p.Price}");
        }

        // Method Syntax: Average price per category
        var categoryAverages = products
            .GroupBy(p => p.Category)
            .Select(g => new { Category = g.Key, AvgPrice = g.Average(p => p.Price) });

        Console.WriteLine("\nAverage Price by Category (Method Syntax):");
        foreach (var cat in categoryAverages)
        {
            Console.WriteLine($"  - {cat.Category}: ${cat.AvgPrice:F2}");
        }

        Console.WriteLine();
    }

    // ---------------------------------------------------------------
    // 2. LINQ to XML
    // ---------------------------------------------------------------
    private static void QueryXmlData()
    {
        Console.WriteLine("--- 2. LINQ to XML ---");

        string xmlData = @"
            <Books>
                <Book id='1'>
                    <Title>C# in Depth</Title>
                    <Author>Jon Skeet</Author>
                    <Price>45.00</Price>
                </Book>
                <Book id='2'>
                    <Title>Clean Code</Title>
                    <Author>Robert C. Martin</Author>
                    <Price>40.00</Price>
                </Book>
                <Book id='3'>
                    <Title>Design Patterns</Title>
                    <Author>Erich Gamma</Author>
                    <Price>55.00</Price>
                </Book>
            </Books>";

        XDocument xmlDoc = XDocument.Parse(xmlData);

        // Find books under $50 ordered by author
        var cheapBooks = from book in xmlDoc.Descendants("Book")
                         where (decimal)book.Element("Price")! < 50.00m
                         orderby (string)book.Element("Author")
                         select new
                         {
                             Title = (string)book.Element("Title"),
                             Author = (string)book.Element("Author"),
                             Price = (decimal)book.Element("Price")
                         };

        Console.WriteLine("Books under $50:");
        foreach (var b in cheapBooks)
        {
            Console.WriteLine($"  - '{b.Title}' by {b.Author} (${b.Price})");
        }

        Console.WriteLine();
    }

    // ---------------------------------------------------------------
    // 3. LINQ to JSON (System.Text.Json)
    // ---------------------------------------------------------------
    private static void QueryJsonData()
    {
        Console.WriteLine("--- 3. LINQ to JSON (System.Text.Json) ---");

        string jsonString = @"[
            { ""Name"": ""Alice"", ""Department"": ""Engineering"", ""Salary"": 95000 },
            { ""Name"": ""Bob"", ""Department"": ""Marketing"", ""Salary"": 62000 },
            { ""Name"": ""Charlie"", ""Department"": ""Engineering"", ""Salary"": 105000 },
            { ""Name"": ""Diana"", ""Department"": ""HR"", ""Salary"": 58000 }
        ]";

        using JsonDocument doc = JsonDocument.Parse(jsonString);

        // Querying raw JsonElement structures dynamically
        var highEarners = doc.RootElement.EnumerateArray()
            .Where(e => e.GetProperty("Salary").GetInt32() > 70000)
            .Select(e => new
            {
                Name = e.GetProperty("Name").GetString(),
                Dept = e.GetProperty("Department").GetString(),
                Salary = e.GetProperty("Salary").GetInt32()
            });

        Console.WriteLine("Employees earning > $70k:");
        foreach (var emp in highEarners)
        {
            Console.WriteLine($"  - {emp.Name} ({emp.Dept}): ${emp.Salary}");
        }

        Console.WriteLine();
    }

    // ---------------------------------------------------------------
    // 4. LINQ to Strings / Text Streams
    // ---------------------------------------------------------------
    private static void QueryStringData()
    {
        Console.WriteLine("--- 4. LINQ to Strings & Unstructured Text ---");

        string rawText = @"LINQ makes querying data simple.
                           It supports multiple data sources like collections, XML, SQL, and JSON.
                           Functional C# code is fast, clean, and readable.";

        // Count occurrences of words longer than 3 characters, ordered by frequency
        var wordCounts = rawText
            .Split(new[] { ' ', '.', ',', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries)
            .Select(w => w.Trim().ToLower())
            .Where(w => w.Length > 3)
            .GroupBy(w => w)
            .Select(g => new { Word = g.Key, Count = g.Count() })
            .OrderByDescending(x => x.Count)
            .Take(5);

        Console.WriteLine("Top 5 frequent words (>3 chars):");
        foreach (var item in wordCounts)
        {
            Console.WriteLine($"  - '{item.Word}': {item.Count} times");
        }

        Console.WriteLine();
    }

    // ---------------------------------------------------------------
    // 5. Relational Queries (LINQ Joins)
    // ---------------------------------------------------------------
    private static void QueryJoinedCollections()
    {
        Console.WriteLine("--- 5. LINQ Relational Joins across Collections ---");

        List<Product> products = new()
        {
            new Product(1, "Laptop", "Electronics", 1200.00m),
            new Product(2, "Smartphone", "Electronics", 800.00m),
            new Product(3, "Desk Chair", "Furniture", 150.00m)
        };

        List<Order> orders = new()
        {
            new Order(101, 1, 2), // 2 Laptops
            new Order(102, 2, 5), // 5 Smartphones
            new Order(103, 1, 1), // 1 Laptop
            new Order(104, 3, 4)  // 4 Desk Chairs
        };

        // Perform an INNER JOIN between products and orders
        var orderSummaries = from o in orders
                             join p in products on o.ProductId equals p.Id
                             select new
                             {
                                 OrderId = o.OrderId,
                                 ProductName = p.Name,
                                 TotalCost = o.Quantity * p.Price
                             };

        Console.WriteLine("Order Summaries (Joined):");
        foreach (var item in orderSummaries)
        {
            Console.WriteLine($"  - Order #{item.OrderId}: {item.ProductName} | Total: ${item.TotalCost:F2}");
        }

        Console.WriteLine();
    }
}