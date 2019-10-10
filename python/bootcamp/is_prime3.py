def is_prime3(n, i=2):
    '''
    Recursive program for prime number
    '''
    if (n <= 2):
        return True if(n == 2) else False
    if (n % i == 0):
        return False
    if (i * i > n):
        return True

    # Check for next divisor
    return is_prime3(n, i + 1)


if is_prime3(int(input('Enter a number: '))):
    print('is prime!')
else:
    print('is not prime')
