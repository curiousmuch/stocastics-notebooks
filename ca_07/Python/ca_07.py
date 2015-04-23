from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

'''
PART I
'''


def cahist(N, BINS):
    x, y = np.random.rand(2, N)
    H, xbins, ybins = np.histogram2d(x, y, bins=BINS)
    return H, xbins, ybins

N = 1e6
pdf_xy, xbins, ybins = cahist(N, 20)
pdf_xy = pdf_xy/(N**2)

plt.figure()
X, Y = np.meshgrid(xbins[:-1], ybins[:-1])  # create meshgrid from bin edges
ax = plt.gca(projection='3d')
surf = ax.plot_surface(X, Y, pdf_xy, rstride=1, cstride=1, linewidth=0,
                       antialiased=False)  # plot ampltude of pdf_xy

'''
PART II
np.radom.rand() generate a normal distribution with a \sigma^2 = 1 and
    \mu = 0
'''


def cahistn(N, mu, corr_mat, BINS):
    N = int(N)
    normdist = np.random.multivariate_normal(mu, corr_mat, N)
    H, xbins, ybins = np.histogram2d(normdist[:, 0], normdist[:, 1],
                                     bins=BINS)
    return H, xbins, ybins

# LOAD CONSTANTS
N = 1e6
mu = [6, 6]
BINS = 25

# LOAD CORRELATION MATRICES
corr1 = [[1, 0], [0, 1]]
corr2 = [[1, 0], [0, 1]]
corr3 = [[5, 0], [0, 2]]
corr4 = [[1, 0.5], [0.5, 1]]
corr5 = [[5, 0.5], [0.5, 2]]
corr_mats = [corr1, corr3, corr3, corr4, corr5]



fig = plt.figure(figsize=(10, 10))
for index, corr_mat in enumerate(corr_mats):
    pdf_xy, xbins, ybins = cahistn(N, mu, corr_mat, BINS)
    pdf_xy = pdf_xy/(N**2)

    X, Y = np.meshgrid(xbins[:-1], ybins[:-1])  # create meshgrid from binedges
    ax =  fig.add_subplot(3, 2, index+1, projection='3d')
    #surf = ax.plot_surface(X, Y, pdf_xy, rstride=1, cstride=1, linewidth=0,
    #                       antialiased=False)  # plot ampltude of pdf_
    cset = ax.contour(X, Y, pdf_xy, zdir='z', offset=0, cmap=cm.coolwarm)
    cset = ax.contour(X, Y, pdf_xy, zdir='x', offset=min(xbins), cmap=cm.coolwarm)
    cset = ax.contour(X, Y, pdf_xy, zdir='y', offset=max(ybins), cmap=cm.coolwarm)

    plt.xlabel('X-Value')
    plt.ylabel('Y-Value')
    str_title = 'Covariance Matrix ' \
                + str(index+1)
    plt.title(str_title)
    fig.patch.set_facecolor('white')
    plt.tight_layout()