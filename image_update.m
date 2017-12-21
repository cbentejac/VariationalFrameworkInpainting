function u = image_update (phi,u_hat,Mask,half_size_patch,sigma2, lambda, median, average, poisson)
    [m1,n,~] = size (u_hat);
    m = zeros(m1,n);
    Mask = repmat (Mask,[1,1,3]);
    if (poisson == 1 || average == 1)
        for x=1+half_size_patch:m1-half_size_patch
            for y=1+half_size_patch:n-half_size_patch
                X = Mask(x-half_size_patch:x+half_size_patch,y-half_size_patch:y+half_size_patch,:);
                tmp = phi (x-half_size_patch:x+half_size_patch,y-half_size_patch:y+half_size_patch,:);
                delta = tmp(:,:,3);
                delta = repmat (delta, [1,1,3]);
                g = gaussian (half_size_patch, sigma2);
                m(x,y) = sum (sum (sum (g.*delta.*X)));
                %tmp2 = sum(delta,3);
                %m(x,y) = sum(tmp2(:));
            end
        end
        m = repmat (m,[1,1,3]);
        kz = sum(m(:));
        fz = (1/kz) * sum (sum (m.*u_hat));
        vz = (1/kz) * sum(sum(m.*(gradx(u_hat)+grady(u_hat))));
        u = gradient_conjugue (u_hat, epsilon, lambda, kz, fz, vz, 100);
        u(Mask==0) = u_hat;
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