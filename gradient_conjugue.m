function uz = gradient_conjugue (u0, epsilon, lambda, kz, fz, vz, nb_iter)
uz = u0;
r = (1-lambda) * div (gradx(kz.*vz),grady(kz.*vz))-lambda*kz.*fz;
p = r;
for i=1:nb_iter
   Ap = (1-lambda) * div (gradx(kz.*gradx(uz)),grady(kz.*grady(uz)))-lambda*kz.*uz;
   alpha = (r'*r)/(p'*Ap);
   uz = uz + alpha*p;
   r1 = r - alpha*Ap*p;
   if (norm(rk) < epsilon)
       break;
   end
   beta = (r1'*r1)/(r'*r);
   p = r1 + beta*p;
end
end