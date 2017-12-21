function y = norm2 (A)
tmp = A.^2;
y = sum(tmp(:));
end