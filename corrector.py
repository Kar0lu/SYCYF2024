def corrector(n, k, rm, ep, j):
    # print('-----Error Correction Register-----')

    error = 0

    for i in range(5):

        error |= (ep >> i) & 1
        error <<= 1
        
    error >>= 1
    register = 0
    
    for i in range(k):
        current = ((rm >> (n-1-i)) & (1))

        if(i >= j and i <= j+5):
            register |= current ^ ep&1
            ep >>= 1
        else:
            register |= current

        register <<= 1

    register >>= 1
    return register