# -*- coding: utf-8 -*-
"""Python Program to convert temperature in celsius to fahrenheit."""

# change this value for a different result
celsius = float(input('Enter a temperature in celsius: '))

# calculate fahrenheit
fahrenheit = (celsius * 1.8) + 32
print('%0.1f degree Celsius is equal to %0.1f degree Fahrenheit'
      % (celsius, fahrenheit))
