% Given the current best nearest-neighbour of "A"("i", "j") in "B"(
% "best_x", "best_y") and with a similarity value of "best_guess", check to
% see if the patch that is situated at B("ip", "jp") and being currently
% evaluated would not be a better fit. To do so, compute the similarity
% metric "error" (0, 1 or 2) between the new patch in B and the one in A,
% and check if it is indeed a better fit. If so, returns the appropriate
% offsets and distance. "lambda" is used for Poisson metric.
function [best_x, best_y, best_guess] = ImproveGuess(A, B, i, j, ip, jp, best_guess, best_x, best_y, half_patch, error, lambda)
    distance = Distance(A, B, i, j, ip + half_patch, jp + half_patch, half_patch, error, lambda);
    if distance < best_guess
        best_x = ip;
        best_y = jp;
        best_guess = distance;
    end
end