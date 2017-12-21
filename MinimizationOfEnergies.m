function [u, offset_map] = MinimizationOfEnergies(u_0, M, sigma2, tolerance, lambda, half_size_patch, median, average, poisson)
    cnt = 1;
    u = u_0;
    u_1 = u_0;
    % While norm(u_(k+1) - u_k) < tolerance
    %while (norm(u(:) - u_1(:)) > tolerance || cnt == 1)
    while cnt <= 10
        disp(cnt);
        u_1 = u; % Update of u_0 for the tolerance criterium.
        % Correspondance update
        if cnt == 1
            offset_map = NewPatchMatch (u_1, u_1 .* (1 - M), M, half_size_patch, 1);%, lambda, M, sigma2, median, average, poisson,1);
        else
            offset_map = NewPatchMatch (u_1, u_1 .* (1 - M), M, half_size_patch, 1, offset_map);
        end
        disp('Passed PatchMatch!');
        % Image update
        u = image_update (offset_map, u_0 .*(1-M),M,half_size_patch,sigma2,lambda, median, average, poisson);
        cnt = cnt + 1;
    end
end