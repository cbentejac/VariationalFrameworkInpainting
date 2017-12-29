clear all
close all
addpath('../.')

% Loads the mask.
mask = imread('../Images/kom07_msk.png');

% Computes the confidence masks for different decay times and a fixed
% asymptotic value (0).
conf_mask_d_20 = ConfidenceMask(mask, 20, 0);
conf_mask_d_50 = ConfidenceMask(mask, 50, 0);
conf_mask_d_100 = ConfidenceMask(mask, 100, 0);

% Displays the computed masks.
subplot(1, 3, 1), imshow(conf_mask_d_20), title('Decay time = 20');
subplot(1, 3, 2), imshow(conf_mask_d_50), title('Decay time = 50');
subplot(1, 3, 3), imshow(conf_mask_d_50), title('Decay time = 100');

% Computes the confidence masks for different asymptotic values and a fixed
% decay time (20).
conf_mask_a_0_1 = ConfidenceMask(mask, 20, 0.1);
conf_mask_a_0_3 = ConfidenceMask(mask, 20, 0.3);
conf_mask_a_0_5 = ConfidenceMask(mask, 20, 0.5);
conf_mask_a_0_8 = ConfidenceMask(mask, 20, 0.8);

% Displays the computed masks.
figure;
subplot(2, 2, 1), imshow(conf_mask_a_0_1), title('Asymptotic = 0.1');
subplot(2, 2, 2), imshow(conf_mask_a_0_3), title('Asymptotic = 0.3');
subplot(2, 2, 3), imshow(conf_mask_a_0_5), title('Asymptotic = 0.5');
subplot(2, 2, 4), imshow(conf_mask_a_0_8), title('Asymptotic = 0.8');