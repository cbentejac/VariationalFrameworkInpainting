function NNF = PatchMatch(A, B, mask, patch_size, iterations, error, lambda, NNF)
tic;
    A = double(A);
    B = double(B);
    
    % Initializing the virtually padded images and the half_patch variable.
    half_patch = floor(patch_size / 2);    
    pad_A = padarray(A, [half_patch half_patch], -1);
    pad_B = padarray(B, [half_patch half_patch], -1);
    pad_B(mask == 1) = -1;
    
    % Handling the input given (or not) as parameters and correcting them
    % if required. In particular, we need an odd patch size since we are
    % centering the patches on the pixel we are trying to fill.
    if nargin == 7
        % Initializing the NNF.
        NNF = NewInitializeNNF(A, B, mask, pad_A, pad_B, half_patch, error, lambda);
    end
    
    [m, n, ~] = size(A); 
    
    [row, col] = find(mask == 1);
    inpainting_domain = [row col];
    inpainting_domain = sortrows(inpainting_domain, 1);
    
    k = 1;
    while k <= iterations 
        disp(['Starting iteration k = ', num2str(k), ' / ', num2str(iterations)]);
        
        x_start = 1;
        x_end = length(inpainting_domain);
        x_change = 1;
        y_change = x_change;
        if mod(k, 2) == 0
            x_start = x_end;
            x_end = 1;
            x_change = -1;
            y_change = x_change;
        end
        
        for n = x_start : x_change : x_end
            % Current best guess.
            i = inpainting_domain(n, 1);
            j = inpainting_domain(n, 2);
            [best_x, best_y, best_guess] = GetBestOffsets(NNF, i, j);
            
            % Propagation (top or bottom).
            if i - x_change > 0 && i - x_change <= m
                xp = NNF(i - x_change, j, 1);
                yp = NNF(i - x_change, j, 2);
                if xp <= size(B, 1) && xp > 0
                    [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i + half_patch, j + half_patch, xp, yp, best_guess, best_x, best_y, half_patch, error, lambda);
                end
            end
            
            % Propagation (left or right).
            if j - y_change > 0 && j - y_change <= m
                xp = NNF(i, j - y_change, 1);
                yp = NNF(i, j - y_change, 2);
                if yp <= size(B, 2) && yp > 0
                    [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i + half_patch, j + half_patch, xp, yp, best_guess, best_x, best_y, half_patch, error, lambda);
                end
            end
            
            [best_x, best_y, best_guess] = NewRandomSearch(pad_A, pad_B, mask, i + half_patch, j + half_patch, best_x, best_y, best_guess, A, half_patch, error, lambda);
            
%             % Propagation with absolute coordinates.
%             % Left (odd) or right (even) propagation.
%             if (i - x_change) > 0 && (i - x_change) <= m
%                 xp = NNF(i - x_change, j, 1);% + x_change;
%                 yp = NNF(i - x_change, j, 2);
%                 if xp <= size(B, 1) && xp > 0
%                     [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i + half_patch, j + half_patch, xp, yp, best_guess, best_x, best_y, half_patch);
%                 end
%             end
% 
%             % Top (odd) or bottom (even) propagation.
%             if (j - y_change) > 0 && (j - y_change) <= n
%                 xp = NNF(i, j - y_change, 1);
%                 yp = NNF(i, j - y_change, 2);% + y_change;
%                 if yp <= size(B, 2) && yp > 0
%                     [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i + half_patch, j + half_patch, xp, yp, best_guess, best_x, best_y, half_patch);
%                 end
%             end
%         
%             [best_x, best_y, best_guess] = NewRandomSearch(pad_A, pad_B, mask, i + half_patch, j + half_patch, best_x, best_y, best_guess, A, half_patch);
%             
%             if mask(best_x, best_y) == 1
%                 [best_x, best_y, best_guess] = GetBestOffsets(NNF, i, j);
%             end

            % Updating the NNF accordingly by saving the new nearest-neighbour.
            NNF = UpdateNNF(NNF, i, j, best_x, best_y, best_guess);                
        end         
        k = k + 1;
    end
    toc;
end