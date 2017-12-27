% Computes the similarity between two patches "u" and "u_hat", of half size
% "size_patch", using the medians metric. "sigma2" is the variance used for
% a Gaussian generation.
function E = ErrorMedians(u, u_hat, size_patch, sigma2)
    [~, ~, c] = size(u);
    g = gaussian(size_patch, sigma2, c);
    tmp = abs((u - u_hat));
    E = sum(sum(sum(g .* tmp)));    
end