'''
 ca_06_publishing.py
 Loads data from ca_06.py to plot MSE, variance error
 and mean error.
'''
import numpy as np
import matplotlib.pyplot as plt
from numba import jit

plt.style.use('ggplot')
plt.close('all')

# GENERATE RANDOM VECTOR [0, 1]
N = 1e6
MAX = 1.0
MEAN = MAX/2
VAR = (1./12)*(1 - 0)**2
BINS = 100
PDF = 1./(MAX*N)


x = np.random.random_integers(0, MAX*N, N)/N


'''
DEFINE FUNCTIONS
'''
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
    pdf, binEdges = np.histogram(x[:N], bins=BINS, density=False)
    return pdf, binEdges


'''
Plot PDFs
'''
index = [1e1, 1e3, 1e6]
subplots = [1, 2, 3]
for i, j in zip(index, subplots):
    pdf, binedges = xPDF(x, i)
    plt.figure(4)
    plt.subplot(3, 1, j)
    plt.bar(binedges[:-1], pdf/i, width=0.01)
    plt.xlim(0, 1)
    plt.ylabel(r'N = '+str(i))


'''
Load Data from ca_06.py
'''
MeanError = np.load('mean_error.npy')
VarError = np.load('variance_error.npy')
MSE = np.load('mse.npy')

index = linspace(1, N, N)

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

