% Given a nearest-neighbor field "NNF", a pixel position ("i", "j"), an
% offset position ("x", "y") and a similarity "guess", updates the value of
% the entry (i, j) of the NNF with (x, y, guess).
function NNF = UpdateNNF(NNF, i, j, x, y, guess)
    NNF(i, j, 1) = x;
    NNF(i, j, 2) = y;
    NNF(i, j, 3) = guess; 
end