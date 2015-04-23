'''
    This is a collection of function written to assist in Dr. Picone's
    signals class
'''

import numpy as np
import matplotlib.pyplot as plt


def u(x):
    '''
        Simulates the great heaviside function. I'm sorry Heaviside that I am
        too lazy to write your name. You're a great man and you deserve more.
    '''
    result = []
    for num in x:
        if num < 0:
            result.extend([0])
        else:
            result.extend([1])
    return np.array(result)


def readRaw(filename):
    '''
    Import the Signal from a .raw file with 8kHz sampling
    '''
    dataFile = open(filename, 'r')   # data is signed 16bit
    dataString = dataFile.read()
    data = np.fromstring(dataString, dtype=np.int16)
    data = data.astype(float)   # convert to float for normalization
    return data


def fftplot(Fs, x, title=''):
    '''
    This function plots the fft via numpy and matplotlib.
    Fs = the sampling frequency
    x = the discrete signal
    Exand with windowing*****
    '''
    X = np.fft.fft(x)
    f = np.fft.fftfreq(len(x), 1./Fs)
    plt.plot(f, abs(X))
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Amplitude')
    plt.title(title)


def signalplot(t, x, title=''):
    plt.plot(t, x)
    plt.xlabel('Time')
    plt.ylabel('Amplitude')
    plt.title(title)


def slidingWindow(sequence, winSize, step=1):
    """
    returns the windows of a sequence based on winSize and the step or frame
    size.
    """

    # Pre-compute number of chunks to emit
    numFrames = len(sequence)/step
    if numFrames % 1 > 0.0:                 # if number of frames is not even
        numFrames = int(numFrames + 1)       # expand past

    print "Number of Frames:", numFrames

    windows = []
    for frameIndex in range(0, numFrames+1):  # why the blimp to I need a + 1
        midFrame = int(0.5*step + frameIndex*step)  # calculate midframe an int

        if (midFrame - winSize/2) <= 0:
            window = sequence[0: midFrame + winSize/2]
            neededZeros = winSize/2 - midFrame
            window = np.concatenate(([0]*int(neededZeros), window))

        elif midFrame + winSize/2 >= len(sequence):
            window = sequence[midFrame - winSize/2:len(sequence) - 1]
            neededZeros = winSize/2 + midFrame - len(sequence) + 1
            window = np.concatenate((window, [0]*neededZeros))
        else:
            window = sequence[midFrame - winSize/2:midFrame + winSize/2]

        windows.append(window)
    return windows

#data = readRaw('rec_01_speech.raw')
#x = slidingWindow(data, 1024, 252)