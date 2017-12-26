function u = image_update (phi, u_hat, Mask, half_patch_size, sigma2, lambda, median, average, poisson)

    [m1, n, c] = size(u_hat);
    m = zeros(m1,n);
    Mask = repmat (Mask,[1,1,3]);
    for x = 1 + half_patch_size : m1 - half_patch_size
            for y = 1 + half_patch_size : n - half_patch_size
                X = Mask(x - half_patch_size : x + half_patch_size, y - half_patch_size : y + half_patch_size, :);
                tmp = phi (x-half_patch_size:x+half_patch_size,y-half_patch_size:y+half_patch_size,:);
                delta = tmp(:,:,3);
                delta = repmat (delta, [1,1,3]);
                g = gaussian (half_patch_size, sigma2,c);
                m(x,y) = sum (sum (sum (g.*delta.*X)));
                %tmp2 = sum(delta,3);
                %m(x,y) = sum(tmp2(:));
            end
        end
    if (poisson == 1 || average == 1)
        m = repmat (m,[1,1,3]);
        F = zeros (size (m));
        K = zeros (size (m));
        Vx = zeros (size (m));
        Vy = zeros (size (m));
        for x=1+half_patch_size:m1-half_patch_size
            for y=1+half_patch_size:n-half_patch_size
                tmp_m = m(x-half_patch_size:x+half_patch_size,y-half_patch_size:y+half_patch_size,:);
                tmp_u = u_hat(x-half_patch_size:x+half_patch_size,y-half_patch_size:y+half_patch_size,:);
                K(x,y,:) = sum(sum(tmp_m));
                F(x,y,:) = (1/K(x,y,:)).* sum(sum(tmp_m.*tmp_u));
                Vx(x,y,:) = (1/K(x,y,:)).* sum(sum(tmp_m.*gradx(tmp_u)));
                Vy(x,y,:) = (1/K(x,y,:)).* sum(sum(tmp_m.*grady(tmp_u)));
            end
        end
        u = gradient_conjugue (u_hat, 0.1, lambda, K, F, Vx, Vy, 100);
        u(Mask==0) = u_hat(Mask==0);
    end
    if (median == 1)
        u = zeros(size(u_hat));
        for i=1+half_patch_size:m1-half_patch_size
            for j=1+half_patch_size:n-half_patch_size
                p = u_hat(i-half_patch_size:i+half_patch_size,j-half_patch_size:j+half_patch_size,:);
                p = sum(p,3);
                [p_sorted,index] = sort(p(:));
                weight = m(i-half_patch_size:i+half_patch_size,j-half_patch_size:j+half_patch_size,:);
                total_weight = sum(weight(:));
                sum1 = 0;
                cnt = 1;
                tmp = index(cnt);
                while sum1 < total_weight / 2
                    sum1 = sum1 + weight(tmp);
                    tmp = index (cnt+1);
                    cnt = cnt+1;
                end
                u(i,j,:) = p_sorted(index(cnt));                
            end
        end
    end
    
    % Cropping the image (removing the virtual borders) to get it back to
    % its normal size.
    u = u(1 + half_patch_size : m1 - half_patch_size, 1 + half_patch_size : n - half_patch_size, :);
end
