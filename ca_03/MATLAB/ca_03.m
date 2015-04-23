%% Computer Assignment 03 
% 1) Estimate the variance (second central moment) from the entire 
% data set. Plot this as a horizontal dotted line.
% 2) Starting with the first 10 samples, estimate the variance from the
% first N samples of the signal, letting N vary from 0 to a maximum of
% the number of samples in the file. Overlay a plot of this on the plot 
% from (1). Describe what you observe.
% 3) Now estimate the variance using a frame/window approach. For the
% Google stock price, set the frame to 1 day and the window to 30 days.
% For the speech signal, set the frame duration to 10 msec and the window
% duration to 30 msec. Overlay this plot on the above plot

%% Import the Audio and Google datasets 
% Import the excel spreadsheet into an array

clear; clc; clear all;

filename = 'google_v00.xlsx' 
[data, header, raw] = xlsread(filename); 

high = data(:,3); 
low = data(:,4); 
close = data(:,5); 
open = data(:,2); 
dates = x2mdate(data(:,1), 1);

% Import the .raw file into an array 

filename = 'rec_01_speech.raw';
file = fopen(filename, 'r');
audio = fread(file, inf,'short');

%audio = audio(1:10000); % cut down audio!  
 
sampleRate = 8e3  
time = (0:length(audio)-1)*1/(sampleRate);

%% Calculate Variance 

aVar = var(audio); 
gVar = var(close); 
aVar = linspace(aVar, aVar, length(audio)); 
gVar = linspace(gVar, gVar, length(close)); 

%% Generate Vector for Change in Variance 
% increment by 10 samples 

% audio signal 
aDeltaVar = [];  % change in variance of entire signal per 10 samples 
aDeltaTime = [];
for i= 10:10:length(audio) % increment through signal 10 samples at time
    aDeltaTime = [aDeltaTime; time(i)]; 
    aDeltaVar = [aDeltaVar; var(audio(1:i))];
end

% google stock 
gDeltaVar = []; % change in variance...again 
gDeltaTime = [];
for i= 10:10:length(close) % increment through signal 10 samples at time
    gDeltaVar = [gDeltaVar; var(close(1:i))];
    gDeltaTime = [gDeltaTime; dates(i)]; 
end

%% Frame and Window Data and Generate Vector of Window Variance

% audio signal M = 10msec N = 30ms 
M = 10e-3*sampleRate;
N = 30e-3*sampleRate;

sigLength = length(audio); 

frameSize = M; 
windowSize = N; 

% initialize arrays for windows or dates
windows = [];
windowTimes = [];

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

audioFwVars = var(windows, 0, 2);
audioFwTime = mean(windowTimes, 2); 

% google stock
sigLength = length(data); 

frameSize = 1; 
windowSize = 30; 

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
        windowDates = [windowDates; dates(windowLeft: windowRight)']; 
    end 
end

googleFwDates = mean(windowDates, 2); 
googleFwVar = var(windows, 0, 2);

%% Plot Everything! 

% audio signal
figure()
plot(aDeltaTime, aDeltaVar, audioFwTime, audioFwVars, time, aVar, '--')
legend('Cummulative Variance', 'Frame Variance', 'Global Variance') 
xlabel('Time (s)') 
ylabel('Amplitude') 
title('Audio Signal') 
print -depsc plot_01_1

% google signal 
figure()
plot(gDeltaTime, gDeltaVar, googleFwDates, googleFwVar, dates, gVar, '--')
datetick('x',2 ,'keeplimits', 'keepticks'); 
legend('Cummulative Variance', 'Frame Variance', 'Global Variance') 
xlabel('Date') 
ylabel('Amplitude') 
title('Stock Prices') 
print -depsc plot_02_1
