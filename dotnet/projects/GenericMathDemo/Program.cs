using System.Numerics;

namespace GenericMathDemo;

// =========================================================================
// 1. GENERIC MATH CALCULATOR CLASS
// We constraint 'T' to 'INumber<T>', which allows using standard math operators
// (+, -, *, /, etc.) on any numeric type (int, double, decimal, float, etc.).
// =========================================================================
public class GenericCalculator<T> where T : INumber<T>
{
    public T Add(T a, T b) => a + b;

    public T Subtract(T a, T b) => a - b;

    public T Multiply(T a, T b) => a * b;

    public T Divide(T a, T b)
    {
        if (T.IsZero(b))
        {
            throw new DivideByZeroException("Division by zero is not allowed.");
        }
        return a / b;
    }

    // Example of using generic static math functions from Math<T> / INumber<T>
    public T FindMax(T a, T b) => T.Max(a, b);
}

// =========================================================================
// 2. GENERIC UTILITY CLASS FOR ARRAY/COLLECTION MATH
// =========================================================================
public static class MathUtils
{
    // Sums an array of any numeric type
    public static TSum Sum<TSum>(TSum[] numbers) where TSum : INumber<TSum>
    {
        TSum total = TSum.Zero; // Generic representation of '0'
        foreach (var number in numbers)
        {
            total += number;
        }
        return total;
    }

    // Calculates the average of a collection
    public static double Average<TAvg>(TAvg[] numbers) where TAvg : INumber<TAvg>
    {
        if (numbers.Length == 0) return 0.0;

        TAvg total = TAvg.Zero;
        foreach (var number in numbers)
        {
            total += number;
        }

        // Convert sum and count to double for accurate average calculation
        return Convert.ToDouble(total) / numbers.Length;
    }
}

// =========================================================================
// 3. MAIN APPLICATION RUNNER
// =========================================================================
internal class Program
{
    private static void Main(string[] args)
    {
        Console.WriteLine("=== Math Operations using Generics with C# 11+ Generic Math (INumber<T>) ===\n");

        // --- Demo 1: Generic Calculator with Integers ---
        Console.WriteLine("--- 1. Integer Operations ---");
        var intCalc = new GenericCalculator<int>();
        int num1 = 15, num2 = 4;

        Console.WriteLine($"{num1} + {num2} = {intCalc.Add(num1, num2)}");
        Console.WriteLine($"{num1} - {num2} = {intCalc.Subtract(num1, num2)}");
        Console.WriteLine($"{num1} * {num2} = {intCalc.Multiply(num1, num2)}");
        Console.WriteLine($"{num1} / {num2} = {intCalc.Divide(num1, num2)}");
        Console.WriteLine($"Max({num1}, {num2}) = {intCalc.FindMax(num1, num2)}");
        Console.WriteLine();

        // --- Demo 2: Generic Calculator with Doubles ---
        Console.WriteLine("--- 2. Double Operations ---");
        var doubleCalc = new GenericCalculator<double>();
        double d1 = 12.5, d2 = 2.5;

        Console.WriteLine($"{d1} + {d2} = {doubleCalc.Add(d1, d2)}");
        Console.WriteLine($"{d1} / {d2} = {doubleCalc.Divide(d1, d2)}");
        Console.WriteLine($"Max({d1}, {d2}) = {doubleCalc.FindMax(d1, d2)}");
        Console.WriteLine();

        // --- Demo 3: Generic Calculator with Decimals ---
        Console.WriteLine("--- 3. Decimal Operations ---");
        var decimalCalc = new GenericCalculator<decimal>();
        decimal dec1 = 99.99m, dec2 = 15.50m;

        Console.WriteLine($"{dec1} - {dec2} = {decimalCalc.Subtract(dec1, dec2)}");
        Console.WriteLine();

        // --- Demo 4: Generic Collection Math ---
        Console.WriteLine("--- 4. Array Operations ---");

        int[] intArray = [10, 20, 30, 40, 50];
        double[] doubleArray = [1.5, 2.5, 3.5, 4.5];

        // Call methods directly on the MathUtils class
        Console.WriteLine($"Int Array Sum: {MathUtils.Sum(intArray)}");
        Console.WriteLine($"Int Array Average: {MathUtils.Average(intArray)}");
        Console.WriteLine($"Double Array Sum: {MathUtils.Sum(doubleArray)}");
        Console.WriteLine($"Double Array Average: {MathUtils.Average(doubleArray)}");
    }
}