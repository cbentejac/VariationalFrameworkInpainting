% Assuming the propagation phase has been done, process with the random
% search to improve the current best offsets. To do so, select pixels
% randomly within a decreasing window and see if they are a better fit or
% not. "pad_A" and "pad_B" are respectively the virtually extended image to
% rebuild in and virtually extended image to rebuild from. "mask" is the
% region in pad_A to rebuild. The pixel ("i", "j") is the one for which we
% are trying to improve the current offset. "best_x", "best_y" and
% "best_guess" are respectively the x-position of the current best offset,
% the y-position of the current best offset and the similarity value for
% the current best offset. "A" is the original image to rebuild in, with
% "half_patch" the size of half a patch side, "error" the similarity metric
% to use (0, 1 or 2) and "lambda" a value to use the Poisson metric with.
function [best_x, best_y, best_guess] = RandomSearch(pad_A, pad_B, mask, i, j, best_x, best_y, best_guess, A, half_patch, error, lambda)
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
        
        % Avoiding 0s to make sure the modulo won't be 0.
        abs_xp = abs(x_max - x_min);
        abs_yp = abs(y_max - y_min);
        if abs_xp == 0
            abs_xp = abs_xp + 1;
        end
        if abs_yp == 0
            abs_yp = abs_yp + 1;
        end
        
        % Generating the random candidates.        
        xp = mod(x_min + randi(rand_max), abs_xp);
        yp = mod(y_min + randi(rand_max), abs_yp);
        if xp == 0
            xp = 1;
        end
        if yp == 0
            yp = 1;
        end
        
        while mask(xp, yp) == 1
            xp = mod(x_min + randi(rand_max), abs(x_max - x_min));
            yp = mod(y_min + randi(rand_max), abs(y_max - y_min));
            if xp == 0
                xp = 1;
            end
            if yp == 0
                yp = 1;
            end
        end

        % Handling the case where the modulo is 0 or superior
        % to the image's size.
        size_B_x = size(pad_B, 1) - half_patch - half_patch;
        size_B_y = size(pad_B, 2) - half_patch - half_patch;

        if xp > 0 && xp <= size_B_x && yp > 0 && yp <= size_B_y
            [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch, error, lambda);
        end

        % Updating the iteration variable (value taken from the
        % paper).
        rs_start = floor(rs_start / 2); 
    end

end