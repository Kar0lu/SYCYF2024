import random

def generator(n, k, l):

    m = random.randint(0, (2**k)-1)
    e = random.randint(0, (2**l)-1) | 1
    el = random.randint(0, n-1)

    return m, e, el