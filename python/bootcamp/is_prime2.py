"""A method to check whether is prime."""

import math


def is_prime2(num):
    """Better method of checking for primes."""
    if num % 2 == 0 and num > 2:
        return False
    for i in range(3, int(math.sqrt(num)) + 1, 2):
        if num % i == 0:
            return False
    return True


if is_prime2(int(input('Enter a number: '))):
    print('is prime!')
else:
    print('is not prime')
