from mpmath import mp
import json

from encoder import encoder
from pregister import pregister
from cregister import cregister
# from color import color
from corrector import corrector
from generator import generator

# global used
n = 279
k = 265
l = 5

results = {}

# # ----------manual input----------
# # message
# m = 0b11101011010101000101011101101001010101110110011001101100101010101110100010011110100011011001111000101110010110011111010000010101111101011010111011011001111110001000000011001010011100100011110000101111010010000101111110111100100000001010110111111010110110101110010

# # error pattern
# e = 0b101
# results['Tested_Error'] = bin(e)[2:]

# assert(len(bin(e)[2:]) <= l)

# # error location
# el = 0
# # --------------------------------

# -----------auto input-----------
m, e, el = generator(n, k, l)
assert(m < mp.power(2, k))
assert(e < mp.power(2, l))
# --------------------------------
ex = len(bin(e)[2:])
if(el+ex > n): e >>= (el+ex)-n
else: e <<= n-(el+ex)

# coding polynomial
g = 0b100101000100101
assert(len(bin(g)[2:]) == n-k+1)

# encoded message
em = encoder(n, k, m)

# recived message (with error)
rm = em ^ e

# shifting performed by the circuit
ep, rc = cregister(n, k, rm)
rp = pregister(n, k, rm, ep)

# rp, rc and modulo coefficients depend on g(x)
i =  (63*rp - 62*rc-1) % n

cm = corrector(n, k, rm, ep, i)


# # -----------manual results-----------
# print('----------Results----------')

# print('Original Message: ', color(bin(m)[2:].zfill(k), el, el+ex, k, n))

# print('Encrypted Message:', color(bin(em)[2:].zfill(n), el, el+ex, k, n))
# print('Recived Message:  ', color(bin(rm)[2:].zfill(n), el, el+ex, k, n))
# print('Corrected message:', color(bin(cm)[2:].zfill(k), el, el+ex, k, n))

# print("Error Pattern:", bin(ep)[2:])
# print('Error Location:', i)

# # ultimate test
# print('Is correct:', m==cm)
# # ------------------------------------


# ------------auto results------------
results['Tested_Location'] = el
results['Original_Message'] = bin(m)[2:]
results['Encrypted_Message'] = bin(em)[2:]
results['Received_Message'] = bin(rm)[2:]
results['Corrected_Message'] = bin(cm)[2:]
results['Error_Pattern'] = bin(ep)[2:]
results['Error_Location'] = i
results['Is_Corrected'] = m == cm

results_json = json.dumps(results, indent=4)

# print('----------Results----------')
print(results_json)
# ------------------------------------