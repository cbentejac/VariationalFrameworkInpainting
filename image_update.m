function u = image_update (phi,u_hat,Mask,half_size_patch,sigma2, lambda, median, average, poisson)
    [m1,n,c] = size (u_hat);
    m = zeros(m1,n);
    Mask = repmat (Mask,[1,1,3]);
    if (poisson == 1 || average == 1)
        for x=1+half_size_patch:m1-half_size_patch
            for y=1+half_size_patch:n-half_size_patch
                X = Mask(x-half_size_patch:x+half_size_patch,y-half_size_patch:y+half_size_patch,:);
                tmp = phi (x-half_size_patch:x+half_size_patch,y-half_size_patch:y+half_size_patch,:);
                delta = tmp(:,:,3);
                delta = repmat (delta, [1,1,3]);
                g = gaussian (half_size_patch, sigma2,c);
                m(x,y) = sum (sum (sum (g.*delta.*X)));
                %tmp2 = sum(delta,3);
                %m(x,y) = sum(tmp2(:));
            end
        end
        m = repmat (m,[1,1,3]);
        F = zeros (size (m));
        K = zeros (size (m));
        Vx = zeros (size (m));
        Vy = zeros (size (m));
        for x=1+half_size_patch:m1-half_size_patch
            for y=1+half_size_patch:n-half_size_patch
                tmp_m = m(x-half_size_patch:x+half_size_patch,y-half_size_patch:y+half_size_patch,:);
                tmp_u = u_hat(x-half_size_patch:x+half_size_patch,y-half_size_patch:y+half_size_patch,:);
                K(x,y,:) = sum(sum(tmp_m));
                F(x,y,:) = (1/K(x,y,:)).* sum(sum(tmp_m.*tmp_u));
                Vx(x,y,:) = (1/K(x,y,:)).* sum(sum(tmp_m.*gradx(tmp_u)));
                Vy(x,y,:) = (1/K(x,y,:)).* sum(sum(tmp_m.*grady(tmp_u)));
            end
        end
        %kz = sum(m(:));
        %fz = (1/kz) * sum(sum (sum (m.*u_hat)));
        %vz = (1/kz) * sum(sum(sum(m.*(gradx(u_hat)+grady(u_hat)))));
        u = gradient_conjugue (u_hat, 0.1, lambda, K, F, Vx, Vy, 100);
        u(Mask==0) = u_hat(Mask==0);
    end
    if (median == 1)
        u = zeros(size(u_hat));
        for i=1+half_size_patch:m1-half_size_patch
            for j=1+half_size_patch:n-half_size_patch
                p = u_hat(i-half_size_patch:i+half_size_patch,j-half_size_patch:j+half_size_patch,:);
                p = sum(p,3);
                [p_sorted,index] = sort(p(:));
                %weight = ;
                total_weight = sum(weight(:));
                sum1 = 0;
                cnt = 1;
                tmp = index(cnt);
                while sum1 < total_weight/2
                    sum1 = sum1 + weight(tmp);
                    tmp = index (cnt+1);
                    cnt = cnt+1;
                end
                u(i,j,:) = p_sorted(index(cnt));                
            end
        end
    end
end