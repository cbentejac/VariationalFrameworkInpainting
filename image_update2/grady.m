function M=grady(I)

%Calcul le gradient en y d'une image I
%Syntaxe: grady(I)

[m,n,c]=size(I);
M=zeros(m,n,c);

M(:,1:end-1,:)=I(:,2:end,:)-I(:,1:end-1,:);


