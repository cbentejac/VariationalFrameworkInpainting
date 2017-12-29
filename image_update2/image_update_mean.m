function uz=image_update_mean(u0,phi,mask,confidence_mask,patch_size,sigma)

u0=double(u0);
[h,w]=size(u0);

%% ------------------ Calculate coefficiets of linear equations -------------------
%% Get domains O,Oc
[O(:,1),O(:,2),~] = find(mask);
[Oc(:,1),Oc(:,2),~] = find(~mask);

nrow = find( ~(O(:,1)>(h-2) | O(:,2)>(w-2)) ); %prevent index from getting out-of-bound when computing 2nd difference 
O = O(nrow,:);

%% Compute kz, kz*fz
kz=zeros(h,w);
kf=zeros(h,w);

m_z=zeros(h,w);
for i=1:length(O)  
    disp(i/length(O)) %percentage of work done
    
    zx = O(i,1);
    zy = O(i,2);
    
    for j=1:length(Oc)
        
        zx_hat=Oc(j,1);
        zy_hat=Oc(j,2);
        
        m_z(zx_hat,zy_hat)=pixel_influence_weight(zx,zy,zx_hat,zy_hat,phi,confidence_mask,patch_size,sigma);
        
    end
    
    tmp=u0.*~mask;
    kf(zx,zy)=sum(sum(m_z.*tmp));    
    
    kz(zx,zy)=sum(sum(m_z.*~mask));

end

%% ------------------------------- Recover image -------------------------------
uz = kf./kz;
uz(~mask) = u0(~mask);

end

