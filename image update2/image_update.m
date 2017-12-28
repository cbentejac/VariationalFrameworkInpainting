function uz=image_update(u0,phi,mask,lambda,confidence_mask,patch_size,sigma)
% Consider grayscale image first

% This function is to update image with newly computed correspondence
% <<phi>> according to eq.(19) in the paper.

%   @param mask: 
%         format: Matrix, with all entries either 0 or 1. 1 stands for the
%         pixel within inpainting domain, 0 stands for the known part of
%         image.
          if max(mask) == 255, mask = mask/255; end;
    
% In discrete setting:
% gradx(u(zx,zy)) = u(zx+1,zy) - u(zx,zy)
% grady(u(zx,zy)) = u(zx,zy+1) - u(zx,zy)
% div((v1,v2)) = gradx(v1) + grady(v2)
% So, eq(19) is linear equations of u(zx,zy), 
% where #equations = #unknowns = #pixels in inpainting domain O 

% Note that, for every pixel value u(zx,zy) in O, we need to compute its
% laplacian(related to u(zx+2,zy), u(zx,zy+2)), so, tha actual set involved 
% Oe = {(zx+2,zy),(zx,zy) belongs in O} U {(zx,zy+2),(zx,zy) belongs in O}

%%
u0=double(u0);
[h,w,~]=size(u0);

%% ------------------ Calculate coefficiets of linear equations -------------------
%% Get domains O,Oc,Oe

[O(:,1),O(:,2),~] = find(mask);
[Oc(:,1),Oc(:,2),~] = find(~mask);

nrow = find( ~(O(:,1)>(h-2) | O(:,2)>(w-2)) ); %prevent index from getting out-of-bound when computing 2nd difference 
O = O(nrow,:);

maskOe=zeros(h,w);
for i=1:length(O)
    
    zx=O(i,1);
    zy=O(i,2);

    maskOe(zx,zy)=1;
    maskOe(zx+1,zy)=1; 
    maskOe(zx+2,zy)=1;
    maskOe(zx,zy+1)=1;
    maskOe(zx,zy+2)=1;
    
end
[Oe(:,1),Oe(:,2),~] = find(maskOe);

indexz=getindex(O(:,1),O(:,2),h);
indexz_hat=getindex(Oc(:,1),Oc(:,2),h);
indexz_e=getindex(Oe(:,1),Oe(:,2),h);

%% Compute m(z,z^hat)
m = zeros(h*w,h*w);
for i=1:length(O)
    
    zx = O(i,1);
    zy = O(i,2);
    for j=1:length(Oc)
        
        zx_hat=Oc(j,1);
        zy_hat=Oc(j,2);
        
        m(indexz(i),indexz_hat(j))=pixel_influence_weight(zx,zy,zx_hat,zy_hat,phi,confidence_mask,patch_size,sigma);
     
    end
    
end

%% Compute kz*vz 
gradux = gradx(u0);
graduy = grady(u0);

kv=zeros(h,w,2);
for i=1:length(O)
     
    tmpx=gradux.*~maskOe;
    tmpy=graduy.*~maskOe;
    
    zx = O(i,1);
    zy = O(i,2);
    
    kv(zx,zy,1)=sum(sum(reshape(m(indexz(i),:),h,w).*tmpx));
    kv(zx,zy,2)=sum(sum(reshape(m(indexz(i),:),h,w).*tmpy));

end

%% Compuute kz*fz
kf=zeros(h,w);
for i=1:length(O)

    tmp=u0.*~maskOe;
    
    zx = O(i,1);
    zy = O(i,2);
    
    kf(zx,zy)=sum(sum(reshape(m(indexz(i),:),h,w).*tmp));

end

%% Compute b(coefficient of linear equations)
matb = (1-lambda)*div(kv(:,:,1),kv(:,:,2))-lambda*kf;
matb(~mask) = u0(~mask);
%% Compute kz
kz=zeros(h,w);
for i=1:length(O)
   
    zx = O(i,1);
    zy = O(i,2);
    
    kz(zx,zy)=sum(sum(reshape(m(indexz(i),:),h,w).*~mask));

end
kz=kz(:);

%% Compute A(coefficient of linear equations)
A = zeros(h*w,h*w);
for i=1:length(O)
   
     zx = O(i,1);
     zy = O(i,2);
        
     mark1 = getindex(zx+2,zy,h);
     mark2 = getindex(zx+1,zy,h);
     mark3 = getindex(zx,zy,h); 
     mark4 = getindex(zx,zy+1,h);
     mark5 = getindex(zx,zy+2,h);
    
     A(mark3,mark1) = (1-lambda) * kz(mark2);
     A(mark3,mark2) = -(1-lambda) * (kz(mark2) + kz(mark3));
     A(mark3,mark3) = (2-3*lambda) * kz(mark3);
     A(mark3,mark4) = -(1-lambda) * (kz(mark3) + kz(mark4));
     A(mark3,mark5) = (1-lambda) * kz(mark4);

end

for i=1:length(Oc)

     A(indexz_hat(i),indexz_hat(i)) = 1;

end
    
%% ---------- Solve linear equations using conjugate gradient algorithm -----------
%%
uz=conjgrad(A,matb(:),0.001);

%% ------------------------------ Recover image -------------------------------
%% 
  uz=reshape(uz,h,w);  
end

