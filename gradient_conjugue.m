function uz = gradient_conjugue (u0, epsilon, lambda, kz, fz, vx,vy, nb_iter)
uz = u0;
r = (1-lambda) * div (gradx(kz.*vx),grady(kz.*vy))-lambda*kz.*fz;
p = r;
for i=1:nb_iter
   Ap = (1-lambda) * div (gradx(kz.*gradx(uz)),grady(kz.*grady(uz)))-lambda*kz.*uz;
   r_t = permute (r,[2,1,3]);
   p_t = permute (p,[2,1,3]);
   %tmp(:,:,1) = p_t(:,:,1) * Ap(:,:,1);
   %tmp(:,:,2) = p_t(:,:,2) * Ap(:,:,2);
   %tmp(:,:,3) = p_t(:,:,3) * Ap(:,:,3);
   alpha = (r_t.*r)./(p_t.*Ap);
   uz = uz + alpha.*p;
   r1 = r - alpha.*Ap;
   if (norm(rk) < epsilon)
       break;
   end
   r1_t = permute (r1,[2,1,3]);
   beta = (r1_t.*r1)./(r_t.*r);
   p = r1 + beta*p;
end
end