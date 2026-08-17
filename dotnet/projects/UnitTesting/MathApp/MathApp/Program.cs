using System;
using MathApp;

class Program
{
    static void Main(string[] args)
    {
        var calc = new Calculator();

        Console.WriteLine("=== Basic Math Calculator ===");
        Console.WriteLine($"10 + 5  = {calc.Add(10, 5)}");
        Console.WriteLine($"10 - 5  = {calc.Subtract(10, 5)}");
        Console.WriteLine($"10 * 5  = {calc.Multiply(10, 5)}");
        Console.WriteLine($"10 / 5  = {calc.Divide(10, 5)}");

        try
        {
            calc.Divide(10, 0);
        }
        catch (DivideByZeroException ex)
        {
            Console.WriteLine($"Error Handled: {ex.Message}");
        }
    }
}