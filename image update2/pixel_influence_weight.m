function weight=pixel_influence_weight(zx,zy,zx_hat,zy_hat,phi,confidence_mask,patch_size,sigma)

half_ps = round((patch_size-1)/2);
g=fspecial('gaussian',2*half_ps+1,sigma);

weight = 0;
for hx=-half_ps:half_ps
for hy=-half_ps:half_ps
    
    centerx = zx - hx;
    centery = zy - hy; %(centerx,centery) is the center of current patch

    nnx = phi(centerx,centery,1);
    nny = phi(centerx,centery,2);
    
    centerhat_x = zx_hat - hx;
    centerhat_y = zy_hat - hy; %(centerhat_x,centerhat_y) is the center of patch.
                               % If this patch has (zx_hat,zy_hat) at the same
                               % relative position as (zx,zy) to
                               % patch(centerx,centery),
                               % than the pair (zx,zy)(zx_hat,zy_hat)
                               % affects the sum of the weight.
    
    if centerhat_x ~= nnx || centerhat_y ~= nny,continue;end %correspond to delta function in eq.(9)
    
    weight = weight+confidence_mask(centerx,centery)*g(hx+half_ps+1,hy+half_ps+1);

end
end


end
