function [u_l,phi_l] = multiscale(u0, Mask, size_patch, L, A, tolerance, sigma2, lambda)

[m,n,channel] = size (u0);
r = (m*n/A)^(1/L);

%% Construct pyramid of inpainting domain(Mask)
kernel_size=0.62*sqrt(r^2-1);
g_sigma = fspecial('gaussian',kernel_size);

pyramid_mask{1}=Mask;
for l=2:L
    imblur=imfilter(pyramid_mask{l-1},g_sigma,'replicate');
    pyramid_mask{l}=imresize(imblur,1/r,'nearest');%when scale parameter<0 , 'nearest' only removes rows and columns,
                                                   %while keeps the values of remaining pixels the same
    pyramid_mask{l}=pyramid_mask{l}>0.4;
end

%% Construct pyramid of images
pyramid_image{1}=u0;
for l=2:L
    imblur=imfilter(pyramid_image{l-1}.*pyramid_mask{l-1},g_sigma,'replicate');
    imblur=imblur./imfilter(pyramid_mask{l-1},g_sigma,'replicate');
    pyramid_image{l}=imresize(imblur,1/r,'nearest'); 
end

%% Upsample and Propagate information downward
for l = L:-1:1
    
    M_l = pyramid_mask{l};
    if (l == L)
       for c=1:channel
           u_l(:,:,c)= pyramid_image{l}(:,:,c).*~M_l+sum(sum(u0(:,:,c).*~Mask))/sum(sum(~Mask)).*M_l; %1->inpainting domain
       end
    else
        %Upsample correspondence phi using NN interpolation and scale by r
        %need to make sure after resizing, every entry of the correspondance
        %map still retains to be a integer, so Nearest Neighbour Interpolation is used(for it ONLY uses
        %the existing values to create new contents)
        phi_l = r*imresize(phi_l,r,'nearest'); 
        
        %Caculate initial condition u_l(u_0^s in the paper) at level l using image update step algorithm 
        %with the newly resized phi_l
        u_hat_l = pyramid_image{l}.*M_l;
        u_l = image_update(phi_l, u_hat_l, M_l, size_patch, sigma2);
    end
    
    %Solve with algorithm minimization energy at current level
    [u_l,phi_l] = MinimizationOfEnergies(u_l, M_l, sigma2, tolerance, lambda, size_patch);
    
end

end
