# simulation of encoding shifter
def encoder(n, k, m):
    # print('-----Encoding-----')
    # counter = 0
    register = 0

    for i in range(k):
        # counter += 1
        current = ((m >> (k-1-i)) & (1))
        
        buffor = (register & 1) ^ current

        register >>= 1
        register |= (buffor << 13)
        register ^= (buffor << 11)
        register ^= (buffor << 8)
        register ^= (buffor << 4)
        register ^= (buffor << 2)
    
        # print(f'[{counter%266}] [{current}] | {format(eshifter, "#016b")[2:]}')
    
    # counter = 0
    v = 0

    for i in range(n-k):
        v += (register >> i) & 1
        v <<= 1
    v >>= 1
    return (m << n-k) + v