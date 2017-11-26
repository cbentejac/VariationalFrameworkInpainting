function E = Error_patch_non_local_Poisson (u,u_hat,size_patch,lambda,sigma2)
[m,n,c] = size (u);
g = gaussian (size_patch, sigma2, c);
gradu_x = gradx (u);
gradu_y = grady (u);
gradu_hat_x = gradx (u_hat);
gradu_hat_y = grady (u_hat);
tmp = lambda * ((u - u_hat).^2) + (1 - lambda) * ((gradu_x - gradu_hat_x).^2 + (gradu_y - gradu_hat_y).^2);
E = sum (sum (sum (g.*tmp)));
end