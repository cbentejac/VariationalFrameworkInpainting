% Given an image "I_init", a region in this image to inpaint "Mask", the
% size of a patch "size_patch" in the image and the number of levels
% "nb_level" to use in the multi-scale scheme, proceeds to inpaint the
% image and returns it, as well as its corresponding offset map. "median",
% "average" and "poisson" are mutually exclusive booleans used to determine
% which similarity metric to use, and "lambda" is used for Poisson metric.
function [offset_map, I_final] = VariationalFramework(I_init, Mask, size_patch, nb_level, lambda, median, average, poisson)
    I = im2double(I_init);
    M = im2double(Mask);
    half_patch_size = (size_patch - 1) / 2;
%     I = bord(I, half_patch_size);
%     M = bord(M, half_patch_size);
    
    sigma2 = 0.5;
    tolerance = 0.01;
    A = 0.15;
    decay_time = 0;
    asymptotic_value = 0;
    
    if nb_level == 1
        [I_final, offset_map] = MinimizationOfEnergies(I, M, sigma2, tolerance, lambda, half_patch_size, median, average, poisson);    
    else %nblevel > 1
        % Might need to re-add the borders for I and M here
        % since i haven't dived into the multiscale implementation yet
        [I_final, offset_map] = multiscale(I, M, size_patch, L, A, tolerance, sigma2, lambda, median, average, poisson);
    end
%     I_final = I_final(1 + half_patch_size : m - half_patch_size, 1 + half_patch_size : n - half_patch_size, :);
end
