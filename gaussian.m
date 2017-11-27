%function y = gaussian (x, sigma2)
%y = exp (-sum(sum(x.^2))/(2*sigma2)); 
function gaussian_mask = gaussian (size_window, sigma, c)
    I = diag (-size_window : size_window) * ones (2 * size_window + 1, 2 * size_window + 1);
    J = ones (2 * size_window + 1, 2 * size_window + 1) * diag (-size_window : size_window);
    gaussian_mask = exp ( -(I.^2 + J.^2) ./ (2 * sigma^2));
    if (c == 3)  
        gaussian_mask(:,:,2) = exp ( -(I.^2 + J.^2) ./ (2 * sigma^2));
        gaussian_mask(:,:,3) = exp ( -(I.^2 + J.^2) ./ (2 * sigma^2));
    end
end