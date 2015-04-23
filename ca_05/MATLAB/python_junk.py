from sigpy import *
import matplotlib.pyplot as plt
from sigpy import *
from scipy.interpolate import interp1d

filename = 'rec_01_speech.raw'
data = readRaw(filename)

Fs = 8e3
x0 = floor(1.1*Fs)

sigFFT = fft.rfft(data)
f = fft.rfftfreq(len(data), d=1./Fs)