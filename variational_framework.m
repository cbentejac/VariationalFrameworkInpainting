function [offset_map, I_final] = variational_framework (I_init, Mask, lambda, size_patch, nb_level, median, average, poisson)
    I = im2double (I_init);
    M = im2double (Mask);
    half_patch_size = (size_patch - 1)/2;
    I = bord (I, half_patch_size);
    M = bord (M, half_patch_size);
    sigma2 = 0.5;
    tolerance = 0.01;
    %A = ;
    decay_time
    asymptotic_value
    if nb_level == 1
        [I_final, offset_map] = MinimizationOfEnergies (I, M, sigma2, tolerance, lambda, half_size_patch, median, average, poisson);
    end
    % else %nblevel > 1
    %     %appelermultiscale
end