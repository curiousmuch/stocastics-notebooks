%% Import Google Stock Prices 
% Import the excel spreadsheet into an array

clear; clc; clear all;

filename = 'google_v00.xlsx' 
[data, header, raw] = xlsread(filename); 

%% Plot the Stock Data with Variance 
% Plot data utilizing the highlow function which  plots the high, low, 
% opening, and closing prices of an asset. Plots are vertical lines whose
% top is the high, bottom is the low, open is a short horizontal tick to
% the left, and close is a short horizontal tick to the right.

% ease data manipulation with names
High = data(:,3); 
Low = data(:,4); 
Close = data(:,5); 
Open = data(:,2); 
Dates = x2mdate(data(:,1), 1);

subplot(211);
highlow(High, Low, Close, Open, 'b', Dates, 1);
datetick('x', 1, 'keeplimits')
xlabel('Time') 
ylabel('Price')
title('High-Low Plot of Closing Prices')

subplot(212); 
plot(Dates, Close); 
xlabel('Time') 
ylabel('Price')
datetick('x', 1)
title('Plot of Closing Prices')


%% Calaculate Global Statistics of Stock Prices
% The first column is the date therefore it is excluded when 
% global statistics are calculated

Min = min(data); 
Max = max(data); 
Mean = mean(data);
Median = median(data);
Variance = var(data);

googleStats = table(Min, Max, Mean, Median, Variance); 

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

N = [7 30];
M = [1 7 14 30];
googleFW = table()
fwMean = []
plotIndex = 1; 
figure() 

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

        subplot(4, 2, plotIndex); 
        plot(centerDates, windowsMean, centerDates, windowsVariance, 'r')
        ylim([0 1200]);
        datetick('x',2 ,'keeplimits', 'keepticks'); 
        xlabel('Time') 
        ylabel('Price')
        plotIndex = plotIndex + 1
        titleStr = sprintf('Frame = %d Window = %d',...
            frameSize, windowSize);
        title(titleStr); 
        fwMean = [fwMean ; mean(windowsMean)] 
    end 
end 

%% Import Audio File 
% Import the .raw file into an array 

filename = 'rec_01_speech.raw';
file = fopen(filename, 'r');
audio = fread(file, inf,'short');

%% Plot the Audio Signal 
%

sampleRate = 8e3  
time = (0:length(audio)-1)*1/(sampleRate);

figure(); 
plot(time, audio);
title('Plot of Audio Signal') 
xlabel('time (s)') 
ylabel('Amplitude') 


%% Calculate Global Statistics of Audio Signal
% The stats are stored in the table signalStats

Min = min(audio); 
Max = max(audio); 
Mean = mean(audio);
Median = median(audio);
Variance = var(audio);

signalStats = table(Min, Max, Mean, Median, Variance); 

%% Frame and Window Audio Signal 

% N (window size) 
% M (frame size)
M = [40, 80, 160];
N = [160 240]; 

plotIndex = 1;
figure();

% Raster Through Windows and Frames Dimensions
% 
for x = 1:length(N)
    for y = 1: length(M)
   
        sigLength = length(audio); 

        frameSize = M(y); 
        windowSize = N(x); 

        % initialize arrays for windows or dates
        windows = []
        windowTimes = []

        for z = 1:frameSize:sigLength 
          % calculate the frame center, and then the right and left window indexes 
          frameCenter = floor( z + frameSize/2 ) ;
          windowLeft = floor( (frameCenter - 1) - 0.5*windowSize );
          windowRight = windowLeft + windowSize - 1; 

          % insure the window never exceeds signal
          if (windowLeft >= 1) && (windowRight <= sigLength)
            windows = [windows; audio(windowLeft : windowRight)']; 
            windowTimes = [windowTimes; time(windowLeft : windowRight)];
          end 
        end
        
        meanTimes = mean(windowTimes, 2); 
        windowsMean = mean(windows, 2); 
        windowsVariance = var(windows, 0, 2); 

        subplot(6, 2, plotIndex); 
        plot(meanTimes, windowsMean);
        xlabel('Time') 
        ylabel('Magnitude')
        titleStr = sprintf('Frame = %d Window = %d',...
            frameSize, windowSize);
        title(titleStr);
        plotIndex = plotIndex + 1; 
        subplot(6, 2, plotIndex);          
        plot(meanTimes, abs(windowsVariance), 'k');
        xlabel('Time') 
        ylabel('Magnitude')
        plotIndex = plotIndex + 1
        titleStr = sprintf('Frame = %d Window = %d',...
            frameSize, windowSize);
        title(titleStr);
    end 
end 
