function uz = gradient_conjugue (u0, epsilon, lambda, kz, fz, vx,vy, nb_iter)
uz = u0;
r = (1-lambda) * div (gradx(kz.*vx),grady(kz.*vy))-lambda*kz.*fz;
p = r;
for i=1:nb_iter
   Ap = (1-lambda) * div (gradx(kz.*gradx(uz)),grady(kz.*grady(uz)))-lambda*kz.*uz;
   r_t = r;
   r_t(:,:,1) = r(:,:,1)';
   r_t(:,:,2) = r(:,:,2)';
   r_t(:,:,3) = r(:,:,3)';
   p_t = p;
   p_t(:,:,1) = p(:,:,1)';
   p_t(:,:,2) = p(:,:,2)';
   p_t(:,:,3) = p(:,:,3)';
   alpha = (r_t*r)/(p_t*Ap);
   uz = uz + alpha*p;
   r1 = r - alpha*Ap;
   if (norm(rk) < epsilon)
       break;
   end
   r1_t = r1;
   r1_t(:,:,1) = r1(:,:,1)';
   r1_t(:,:,2) = r1(:,:,2)';
   r1_t(:,:,3) = r1(:,:,3)';
   beta = (r1_t*r1)/(r_t*r);
   p = r1 + beta*p;
end
end