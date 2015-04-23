import numpy as np
from numba import jit

N = int(1e6)
binwidth = 10

x = random_integers(0,N,N)

@jit
def xPDF(x, N, binwidth):
    bins = np.bincount(x, minlength=N)
    pdf = np.zeros(N/10)
    for index, limit in enumerate(range(0, N, binwidth)):
        pdf[index] = sum(bins[limit:limit+binwidth])
    return pdf/N

print xPDF(x, N, binwidth)