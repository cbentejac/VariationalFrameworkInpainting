clear all
close all
addpath('../.')

% Loads the source image and its mask, and computing the target image.
source = imread('../Images/kom07.png');
mask = imread('../Images/kom07_msk.png');
target = source .* uint8(~mask);

% Padding the target and making sure it is casted into double.
u_hat = padarray(target, [2 2], -1);
u_hat = im2double(u_hat);
tmp_mask = padarray(mask, [2 2], -1);

% Computes the NNF for each of the 3 metrics.
disp('Computing NNF for Medians...');
NNF_medians = ParallelizedPatchMatch(source, target, mask, 2, 5, 0, 0);
disp('Computing NNF for Means...');
NNF_means = ParallelizedPatchMatch(source, target, mask, 2, 5, 1, 0);
disp('Computing NNF for Poisson...');
NNF_poisson = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.5);

tic;
% Computing the image update part for the 3 NNFs.
disp('Updating for Medians...');
tmp_medians = padarray(NNF_medians, [2 2], -1);
u_medians = ImageUpdate(tmp_medians, u_hat, tmp_mask, 2, 0.5, 0, 0);

disp('Updating for Means...');
tmp_means = padarray(NNF_means, [2 2], -1);
u_means = ImageUpdate(tmp_means, u_hat, tmp_mask, 2, 0.5, 1, 2);
%% 
disp('Updating for Poisson...');
tmp_poisson = padarray(NNF_poisson, [2 2], -1);
u_poisson = ImageUpdate(tmp_poisson, u_hat, tmp_mask, 2, 0.5, 0.01, 2);

toc;

% Displaying the updated images.
subplot(1, 3, 1), imshow(u_medians), title('Medians');
subplot(1, 3, 2), imshow(u_means), title('Means');
subplot(1, 3, 3), imshow(u_poisson), title('Poisson');