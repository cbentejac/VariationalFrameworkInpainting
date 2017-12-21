function [offset_map, I_final] = variational_framework (I_init, Mask, lambda, size_patch, nb_level, median, average, poisson)
    I = im2double (I_init);
    M = im2double (Mask);
    half_patch_size = (size_patch - 1)/2;
    I = bord (I, half_patch_size);
    M = bord (M, half_patch_size);
    sigma2 = 0.5;
    tolerance = 0.01;
    A = 0.15;
    decay_time = 0;
    asymptotic_value = 0;
    if nb_level == 1
        [I_final, offset_map] = MinimizationOfEnergies (I, M, sigma2, tolerance, lambda, half_patch_size, median, average, poisson);    
    else %nblevel > 1
        [I_final,offset_map] = multiscale(u0, M, size_patch, L, A, tolerance, sigma2, lambda, median, average, poisson);
    end
end