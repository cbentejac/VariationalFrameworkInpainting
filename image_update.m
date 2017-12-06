function u = image_update (phi,u_hat,Mask,size_patch,sigma2)
[m1,n,c] = size (u_hat);
m = zeros(m1,n);
Mask = repmat (Mask,[1,1,3]);
for x=1+size_patch:m1-size_patch
    for y=1+size_patch:n-size_patch
        X = Mask(x-size_patch:x+size_patch,y-size_patch:y+size_patch,:);
        delta = phi (x-size_patch:x+size_patch,y-size_patch:y+size_patch,:);
        g = gaussian (size_patch, sigma2);
        m(x,y) = sum (sum (sum (g.*delta.*X)));
    end
end
m = repmat (m,[1,1,3]);
kz = sum(m(:));
fz = (1/kz) * sum (sum (m.*u_hat));
vz = (1/kz) * sum(sum(m.*(gradx(u_hat)+grady(u_hat))));
u = gradient_conjugue (u_hat, epsilon, lambda, kz, fz, vz, nb_iter);
u(Mask==0) = u_hat;
end