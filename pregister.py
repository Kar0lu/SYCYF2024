# simulation of error location register
# number of shifts and placement of xor gates depends on g(x)

def pregister(n, k, v, ep):   
    print('-----Error Location Register-----')
    counter = 0
    register = 0

    for i in range(n):
        counter += 1
        current = ((v >> (n-1-i)) & (1))
        
        buffor = (register & 1)

        register >>= 1
        register |= ((buffor ^ current) << 4)
        register ^= (buffor << 2)
        
        
        if (i<5 or i>n-6): print(f'[{counter%(n+1)}] [{current}] | {format(register, "#07b")[2:]}')
    
    counter = 0
    print('---------Rp Shifts---------')
    while(register != ep):
        counter += 1
        
        buffor = register & 1

        register >>= 1
        register |= (buffor << 4)
        register ^= (buffor << 2)
        
        print(f'[{counter}] [{0}] | {format(register, "#07b")[2:]}')

    return counter