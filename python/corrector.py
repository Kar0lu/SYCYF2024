def corrector(n, k, rm, ep, j):
    register = 0
    for i in range(n):
        current = ((rm >> (n-1-i)) & 1)
        register |= current

        if(i >= j-7 and i <= j): register ^= (ep >> (7-j+i)) & 1

        register <<= 1

    register >>= 1
    return register>>(n-k)