%% Computer Assignment 5

% Import the .raw file into an array

filename = 'rec_01_speech.raw';
file = fopen(filename, 'r');
audio = fread(file, inf,'short');

%audio = audio(1:10000); % cut down audio!

sampleRate = 8e3
time = (0:length(audio)-1)*1/(sampleRate);

%% Task 1
% \rho_{X,Y} = corr(X,Y) = \frac{cov(X,Y)}{\sigma_X\sigma_Y} =
% E[(X-\mu_x)(Y-\mu_Y)]}{\sigma_X\sigma_Y} 

clf;

h = [floor(sampleRate*0.9) floor(sampleRate*1.1) floor(sampleRate*3.0)]; 

figure();
title('Autocorrelation Function'); 
for i=1:length(h); 
    x = audio(h(i):h(i)+239);
    corr_xy = zeros(512+1); 
    for k = 0:512
       y = audio(h(i)+k:h(i)+239+k); 
       corr_xy(k+1) = mean( (x - mean(x)).*(y - mean(y))) / (std(x)*std(y));
    end
    k = 0:512;
    subplot(3,1,i)
    plot(k, corr_xy); 
    titleSTR = sprintf('Correlation Coefficient: Offset x_%d', i) 
    title(titleSTR); 
    xlabel('k')
end

%% Task 2 

N = 240;
x_0 = floor(sampleRate*0.9); % 0.9 second delay 
x_1 = floor(sampleRate*1.1); % 1.1 second delay 
x_2 = floor(sampleRate*3.0); % 3.0 second delay 


corr_matrix_x0 = zeros(16, 16); 
corr_matrix_x1 = zeros(16, 16); 
corr_matrix_x2 = zeros(16, 16); 


% Due to lazyness, I'm copying and pasting code for each offset instead of
% generating a for loop to increment through and array of offset values. 

% index matrix and insert blah
for i=0:15 
    for j=0:15 
        sum = 0;
        for n = 0:N-1
            sum = sum + audio(n-i+x_0)*audio(n-j+x_0);
        end 
        corr_matrix_x0(i+1,j+1) = (1/N)*sum; 
    end
end 

for i=0:15 
    for j=0:15 
        sum = 0;
        for n = 0:N-1
            sum = sum + audio(n-i+x_1)*audio(n-j+x_1);
        end 
        corr_matrix_x1(i+1,j+1) = (1/N)*sum; 
    end
end 

for i=0:15 
    for j=0:15 
        sum = 0;
        for n = 0:N-1
            sum = sum + audio(n-i+x_2)*audio(n-j+x_2);
        end 
        corr_matrix_x2(i+1,j+1) = (1/N)*sum; 
    end
end 

%% Generate Plots 
% I have no clue at what I'm looking at so why not plot it in 3D. 3D is
% cool right. 
figure()
waterfall(corr_matrix_x0); 
title('Covariance Matrix with Offset x_0');
figure()
waterfall(corr_matrix_x1);
title('Covariance Matrix with Offset x_1');
figure()
waterfall(corr_matrix_x2);
title('Covariance Matrix with Offset x_2')

%% Plot Audio Signal Segments 

NFFT = 2^nextpow2(240);
f = sampleRate/2*linspace(0,1,NFFT/2+1);


figure()
subplot(3,2,1); 
    plot(time(x_0: x_0 + 239), audio(x_0: x_0 + 239)); 
    xlabel('Time (sec)')
    title('Audio Segment with offset x_0')
subplot(3,2,2);
    %histogram(audio(x_0: x_0 + 239), 240);
    sigFFT = abs(fft(audio(x_0: x_0 + 239)));
    plot(f,2*abs(sigFFT(1:NFFT/2+1)));
    xlabel('Frequency (Hz)')
    title('FFT of Segment with offset x_0')

subplot(3,2,3);
    plot(time(x_1: x_1 + 239), audio(x_1: x_1 + 239));
    xlabel('Time (sec)')
    title('Audio Segment with offset x_1')
subplot(3,2,4)
    %histogram(audio(x_1: x_1 + 239), 240);
    sigFFT = abs(fft(audio(x_1: x_1 + 239)));
    plot(f,2*abs(sigFFT(1:NFFT/2+1))) 
    title('FFT of Segment with offset x_0')
    xlabel('Frequency (Hz)')
subplot(3,2,5)
    plot(time(x_2: x_2 + 239), audio(x_2: x_2 + 239));
    xlabel('Time (sec)')
    title('Audio Segment with offset x_2')
subplot(3,2,6) 
    %histogram(audio(x_2: x_2 + 239), 240);
    sigFFT = abs(fft(audio(x_2: x_2 + 239)));
    plot(f,2*abs(sigFFT(1:NFFT/2+1)))
    xlabel('Frequency (Hz)')
    title('FFT of Segment with offset x_0')
    
