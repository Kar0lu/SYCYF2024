from mpmath import mp
import json

from encoder import encoder
from pregister import pregister
from cregister import cregister
from color import color
from corrector import corrector
from generator import generator

# global used
n = 7665
k = 7641
l = 8

n_ = 64
k_ = 40

results = {}

# ----------manual input----------
# message
m = 0b1001110101010100100001101010101010010001

# error pattern
e = 0b11011001
results['Tested_Error'] = bin(e)[2:]

assert(len(bin(e)[2:]) <= l)

# error location
el = 0
# --------------------------------

# # -----------auto input-----------
# m, e, el = generator(n_, k_, l)
# assert(m < mp.power(2, k_))
# assert(e < mp.power(2, l))
# # --------------------------------
ex = len(bin(e)[2:])
if(el+ex > n_): e >>= (el+ex)-n_
else: e <<= n_-(el+ex)

# coding polynomial
g = 0b1000010001000001000010001
assert(len(bin(g)[2:]) == n-k+1)

# encoded message
em = encoder(n_, k_, m)

# recived message (with error)
rm = em ^ e

# shifting performed by the circuit
ep, rc = cregister(n_, rm)
rp = pregister(n_, rm, ep)


# rp, rc and modulo coefficients depend on g(x)
i =  (-510*rp + 511*rc -7099) % n

cm = corrector(n_, k_, rm, ep, i)


# -----------manual results-----------
print('----------Results----------')

print('Original Message: ', color(bin(m)[2:].zfill(k_), el, el+ex, k, n))

print('Encrypted Message:', color(bin(em)[2:].zfill(n_), el, el+ex, k, n))
print('Recived Message:  ', color(bin(rm)[2:].zfill(n_), el, el+ex, k, n))
print('Corrected message:', color(bin(cm)[2:].zfill(k_), el, el+ex, k, n))

print("Error Pattern:", bin(ep)[2:])
print('rc: ', rc, 'rp: ', rp )
print('Error Location:', i)

# ultimate test
print('Is correct:', m==cm)
# ------------------------------------


# # ------------auto results------------
# results['Tested_Location'] = el
# results['Original_Message'] = bin(m)[2:]
# results['Encrypted_Message'] = bin(em)[2:]
# results['Received_Message'] = bin(rm)[2:]
# results['Corrected_Message'] = bin(cm)[2:]
# results['Error_Pattern'] = bin(ep)[2:]
# results['Error_Location'] = i
# results['Is_Corrected'] = m == cm

# results_json = json.dumps(results, indent=4)

# # print('----------Results----------')
# print(results_json)
# # ------------------------------------