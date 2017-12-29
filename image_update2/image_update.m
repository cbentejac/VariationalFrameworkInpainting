function uz=image_update(u0,phi,mask,lambda,confidence_mask,patch_size,sigma,epsilon)
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
% where #equations = #unknowns = #pixels 

%%
u0=double(u0);
[h,w]=size(u0);

%% ------------------ Calculate coefficiets of linear equations -------------------
%% Get domains O,Oc
[O(:,1),O(:,2),~] = find(mask);
[Oc(:,1),Oc(:,2),~] = find(~mask);

nrow = find( ~(O(:,1)>(h-2) | O(:,2)>(w-2)) ); %prevent index from getting out-of-bound when computing 2nd difference 
O = O(nrow,:);

indexz=getindex(O(:,1),O(:,2),h);

%% Compute kz, kz*vz, kz*fz
gradux = gradx(u0);
graduy = grady(u0);

kz=zeros(h,w);
kv=zeros(h,w,2);
kf=zeros(h,w);

m_z=zeros(h,w);
for i=1:length(O)
    
    zx = O(i,1);
    zy = O(i,2);
    
    for j=1:length(Oc)
        
        zx_hat=Oc(j,1);
        zy_hat=Oc(j,2);
        
        m_z(zx_hat,zy_hat)=pixel_influence_weight(zx,zy,zx_hat,zy_hat,phi,confidence_mask,patch_size,sigma);
        
    end
    
    tmpx=gradux.*~mask;
    tmpy=graduy.*~mask; 
    disp(size(m_z));
    disp(size(tmpx));
    kv(zx,zy,1)=sum(sum(m_z.*tmpx));
    kv(zx,zy,2)=sum(sum(m_z.*tmpy));
    
    tmp=u0.*~mask;
    kf(zx,zy)=sum(sum(m_z.*tmp));    
    
    kz(zx,zy)=sum(sum(m_z.*~mask));

end

%% Compute b(coefficient of linear equations)
matb = -(1-lambda)*div(kv(:,:,1),kv(:,:,2))+lambda*kf-lambda*kz.*u0 + (1-lambda)*div(gradux,graduy);
matb(~mask) = 0;

%% ---------- Solve linear equations using conjugate gradient algorithm -----------
%%
uz = u0.*~mask;

% initializations
% r = b - A.x ; nr = |r| ; p = r
r = matb + (1-lambda)*div(kz.*gradx(uz),kz.*grady(uz)) - lambda*kz.*uz;
r = r.*mask;
nr = norm(r(indexz),2);
p = r;

% iteration
nr_old = nr;
nb_iter = 0;
stop = (nr < epsilon)||(nb_iter >= 1e6);

while ~stop
    
    %alpha = r'.r / p'.A.p
    Ap = -(1-lambda)*div(kz.*gradx(p),kz.*grady(p)) + lambda*kz.*p;    
    alpha = nr^2/ sum(sum(p.* Ap));
    
    % x = x + alpha*p
    uz = uz + alpha * p;
    
    % r = b - A.x ; nr = |r|
    r =  matb + (1-lambda)*div(kz.*gradx(uz),kz.*grady(uz)) - lambda*kz.*uz;    
    nr = norm(r(indexz),2);
    
    % beta = nr^2/nr_old^2 ; p = r + beta*p
    beta = nr^2/nr_old^2;
    p = r + beta*p;
    
    nr_old = nr;
    nb_iter = nb_iter + 1;
    stop = (nr < epsilon)||(nb_iter >= 1e6);
    
    if mod(nb_iter,5000) ==0,disp(nr); end

    
end

uz = max(u0(:))*(uz-min(uz(:)))/range(uz(:));
uz(~mask)=u0(~mask);

end
