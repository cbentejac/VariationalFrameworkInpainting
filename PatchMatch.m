% Given two images A and B, returns the nearest-neighbour field using the
% patch match method.
function NNF = PatchMatch(A, B, patch_size, iterations)
    A = double(A);
    B = double(B);

    % Handling the input given (or not) as parameters and correcting them
    % if required. In particular, we need an odd patch size since we are
    % centering the patches on the pixel we are trying to fill.
    if nargin == 3
        iterations = 5;
    end
    if nargin == 2
        patch_size = 5;
        iterations = 5;
    end    
    if mod(patch_size, 2) == 0  
        patch_size = patch_size + 1;
    end
    
    % Initializing the virtually padded images and the half_patch variable.
    half_patch = floor(patch_size / 2);    
    pad_A = padarray(A, [half_patch half_patch], -1);
    pad_B = padarray(B, [half_patch half_patch], -1);
    
    % Initializing the NNF.
    NNF = InitializeNNF(A, B, pad_A, pad_B, half_patch);
    
    [m, n, ~] = size(A); 
    
    k = 1;
    while k <= iterations 
        disp(['Iteration k = ', num2str(k)]);
         
        % Odd iteration (top and left candidates).
        x_start = 1 + half_patch;
        x_end = m + half_patch;
        x_change = 1;
        y_start = 1 + half_patch;
        y_end = n + half_patch;
        y_change = 1;
        
        % Even iteration (bottom and right candidates).
        if mod(k, 2) == 0
            x_start = x_end;
            x_end = 1 + half_patch;
            x_change = -1;
            y_start = y_end; 
            y_end = 1 + half_patch;
            y_change = -1;
        end

        for i = x_start : x_change : x_end
            for j = y_start : y_change : y_end
                
                % Current best guess.
                best_x = NNF(i - half_patch, j - half_patch, 1);
                best_y = NNF(i - half_patch, j - half_patch, 2);
                best_guess = NNF(i - half_patch, j - half_patch, 3);
                
                % Propagation with absolute coordinates.
                % Left (odd) or right (even) propagation.
                if (i - half_patch - x_change) > 0 && (i - x_change - half_patch) <= m
                    xp = NNF(i - half_patch - x_change, j - half_patch, 1) + x_change;
                    yp = NNF(i - half_patch - x_change, j - half_patch, 2);
                    if xp <= size(B, 1) && xp > 0
                        [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);
                    end
                end
                
                % Top (odd) or bottom (even) propagation.
                if (j - half_patch - y_change) > 0 && (j - y_change - half_patch) <= n
                    xp = NNF(i - half_patch, j - half_patch - y_change, 1);
                    yp = NNF(i - half_patch, j - half_patch - y_change, 2) + y_change;
                    if yp <= size(B, 2) && yp > 0
                        [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);
                    end
                end
                
                % Random search.
                % Initializing the beginning of random search (max
                % iterations).
                rs_start = intmax;
                if rs_start > max(m + half_patch, n + half_patch)
                    rs_start = max(m + half_patch, n + half_patch);
                end
                     
                % Hardcoded value of RAND_MAX in C++ (plays the role of an
                % arbitrary value used to generate a random integer).
                rand_max = 32767; 
                while rs_start >= 1
                    x_min = max(best_x - rs_start, 1 + half_patch);
                    x_max = min(best_x + rs_start + 1, m + half_patch);
                    y_min = max(best_y - rs_start, 1 + half_patch); 
                    y_max = min(best_y + rs_start + 1, n + half_patch);                    
                    
                    % Generating the random candidates.
                    xp = mod(x_min + randi(rand_max), abs(x_max - x_min));
                    yp = mod(y_min + randi(rand_max), abs(y_max - y_min));
                    
                    % Handling the case where the modulo is 0 or superior
                    % to the image's size.
                    if xp == 0
                        xp = 1;
                    end
                    if yp == 0
                        yp = 1;
                    end                    
                    if xp > size(pad_B, 1) - half_patch
                        xp = size(pad_B, 1) - half_patch;
                    end
                    if yp > size(pad_B, 2) - half_patch
                        yp = size(pad_B, 2) - half_patch;
                    end
                        
                    [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);
                    
                    % Updating the iteration variable (value taken from the
                    % paper).
                    rs_start = floor(rs_start / 2); 
                end
                                
                % Saving the new nearest-neighbour.
                NNF(i - half_patch, j - half_patch, 1) = best_x;
                NNF(i - half_patch, j - half_patch, 2) = best_y;
                NNF(i - half_patch, j - half_patch, 3) = best_guess;                
            end
        end        
        k = k + 1;
    end
end