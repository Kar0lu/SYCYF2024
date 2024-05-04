def corrector(n, k, rm, ep, j):
    # print('-----Error Correction Register-----')

    # error = 0

    # for i in range(5):

    #     error |= (ep >> i) & 1
    #     error <<= 1
        
    # error >>= 1
    # print(bin(error))
    # register = 0
    
    # for i in range(k):
    #     current = ((rm >> (n-1-i)) & (1))

    #     if(i >= j and i <= j+5):
    #         register |= current ^ ep&1
    #         ep >>= 1
    #     else:
    #         register |= current

    #     register <<= 1

    # register >>= 1


# -----Attempt 1-----
    # error = ep

    # for i in range(k):
    #     current = ((rm >> (n-1-i)) & (1))

# -----Attempt 2-----
    register = 0
    for i in range(n):
        current = ((rm >> (n-1-i)) & 1)
        register |= current

        if(i >= j-4 and i <= j): register ^= (ep >> (4-j+i)) & 1

        register <<= 1

    register >>= 1
    return register>>(n-k)