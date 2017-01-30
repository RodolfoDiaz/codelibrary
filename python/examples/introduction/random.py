import random

minNumber = input('Enter the minimum number: ')
maxNumber = input('Enter the maximum number: ')

if (minNumber < maxNumber):
    guess = random.randint(minNumber, maxNumber)
else:
    print('The maximum number must be greater than the minimum number')