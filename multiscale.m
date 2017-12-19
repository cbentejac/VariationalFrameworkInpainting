function [u_l,phi_l] = multiscale (u0,Mask, size_patch, L, A, tolerance, sigma2)
[m,n,~] = size (u0);
r = (m*n/A)^(1/(L-1));
for l = L-2:-1:0
    M = imresize (Mask, r);
    u_l = imresize (u0, r);
    if (l == L-1)
       u_l =  mean (u0(:)) * (1-M);
    else
        %upsample using NN interpolation  ( PatchMatch function ?)
        phi_l = 
        %and scale by r
        phi_l = imresize (phi_l,r);
        %image update step
        u_l = image_update (phi_l, u_l, Mask, size_patch, sigma2);
    end
    %solve with algo minimization energy
    [u_l,phi_l] = MinimizationOfEnergies (u_l, tolerance, size_patch);
end
end