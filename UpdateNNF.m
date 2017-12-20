function NNF = UpdateNNF(NNF, i, j, x, y, guess)
    NNF(i, j, 1) = x;
    NNF(i, j, 2) = y;
    NNF(i, j, 3) = guess; 
end