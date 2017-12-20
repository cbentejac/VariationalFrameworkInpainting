% Given a nearest-neighbour field and the coordinates of a pixel, returns
% the best offsets and best guess so far for those pixels.
function [best_x, best_y, best_guess] = GetBestOffsets(NNF, i, j)
    best_x = NNF(i, j, 1);
    best_y = NNF(i, j, 2);
    best_guess = NNF(i, j, 3);
end