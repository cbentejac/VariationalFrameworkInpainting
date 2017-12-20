function E = Error_patch_non_local_medians(u, u_hat, size_patch, sigma2)

    [~, ~, c] = size (u);
    g = gaussian (size_patch, sigma2, c);
    tmp = abs((u - u_hat));
    E = sum (sum (sum (g .* tmp)));
    
end