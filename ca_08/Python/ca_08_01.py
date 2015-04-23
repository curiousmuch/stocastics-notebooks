import numpy as np
import scipy.stats as stats
from numpy.random import rand
import matplotlib.pyplot as plt
import time
plt.style.use('bmh')


def uniformSum(n, N, a, b):
    X_n = (b - a)*rand(N, n) + a  # generate uniform RVs between b and a
    S_n = np.sum(X_n, axis=1)  # sum
    S_n = S_n/max(abs(S_n))
    return S_n


def normal(x, mu, variance):
    pdf = (1./np.sqrt(2*np.pi*variance))*np.exp((-(x-mu)**2)/(2*variance))
    return pdf


def findcenterbins(bins):
    centerBins = np.zeros(len(bins) - 1)
    for index in range(0, len(bins) - 1):
        centerBins[index] = np.mean([bins[index + 1], bins[index]])
    return centerBins


def MSE(f1, f2):
    mse = np.mean((f1-f2)**2)
    return mse


# PARAMETERS
N = 10000
a = -1
b = 1
BINS = 100
NSUMS = 100

# MEMORY ALLOCATION
S_n = np.zeros(N)
error = np.zeros(NSUMS)
for n in range(1, NSUMS+1):
    S_n = uniformSum(n, N, a, b)                            # generate sum
    sVar = np.var(S_n)                                      # compute variance
    sMu = np.mean(S_n)                                      # compute mean
    sPDF, bins = np.histogram(S_n, bins=BINS, normed=True)  # compute PDF
    centerbins = findcenterbins(bins)           # compute the center of bins
    sNormal = normal(centerbins, sMu, sVar)     # compute norm dis via metrics

    error[n-1] = np.sqrt(MSE(sPDF, sNormal))

# PLOTS
n = range(1, NSUMS+1)
eplt = plt.figure(1)
ax = eplt.add_subplot(111)
ax.plot(n, error, label=r'$\sqrt{MSE}$')
ax.legend()
ax.set_xlabel(r'$n$')
plt.show()

# plot n = {1, 10, 100}
ns = [1, 10, 100]
hplt, axs = plt.subplots(3, 1, sharex=True, sharey=True)
for n, ax in zip(ns, axs):
    S_n = uniformSum(n, N, a, b)
    sVar = np.var(S_n)                                      # compute variance
    sMu = np.mean(S_n)                                      # compute mean
    centerbins = findcenterbins(bins)           # compute the center of bins
    sNormal = normal(centerbins, sMu, sVar)     # compute norm dis via metrics

    ax.hist(S_n, bins=BINS, normed=True, alpha=0.5, label=r'$PMF_{S_{%d}}$' % n)
    ax.plot(centerbins, sNormal, label=r'$N(S_{%d})$' % n)
    ax.legend()


# BOX-Muller Transform
def boxmuller(N):
    a = 0; b = 1; n = 1
    U1 = (b - a)*rand(N, n) + a
    U2 = (b - a)*rand(N, n) + a  # generate uniform RVs between b and a
    R = np.sqrt(-2*np.log(U1))
    theta = 2*np.pi*U2
    Z1 = R*np.cos(theta)
    return Z1

# TIME TEST

N = 10000
ns = range(1, 11)
trials = range(0, 10)
start = zeros(10)
end = zeros(10)
tstart = zeros(10)
tend = zeros(10)

for n in ns:
    for trial in trials:
        tstart[trial] = time.time()
        uniformSum(n, N, 0, 1)
        tend[trial] = time.time()
    start[n-1] = np.mean(tstart)
    end[n-1] = np.mean(tend)
utime = end - start

S_n = []
error2 = []
for trial in trials:
        start[trial] = time.time()
        S_n = boxmuller(N)
        end[trial] = time.time()
print S_n
sVar = np.var(S_n)                                      # compute variance
sMu = np.mean(S_n)                                      # compute mean
sPDF, bins = np.histogram(S_n, bins=BINS, normed=True)  # compute PDF
centerbins = findcenterbins(bins)           # compute the center of bins
sNormal = normal(centerbins, sMu, sVar)     # compute norm dis via metrics
error2 = np.sqrt(MSE(sPDF, sNormal))

btime = np.mean(end - start)

tplot = plt.figure(3)
ax1 = tplot.add_subplot(211)
ax2 = tplot.add_subplot(212)
ax1.plot(ns, utime, label='$S_n$ (10 trials per n)')
ax1.plot(ns, [btime]*10, label='Box Muller')
ax2.plot(ns, [error2]*len(ns), label=r'Err(Box-Muller)')
n = np.arange(1, 11)
ax2.plot(n, error[0:len(n)], label='Err($S_n$)')
z = np.polyfit(ns, utime, 1)
p = np.poly1d(z)
ax1.plot(ns, p(ns), '--')
ax1.legend()
ax2.set_xlabel(r'$n$')
ax1.set_ylabel(r'$t$ (secs)')
ax2.set_ylabel(r'$\sqrt{MSE}$')

ax2.legend()
tplot.tight_layout()