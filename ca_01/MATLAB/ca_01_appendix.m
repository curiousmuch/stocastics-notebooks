%% Appendix Opjectives 
% Plot the first 1000 points of the audio signal and the first 1000 points
% of the mean and variance signals. Also for the Google stock, plot the
% actual stock price, the mean for a frame=1 and window=7 and 
% a frame=1 and a window=30 



%% Import Google Stock Prices 
% Import the excel spreadsheet into an array

clear; clc; clear all;

filename = 'google_v00.xlsx' 
[data, header, raw] = xlsread(filename); 

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

clear windows
clear windowDates 

N = [1];
M = [7 30];
googleFW = table()
fwMean = []

% Raster Through Windows and Frames Dimensions
% 
figure()
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
        
        plot(centerDates, windowsMean);
        hold on; 

    end 
end 

ylim([0 1200]);
datetick('x',2 ,'keeplimits', 'keepticks'); 
xlabel('Time');
ylabel('Price');
title('Google Stock Price') 
legend('M = 1 N = 7', 'M = 1 N = 30') 

%% Import Audio File 
% Import the .raw file into an array 

filename = 'rec_01_speech.raw';
file = fopen(filename, 'r');
audio = fread(file, inf,'short');

audio = audio(1:1001); % cut down audio!  

sampleRate = 8e3  
time = (0:length(audio)-1)*1/(sampleRate);

%% Frame and Window Audio Signal 

M = [1];
N = [10]; 

% Calculate 1000 point index. 
timeLimit = 1000*1/sampleRate;

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

        subplot(3, 1, 1); 
        plot(time, audio);
        xlim([0 timeLimit]);
        xlabel('Time') 
        ylabel('Magnitude')
        titleStr = sprintf(' Audio Signal: Frame = %d Window = %d',...
            frameSize, windowSize);
        title(titleStr);
          subplot(3, 1, 2); 
        plot(meanTimes, windowsMean);
        xlabel('Time') 
        ylabel('Magnitude')
        title('Signal Mean') 
          subplot(3, 1, 3); 
        plot(meanTimes, windowsVariance);
        xlabel('Time') 
        ylabel('Magnitude')
        title('Signal Variance')

    end 
end 