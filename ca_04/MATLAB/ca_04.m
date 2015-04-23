%% Computer Assignment 04
% 1) Compute a histogram of the amplitude of the data and normalize it by
% the number of samples so that it is an estimate of the pdf.
%
% 2) Fit this distribution by estimating the mean and variance. Plot the
% Gaussian model on top of the histogram. Compare and contrast the quality of
% the fits to the data.
%
% 3) In (2), you should find that the Gaussian model is not a good
% fit for the Google data. Select another distribution from Chapter 4 that
% provides a better estimate of the data. Plot this model on the same graph
% with the histogram and the Gaussian fit. Compute the mean-squared error
% between the actual data and the parametric fit. Which gives a better
% approximation? (Do this for both data sets.)

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


%% Nomarilze Data
% double check normalization
figure()
subplot(211)
plot(audio)
title('Audio Signal') 
xlabel('Time (seconds)') 
ylabel('Amplitude') 
subplot(212)
plot(dates, close)
datetick('x',2 ,'keeplimits', 'keepticks'); 
title('Google Stock Price') 
ylabel('Price') 
xlabel('Date') 

print -depsc2 time_plot.eps


%% Calculate Histograms
% Audio Signal
BINWIDTH = 1;

fplota = figure()
h = histogram(audio, 'BinWidth', BINWIDTH, 'Normalization', 'probability', ...
    'BinLimits', [-32767 32767]);
h.EdgeColor = [0.3510, 0.3245, 0.3245];
h.FaceColor = [0.3510, 0.3245, 0.3245];
hista = h.Values;
ylabel('Probability of Sample');
xlabel('Amplitude of Sample');
title('Histogram of Audio Samples');
xlim([-2e4 2e4])

% Stock Price
BINWIDTH = 1;

fplotg = figure()
h = histogram(close, 'BinWidth', BINWIDTH, 'Normalization', 'probability');
h.EdgeColor = [0.3510, 0.3245, 0.3245];
h.FaceColor = [0.3510, 0.3245, 0.3245];
histg = h.Values;
ylabel('Probability of Sample');
xlabel('Amplitude of Sample');
title('Histogram of Stock Prices');

%% Calculate Mean and Variance for Modeling

% Audio Signal
meanA = mean(audio);
varA = var(audio);

% Stock Price
meanG = mean(close);
varG = var(close);

%% Generate and Plot Gaussian Model

% Audio Signal
a = linspace(min(audio), max(audio), length(hista));
f_a = 1./(sqrt(2*pi.*varA))*exp(-((a-meanA).^2)/(2*varA));

figure(fplota)
hold on;
plot(a, f_a, 'r')
legend('pdf', 'normal distribution')
print -depsc2 audio_plot.eps

% Stock Price
p = linspace(min(close), max(close), length(histg));
f_p = 1./(sqrt(2*pi.*varG))*exp(-((p-meanG).^2)/(2*varG));

figure(fplotg)
hold on;
plot(p, f_p, 'r')
legend('pdf', 'normal distribution')

%% Calculate Mean Squared Error Between Models and PDFs

msea_normal = mean((hista - f_a).^2)
mseg_normal = mean((histg - f_p).^2)

%% Overlay New Distribution Model for Google and Audio Data
% The stock price's distribution will not fit any "off the shelf"
% parameter distributions. 
figure(fplotg)
pdG = fitdist(close,  'lognormal')
plot(p, pdG.pdf(p))
legend('pdf', 'normal distribution', 'log-normal distribution')
mseg_lognormal = mean((histg - pdG.pdf(p)).^2);
print -depsc2 google_plot.eps

figure(fplota)
pdA = fitdist(audio, 'tLocationScale') 
plot(a, pdA.pdf(a))
legend('pdf', 'normal distribution', 't Location-Scale distribution')
msea_tLocationScale = mean((hista-pdA.pdf(a)).^2) 
print -depsc2 audio_plot.eps


