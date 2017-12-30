% Minimizes the energy to inpaint the image "u_0" at pixels selected by "M".
% The minimization will stop once a convergence criterion defined by
% "tolerance" will be reached. "lambda" is used for similaity metrics,
% "half_patch_size" is the size of half a patch side (used to determine
% nearest-neighbors), and "median", "average" and "poisson" are mutually
% exclusive booleans determining which similarity metric to use. "sigma2"
% is the variance used for the Gaussian's creation in similarity metrics.
function [u, offset_map] = MinimizationOfEnergies(u_0, mask, sigma2, tolerance, lambda, half_patch_size, median, average, poisson)
    cnt = 1;
    u = u_0;
        
    % Determining which error function will be used depending on the user's
    % input.
    if median == 1
        error = 0;
        disp('Median!');
    elseif average == 1
        error = 1;
        disp('Mean!');
    else
        error = 2;
        disp('Poisson!');
    end
    
    % While norm(u_(k+1) - u_k) < tolerance
    %while (norm(u(:) - u_0(:)) > tolerance || cnt == 1)
    while cnt <= 5
        disp(cnt);
        u_0 = u; % Update of u_0 for the tolerance criterium.
        
        % Correspondance update
        if cnt == 1
            offset_map = PatchMatch(u_0, u_0 .* (1 - mask), mask, half_patch_size, 1, error, lambda);%, lambda, M, sigma2, median, average, poisson,1);
        else
            offset_map = PatchMatch(u_0, u_0 .* (1 - mask), mask, half_patch_size, 1, error, lambda, offset_map);
        end
        disp('Passed PatchMatch!');
        
        % Confidence mask (used for image update)
        decay_time = 5;
        asymptotic_value = 5;
        
        confidence_mask = ConfidenceMask(mask, decay_time, asymptotic_value);
        
        % Image update
        tmp_offset = padarray(offset_map, [half_patch_size, half_patch_size], -1);
        tmp_u_hat = padarray(u_0 .* ~mask, [half_patch_size, half_patch_size], -1);
        tmp_mask = padarray(mask, [half_patch_size, half_patch_size], -1);
        u = ImageUpdate(tmp_offset, tmp_u_hat, tmp_mask, half_patch_size, sigma2, lambda, median, average, poisson);
        
%         u = image_update(tmp_u_hat, tmp_offset, tmp_mask, lambda, confidence_mask, half_patch_size, sigma2);
        
        cnt = cnt + 1;
    end
end