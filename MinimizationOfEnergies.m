function [u, offset_map] = MinimizationOfEnergies(u_0, M, sigma2, tolerance, lambda, half_size_patch, median, average, poisson)
    cnt = 1;
    u = u_0;
    u_1 = u_0;
    % While norm(u_(k+1) - u_k) < tolerance
    while (norm(u - u_1) > tolerance || cnt == 1)
        u_1 = u; % Update of u_0 for the tolerance criterium.
        % Correspondance update
        offset_map = ParallelizedPatchMatch (u_1, B, halph_size_patch, lambda, M, sigma2, median, average, poisson,1);        
        % Image update
        u = image_update (offset_map, u_0 .*(1-M),Mask,half_size_patch,sigma2,lambda, median, average, poisson);
    end
end