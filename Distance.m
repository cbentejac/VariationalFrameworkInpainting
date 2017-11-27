% Returns the distance between the patch of image A and the patch of target
% image B, using the SSD.
function distance = Distance(A, B, i, j, offset_i, offset_j, half_patch)
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
    
%     distance = immse(patch_A, patch_B) * numel(patch_A);   
    distance = Error_patch_non_local_Poisson(patch_A, patch_B, size(patch_A, 1), 0.5, 0.5);
end