clear all
close all
addpath('../.')

% Loads the source image and its mask, and computing the target image.
source = imread('../Images/kom07.png');
mask = imread('../Images/kom07_msk.png');
target = source .* uint8(~mask);

% Computes the NNF for each of the 3 metrics.
disp('Computing parallel NNF for Medians...');
NNF_medians_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 0, 0);
disp('Computing parallel NNF for Means...');
NNF_means_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 1, 0);
disp('Computing parallel NNF for Poisson...');
NNF_poisson_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.5);

% Computes NNF for Poisson metric with different values of lambda.
disp('Computing parallel NNF with Poisson for lambda = 0.01...');
NNF_poisson_1_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.01);
disp('Computing parallel NNF with Poisson for lambda = 0.05...');
NNF_poisson_2_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.05);
disp('Computing parallel NNF with Poisson for lambda = 0.1...');
NNF_poisson_3_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.1);
disp('Computing parallel NNF with Poisson for lambda = 0.3...');
NNF_poisson_4_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.3);
disp('Computing parallel NNF with Poisson for lambda = 0.5...');
NNF_poisson_5_par = NNF_poisson_par;
disp('Computing parallel NNF with Poisson for lambda = 0.8...');
NNF_poisson_6_par = ParallelizedPatchMatch(source, target, mask, 2, 5, 2, 0.8);

% Displays the reconstructions for the 3 metrics (parallel computations).
figure;
subplot(1, 3, 1), imshow(ReconstructionFromNNF(source, target, NNF_medians_par)), title('Median par');
subplot(1, 3, 2), imshow(ReconstructionFromNNF(source, target, NNF_means_par)), title('Mean par');
subplot(1, 3, 3), imshow(ReconstructionFromNNF(source, target, NNF_poisson_par)), title('Poisson par');

% Displays the reconstructions for the different lambda values.
figure;
subplot(2, 3, 1), imshow(ReconstructionFromNNF(source, target, NNF_poisson_1_par)), title('Lambda = 0.01');
subplot(2, 3, 2), imshow(ReconstructionFromNNF(source, target, NNF_poisson_2_par)), title('Lambda = 0.05');
subplot(2, 3, 3), imshow(ReconstructionFromNNF(source, target, NNF_poisson_3_par)), title('Lambda = 0.01');
subplot(2, 3, 4), imshow(ReconstructionFromNNF(source, target, NNF_poisson_4_par)), title('Lambda = 0.3');
subplot(2, 3, 5), imshow(ReconstructionFromNNF(source, target, NNF_poisson_5_par)), title('Lambda = 0.5');
subplot(2, 3, 6), imshow(ReconstructionFromNNF(source, target, NNF_poisson_6_par)), title('Lambda = 0.8');