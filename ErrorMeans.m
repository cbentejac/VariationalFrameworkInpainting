% Computes the similarity between two patches "u" and "u_hat", of half size
% "size_patch", using the Means metric. "sigma2" is the variance used for
% a Gaussian generation. Using the means metric is like using Poisson with
% lambda set to 1.
function E = ErrorMeans(u, u_hat, size_patch, sigma2)
    E = ErrorPoisson(u, u_hat, size_patch, 1, sigma2);
end