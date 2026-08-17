namespace MathApp;

public class Calculator
{
    public double Add(double a, double b) => a + b;

    public double Subtract(double a, double b) => a - b;

    public double Multiply(double a, double b) => a * b;

    public double Divide(double dividend, double divisor)
    {
        if (divisor == 0)
        {
            throw new DivideByZeroException("Divisor cannot be zero.");
        }
        return dividend / divisor;
    }
}