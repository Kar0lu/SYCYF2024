# simulation of error pattern register
# number of shifts and placement of xor gates depends on g(x)

def cregister(n, k, v):   
    print('-----Error Pattern Register-----')
    counter = 0
    register = 0

    for i in range(n):
        counter += 1
        current = ((v >> (n-1-i)) & (1))
        
        buffor = (register & 1) ^ current

        register >>= 1
        register |= (buffor << 8)
        
        
        if (i<5 or i>n-6): print(f'[{counter%(n+1)}] [{current}] | {format(register, "#011b")[2:]}')
    
    counter = 0
    print('---------Rc Shifts---------')
    while((register & 0b1111)!= 0):
        counter += 1
        
        buffor = register & 1

        register >>= 1
        register |= (buffor << 8)
        
        print(f'[{counter}] [{0}] | {format(register, "#011b")[2:]}')

    return register >> 4, counter