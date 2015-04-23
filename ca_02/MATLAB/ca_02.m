%% Import Google Stock Prices 
% Import the excel spreadsheet into an array

clear; clc; clear all;

filename = 'google_v00.xlsx' 
[data, header, raw] = xlsread(filename)

% ease data manipulation with names
High = data(:,3); 
Low = data(:,4); 
Close = data(:,5); 
Open = data(:,2); 
Dates = x2mdate(data(:,1), 1);


%% Frame and Window Stock Data 
% Windows which exceed frames will be trunkcated instead of zero-stuffed. 
% This will "hopefully" prevent skewing the mean and variance.
% Actually no. MATLAB will not permit irregular array sizes to be
% concatenated. There maybe a work around, but I believe Python would be a
% better environment. Frames will be disregarded.
% Okay, well to plot ... how do I plot with a time-series.
% The time values corresponding to the window values selected where
% averaged to reflect the data point calculated from the window. 

% N (Window Size) = 7, 30 
% M (Frame Size) = 1, 7, 14, 30 

clear windows
clear windowDates 

N = [7];
M = [1];
googleFW = table()
fwMean = []
plotIndex = 1; 

% Raster Through Windows and Frames Dimensions
% 
for x = 1:length(N)
    for y = 1: length(M)
   
        sigLength = length(data); 

        frameSize = M(y); 
        windowSize = N(x); 

        % initialize arrays for windows or dates
        windows = []
        windowDates = []

        for z = 1:frameSize:sigLength 
          % calculate the frame center, and then the right and left window indexes 
          frameCenter = floor( z + frameSize/2 ) ;
          windowLeft = floor( (frameCenter - 1) - 0.5*windowSize );
          windowRight = windowLeft + windowSize - 1; 

          % insure the window never exceeds signal
          if (windowLeft >= 1) && (windowRight <= sigLength)
            windows = [windows; data(windowLeft : windowRight, 5)']; 
            windowDates = [windowDates; Dates(windowLeft: windowRight)']; 
          end 
        end
        
        centerDates = mean(windowDates, 2); 

        windowsMean = mean(windows, 2); 
        windowsVariance = var(windows, 0, 2); 
    end 
end 

%% Calculate Global Mean and Linear Regression Vector 

globalMean = mean(windowsMean)
meanVector = linspace(globalMean, globalMean, length(windowsMean))'
linMod = fitlm(centerDates, windowsMean); 


%% Plot Mean, Global Mean, and Linear Regression

figure();
plot(centerDates, windowsMean, centerDates, meanVector, '--', ...
    centerDates, linMod.Fitted, '--')
        ylim([0 1200]);
        datetick('x',2 ,'keeplimits', 'keepticks'); 
        xlabel('Time') 
        ylabel('Price')
        plotIndex = plotIndex + 1
        titleStr = sprintf('Frame = %d Window = %d',...
            frameSize, windowSize);
        title(titleStr); 
        legend('Stock Price', 'Global Mean', 'Linear Regression')
        
%% Import Audio File 
% Import the .raw file into an array 

filename = 'rec_01_speech.raw';
file = fopen(filename, 'r');
audio = fread(file, inf,'short');

        
 %% Calculate Histogram and Cummulative Distribution
BINWIDTH = 1000 
 
figure()
subplot(121);
h = histogram(audio, 'BinWidth', BINWIDTH, 'Normalization', 'probability', ...
    'BinLimits', [-32767 32767])
ylabel('Probability of Sample'); 
xlabel('Amplitude of Sample'); 
title('Histogram of Audio Samples'); 
xlim([-2e4 2e4])

subplot(122);
cdf = histogram(audio, 'BinWidth', BINWIDTH, 'Normalization', 'cdf', ...
    'BinLimits', [-32767 32767]) 
ylabel('Cummulative Probablity of Samples'); 
xlabel('Amplitude of Audio Sample');
title('Cummulative Density Function for Audio Samples');