def myfunc(s):
    ret_val = ''
    index = 0
    for letter in s:
        if index % 2 == 0:
            ret_val = ret_val + letter.upper()
        else:
            ret_val = ret_val + letter.lower()
        index = index+1

    return ret_val


print(myfunc('hello world'))
