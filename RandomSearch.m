% Assuming the propagation phase has been done, process with the random
% search to improve the current best offsets. To do so, select pixels
% randomly within a decreasing window and see if they are a better fit or
% not.
function [best_x, best_y, best_guess] = RandomSearch(pad_A, pad_B, i, j, best_x, best_y, best_guess, A, half_patch)
    % Initializing the beginning of random search (max
    % iterations).
    [m, n, ~] = size(A);
    rs_start = intmax;
    if rs_start > max(m + half_patch, n + half_patch)
        rs_start = max(m + half_patch, n + half_patch);
    end

    % Hardcoded value of RAND_MAX in C++ (plays the role of an
    % arbitrary value used to generate a random integer).
    rand_max = 32767; 
    while rs_start >= 1
        x_min = max(best_x - rs_start, 1);
        x_max = min(best_x + rs_start, m);
        y_min = max(best_y - rs_start, 1);
        y_max = min(best_y + rs_start, n);
        
        % Generating the random candidates.
        xp = mod(x_min + randi(rand_max), abs(x_max - x_min));
        yp = mod(y_min + randi(rand_max), abs(y_max - y_min));

        % Handling the case where the modulo is 0 or superior
        % to the image's size.
        size_B_x = size(pad_B, 1) - half_patch - half_patch;
        size_B_y = size(pad_B, 2) - half_patch - half_patch;

        if xp > 0 && xp <= size_B_x && yp > 0 && yp <= size_B_y
            [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);
        end

        % Updating the iteration variable (value taken from the
        % paper).
        rs_start = floor(rs_start / 2); 
    end

end