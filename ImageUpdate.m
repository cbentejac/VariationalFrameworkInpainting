% Updates the image "u_hat" with mask (region to inpaint) "Mask" using the
% lastly updated offset map "phi". "half_patch_size" is the size of half a
% patch side in the image, "sigma2" is the variance used for the Gaussian
% generation in similarity metrics, "lambda" is used for Poisson metric,
% and "median", "average" and "poisson" are mutually exclusive booleans
% used to determine which metric is to be used.
function u = ImageUpdate(phi, u_hat, mask, half_patch_size, sigma2, lambda, median, average, poisson)
    [m1, n, c] = size(u_hat);
    m = zeros(m1, n);
    mask = repmat(mask, [1, 1, 3]);
    
    % Computation of weights m_zzhat: we need them for each method
    % (poisson, median, mean).
    for x = 1 + half_patch_size : m1 - half_patch_size
        for y = 1 + half_patch_size : n - half_patch_size
            X = mask(x - half_patch_size : x + half_patch_size, y - half_patch_size : y + half_patch_size, :);
            tmp = phi(x - half_patch_size : x + half_patch_size, y - half_patch_size : y + half_patch_size, :);
            delta = tmp(:, :, 3);
            delta = repmat(delta, [1, 1, 3]);
            g = gaussian(half_patch_size, sigma2, c);
            m(x,y) = sum(sum(sum(g .* delta .* X)));
        end
    end
    
    if (poisson == 1 || average == 1)
        m = repmat(m, [1, 1, 3]);
        F = zeros(size(m));
        K = zeros(size(m));
        Vx = zeros(size(m));
        Vy = zeros(size(m));
        
        % Computation i=of vz, fz and kz for each z in the image.
        for x = 1 + half_patch_size : m1 - half_patch_size
            for y = 1 + half_patch_size : n-half_patch_size
                tmp_m = m(x - half_patch_size : x + half_patch_size, y - half_patch_size : y + half_patch_size, :);
                tmp_u = u_hat(x - half_patch_size : x + half_patch_size, y - half_patch_size : y + half_patch_size, :);
                K(x, y, :) = sum(sum(tmp_m));
                F(x, y, :) = (1 / K(x, y, :)) .* sum(sum(tmp_m .* tmp_u));
                Vx(x, y, :) = (1 / K(x, y, :)) .* sum(sum(tmp_m .* gradx(tmp_u)));
                Vy(x, y, :) = (1 / K(x, y, :)) .* sum(sum(tmp_m .* grady(tmp_u)));
            end
        end
        % Solve the linear equation with conjugate gradient algorithm.
        u = gradient_conjugue(u_hat, 0.1, lambda, K, F, Vx, Vy, 100);
        u(mask == 0) = u_hat(mask == 0);
    end
    
    if (median == 1)
        u = zeros(size(u_hat));
        for i = 1 + half_patch_size : m1 - half_patch_size
            for j = 1 + half_patch_size : n - half_patch_size
                %sort the value of the patch
                p = u_hat(i - half_patch_size : i + half_patch_size, j - half_patch_size : j + half_patch_size, :);
                p = sum(p, 3);
                [p_sorted, index] = sort(p(:));
                weight = m(i - half_patch_size : i + half_patch_size, j - half_patch_size : j + half_patch_size, :);
                total_weight = sum(weight(:));
                sum1 = 0;
                cnt = 1;
                tmp = index(cnt);
                %we choose the value of u_zzhat such that sum(weight) = total_weight/2
                while sum1 < total_weight / 2
                    sum1 = sum1 + weight(tmp);
                    tmp = index(cnt+1);
                    cnt = cnt + 1;
                end
                u(i, j, :) = p_sorted(index(cnt));                
            end
        end
    end
    
    % Cropping the image (removing the virtual borders) to get it back to
    % its normal size.
    u = u(1 + half_patch_size : m1 - half_patch_size, 1 + half_patch_size : n - half_patch_size, :);
end
