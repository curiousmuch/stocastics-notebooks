# ca_06.py
import numpy as np
import matplotlib.pyplot as plt
from numba import jit


plt.style.use('ggplot')

# GENERATE RANDOM VECTOR [0, 1]
N = 1e3
MAX = 1.0
MEAN = MAX/2
VAR = (1./12)*(1 - 0)**2
BINS = 100
PDF = 1./(MAX*N)


x = np.random.random_integers(0, MAX*N, N)/N


# DEFINE FUNCTIONS
@jit
def xMean(x, N):
    '''
    x = vector of random values.
    N = index to which mean is calculated to.
    '''
    m = np.mean(x[:N])
    return m


@jit
def xVar(x, N):
    '''
    x = vector of random values.
    N = index to which variance is calculated to.
    '''
    v = np.var(x[:N])
    return v


@jit
def xPDF(x, N):
    pdf, binEdges = np.histogram(x[:N], bins=BINS, density=True)
    return pdf, binEdges

MeanError = np.zeros(N)
VarError = np.zeros(N)
MSE = np.zeros(N)


index = range(1, len(x)+1)
for i in index:
    MeanError[i-1] = xMean(x, i) - MEAN
    VarError[i-1] = xVar(x, i) - VAR
    MSE[i-1] = (1./BINS)*sum((xPDF(x, i)[0] - PDF)**2)
    print(i)

# SAVE Data
FILE1 = 'mean_error'
FILE2 = 'variance_error'
FILE3 = 'mse'
np.save(FILE1, MeanError)
np.save(FILE2, VarError)
np.save(FILE3, MSE)


# PLOTS

plt.figure(1)   # mean error
Lindex = np.log(index)/np.log(10)
plt.plot(Lindex, MeanError)
plt.title('Mean Error')
plt.xlabel('N')

plt.figure(2)
plt.plot(Lindex, VarError)
plt.title('Variance Error')
plt.xlabel('N')

plt.figure(3)
plt.plot(Lindex, np.log(MSE)/np.log(10))
plt.title('MSE')
plt.xlabel('N')
