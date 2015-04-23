from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

'''
PART I
'''


def cahist(N, BINS):
    N = int(N)
    x, y = np.random.rand(2, N)
    H, xbins, ybins = np.histogram2d(x, y, bins=BINS)
    return H, xbins, ybins

N = 1e6
pdf_xy, xbins, ybins = cahist(N, 20)
print pdf_xy
pdf_xy = pdf_xy/(N**2)

fig = plt.figure()
X, Y = np.meshgrid(xbins[:-1], ybins[:-1])  # create meshgrid from bin edges
ax = fig.gca(projection='3d')
ax.set_zlim(2e-9, 3e-9)
surf = ax.plot_surface(X, Y, pdf_xy, rstride=1, cstride=1, linewidth=0,
                       antialiased=False)  # plot ampltude of pdf_xy
ax.set_xlabel('X-Value')
ax.set_ylabel('Y-Value')
ax.set_zlabel('PDF_XY')
fig.patch.set_facecolor('white')

