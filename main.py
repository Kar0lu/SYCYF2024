from encoder import encoder
from pregister import pregister
from cregister import cregister
from color import color
from corrector import corrector

# global used
n = 279
k = 265

# error pattern
# edit subtracted value to change position (this case 255)
el = (n-5) - 255
e = 0b11111

if(el < 0):
    leftovers = e & ((1 << -el) - 1)
    e >>= -el
    leftovers <<= n+el
    e|= leftovers
else:
    e <<= el

assert(len(bin(e)[2:]) <= n)

# message
m = 0b1010010111000100101010100101010001101001010011110001010111010101000010010100010101010010110101000101010100110001010001010101001011010100010101010010110101000101010100101101010001010101001011010111010101010010110100101101001011010010110100101101001011010010110100101
assert(len(bin(m)[2:]) == k)

# coding polynomial
g = 0b100101000100101
assert(len(bin(g)[2:]) == n-k+1)

# encoded message
em = encoder(n, k, m)

assert(len(bin(em)[2:]) == n)
assert(bin(em)[2:k+2] == bin(m)[2:])

rm = em ^ e

# shifting performed by the circuit
ep, rc = cregister(n, k, rm)
rp = pregister(n, k, rm, ep)

# rp, rc and modulo coefficients depend on g(x)
i =  (63*rp - 62*rc -5) % n

cm = corrector(n, k, rm, ep, i)

# outputs
print('----------Results----------')

print('Original Message: ', color(m, n-5-el, n-el, k, n))

print('Encrypted Message:', color(em, n-5-el, n-el, k, n))
print('Recived Message:  ', color(rm, n-5-el, n-el, k, n))
print('Corrected message:', color(cm, n-5-el, n-el, k, n))

print("Error Pattern:", bin(ep)[2:])
print('Error Location:',i)

# ultimate test
assert(m==cm)

print('Rc:', rc)
print('Rp:', rp)