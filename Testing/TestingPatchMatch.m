clear all
close all
addpath('../.')

% Loads the source image and its mask, and computing the target image.
source = imread('../Images/kom07.png');
mask = imread('../Images/kom07_msk.png');
target = source .* uint8(~mask);

% Computes the NNF for each of the 3 metrics.
disp('Computing NNF for Medians...');
NNF_medians = PatchMatch(source, target, mask, 2, 5, 0, 0);
disp('Computing NNF for Means...');
NNF_means = PatchMatch(source, target, mask, 2, 5, 1, 0);
disp('Computing NNF for Poisson...');
NNF_poisson = PatchMatch(source, target, mask, 2, 5, 2, 0.5);

% Displays the reconstructions for the 3 metrics.
subplot(1, 3, 1), imshow(ReconstructionFromNNF(source, target, NNF_medians)), title('Median');
subplot(1, 3, 2), imshow(ReconstructionFromNNF(source, target, NNF_means)), title('Mean');
subplot(1, 3, 3), imshow(ReconstructionFromNNF(source, target, NNF_poisson)), title('Poisson');

% Computes NNF for Poisson metric with different values of lambda.
disp('Computing NNF with Poisson for lambda = 0.01...');
NNF_poisson_1 = PatchMatch(source, target, mask, 2, 5, 2, 0.01);
disp('Computing NNF with Poisson for lambda = 0.05...');
NNF_poisson_2 = PatchMatch(source, target, mask, 2, 5, 2, 0.05);
disp('Computing NNF with Poisson for lambda = 0.1...');
NNF_poisson_3 = PatchMatch(source, target, mask, 2, 5, 2, 0.1);
disp('Computing NNF with Poisson for lambda = 0.3...');
NNF_poisson_4 = PatchMatch(source, target, mask, 2, 5, 2, 0.3);
disp('Computing NNF with Poisson for lambda = 0.5...');
NNF_poisson_5 = NNF_poisson;
disp('Computing NNF with Poisson for lambda = 0.8...');
NNF_poisson_6 = PatchMatch(source, target, mask, 2, 5, 2, 0.8);

% Displays the reconstructions for the different lambda values.
figure;
subplot(2, 3, 1), imshow(ReconstructionFromNNF(source, target, NNF_poisson_1)), title('Lambda = 0.01');
subplot(2, 3, 2), imshow(ReconstructionFromNNF(source, target, NNF_poisson_2)), title('Lambda = 0.05');
subplot(2, 3, 3), imshow(ReconstructionFromNNF(source, target, NNF_poisson_3)), title('Lambda = 0.01');
subplot(2, 3, 4), imshow(ReconstructionFromNNF(source, target, NNF_poisson_4)), title('Lambda = 0.3');
subplot(2, 3, 5), imshow(ReconstructionFromNNF(source, target, NNF_poisson_5)), title('Lambda = 0.5');
subplot(2, 3, 6), imshow(ReconstructionFromNNF(source, target, NNF_poisson_6)), title('Lambda = 0.8');