# -*- coding: utf-8 -*-
"""Code sample: using random numbers and loops."""

import random

minNumber = 1  # input('Enter the minimum number: ')
maxNumber = 5  # input('Enter the maximum number: ')
attempts = 3

if (minNumber < maxNumber):
    random_number = random.randint(minNumber, maxNumber)
    count = 0
    while count < attempts:
        count = count + 1
        guess = int(input("Guess the 'Magic Number'."
                          " Enter a value between {0} and {1}: "
                          .format(minNumber, maxNumber)))
        if random_number == guess:
            print('You got it, the magic number was {0}'.format(guess))
            break
        elif random_number != guess and count >= attempts:
            print('You lost!, the magic number was {0}'.format(random_number))
        else:
            print('Try again...')

else:
    print('The maximum number must be greater than the minimum number')
