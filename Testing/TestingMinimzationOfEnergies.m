clear all
close all
addpath('../.')

% Loads the source image and its mask, and computing the target image.
source = imread('../Images/kom07.png');
mask = imread('../Images/kom07_msk.png');
target = source .* uint8(~mask);

% Calls the variational framework.
[offset_medians image_medians] = VariationalFramework(source, mask, 5, 1, 0, 1, 0, 0);
[offset_means image_means] = VariationalFramework(source, mask, 5, 1, 0, 0, 1, 0);
[offset_poisson image_poisson] = VariationalFramework(source, mask, 5, 1, 0.5, 0, 0, 1);

% Displays results.
subplot(3, 2, 1), imshow(image_medians), title('Medians output');
subplot(3, 2, 2), imshow(ReconstructionFromNNF(source, target, offset_medians)), title('Medians NNF');
subplot(3, 2, 3), imshow(image_means), title('Means output');
subplot(3, 2, 4), imshow(ReconstructionFromNNF(source, target, offset_means)), title('Means NNF');
subplot(3, 2, 5), imshow(image_poisson), title('Poisson output');
subplot(3, 2, 6), imshow(ReconstructionFromNNF(source, target, offset_poisson)), title('Poisson NNF');