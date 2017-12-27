% Returns the distance between the patch of image "A" and the patch of 
% target image "B", centered on pixels ("i", "j") in A and ("offset_i", 
% "offset_j") in B, using the similarity metric "error". "lambda" is used
% if the similarity metric used is Poisson. "half_patch" is the size of
% half a patch side, used to extract patches.
function distance = Distance(A, B, i, j, offset_i, offset_j, half_patch, error, lambda)
    patch_A = A(i - half_patch : i + half_patch, j - half_patch : j + half_patch, :);
    patch_B = B(offset_i - half_patch : offset_i + half_patch, offset_j - half_patch : offset_j + half_patch, :);
    
    % Mask to take only the known pixels into accounts (we're getting rid
    % of the virtual pixels in the SSD computation).
    mask_A = (patch_A > -1);
    mask_B = (patch_B > -1);
    mask = mask_A .* mask_B;
    
    % Applying the mask to both of the patches.
    patch_A = patch_A .* mask;
    patch_B = patch_B .* mask;
     
    sigma2 = 0.5;
    if error == 0
        distance = ErrorMedians(patch_A, patch_B, half_patch, sigma2);
    elseif error == 1
        % Poisson with lambda = 1
        distance = ErrorMeans(patch_A, patch_B, half_patch, sigma2);
    else
        distance = ErrorPoisson(patch_A, patch_B, half_patch, lambda, sigma2);
    end
        
end