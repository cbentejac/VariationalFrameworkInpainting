% Given the current best nearest-neighbour, check to see if the patch that
% is currently being evaluated would not be a better fit. To do so, compute
% the SSD between the new patch in B and the one in A, and check if it is
% indeed a better fit. If so, returns the appropriate offsets and distance.
function [best_x, best_y, best_guess] = ImproveGuess(A, B, i, j, ip, jp, best_guess, best_x, best_y, half_patch)
    distance = Distance(A, B, i, j, ip + half_patch, jp + half_patch, half_patch);
    if distance < best_guess
        best_x = ip;
        best_y = jp;
        best_guess = distance;
    end
end