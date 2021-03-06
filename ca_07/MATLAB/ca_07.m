%% Computer Assignment 07 
% 1. Generate a large number of random vectors of dimension 2 consisting of
% two independent uniformly distributed random numbers over the range
% [0,1]. Estimate the pdf and plot in 3D using MATLAB’s functions like
% surf, mesh or the equivalent. Describe the shape of this plot. 
% 2. Generate a set of Gaussian random vectors that have a 2x2 covariance
% matrix, estimate the pdf, and plot in 3D. To keep things simple, use a
% mean of [6,6] for each example. Use the following covariance matrices:

%% Task 1 
DIM = [10, 10]; 
x = rand(DIM); 

hist_x = mvnpdf(x, 0.5)
waterfall(x)
