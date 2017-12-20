function B = bord(A,d)
    [m,n,c] = size(A);
    M = m+2*d;
    N = n+2*d;
    B = -1 * ones (m+2*d,n+2*d,c);
    B(d+1:M-d,d+1:N-d,:) = A;
end