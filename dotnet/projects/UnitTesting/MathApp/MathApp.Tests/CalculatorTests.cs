using MathApp;

namespace MathApp.Tests;

public class CalculatorTests
{
    private readonly Calculator _calc = new();

    [Theory]
    [InlineData(5, 3, 8)]
    [InlineData(-2, -4, -6)]
    [InlineData(-5, 5, 0)]
    public void Add_ValidInputs_ReturnsExpectedSum(double a, double b, double expected)
    {
        var result = _calc.Add(a, b);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData(10, 4, 6)]
    [InlineData(0, 5, -5)]
    public void Subtract_ValidInputs_ReturnsExpectedDifference(double a, double b, double expected)
    {
        var result = _calc.Subtract(a, b);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData(4, 3, 12)]
    [InlineData(-2, 3, -6)]
    [InlineData(0, 100, 0)]
    public void Multiply_ValidInputs_ReturnsExpectedProduct(double a, double b, double expected)
    {
        var result = _calc.Multiply(a, b);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData(10, 2, 5)]
    [InlineData(9, 3, 3)]
    public void Divide_ValidInputs_ReturnsExpectedQuotient(double a, double b, double expected)
    {
        var result = _calc.Divide(a, b);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Divide_ByZero_ThrowsDivideByZeroException()
    {
        Assert.Throws<DivideByZeroException>(() => _calc.Divide(10, 0));
    }
}