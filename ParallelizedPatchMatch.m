% Given two images A and B, returns the nearest-neighbour field using the
% parallelized patch match method.
function NNF = ParallelizedPatchMatch(A, B, mask, half_patch, iterations, error, lambda, NNF)
tic;
    A = double(A);
    B = double(B);
    
    % Initializing the virtually padded images and the half_patch variable.
    pad_A = padarray(A, [half_patch half_patch], -1);
    pad_B = padarray(B, [half_patch half_patch], -1);
    pad_B(mask == 1) = -1;
    
    % Handling the input given (or not) as parameters and correcting them
    % if required. In particular, we need an odd patch size since we are
    % centering the patches on the pixel we are trying to fill.
    if nargin == 7
        % Initializing the NNF.
        NNF = InitializeNNF(A, mask, pad_A, pad_B, half_patch, error, lambda);
    end
    
    [h, w, ~] = size(A); 
    
    [row, col] = find(mask == 1);
    inpainting_domain = [row col];
    inpainting_domain = sortrows(inpainting_domain, 1);
    
    % Gets the number of available physical cores for parallelization and
    % start the parallel pool.
    nb_cores = maxNumCompThreads;
    size_chunk = floor(size(inpainting_domain, 1) / nb_cores);
    p = gcp; 
    
    % Splitting the image into chunks according to the number of CPUs.
    for i = 1 : nb_cores
        if i == nb_cores
            chunk{i} = inpainting_domain((i - 1) * size_chunk + 1 : end, :);            
        else
            chunk{i} = inpainting_domain((i - 1) * size_chunk + 1 : i * size_chunk, :);
        end
    end
            
    k = 1;
    while k <= iterations 
        disp(['Starting iteration k = ', num2str(k), ' / ', num2str(iterations)]);        
        
        parfor N = 1 : nb_cores
            NNF_chunk{N} = NNF;
            
            % Gets the propagation limits and order for the current chunk.
            x_start = 1;
            x_end = length(chunk{N});
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
                i = chunk{N}(n, 1);
                j = chunk{N}(n, 2);
                [best_x, best_y, best_guess] = GetBestOffsets(NNF, i, j);
                
                % Propagation (top or bottom).
                if i - x_change > 0 && i - x_change <= h
                    xp = NNF(i - x_change, j, 1);
                    yp = NNF(i - x_change, j, 2);
                    if xp <= size(B, 1) && xp > 0
                        [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i + half_patch, j + half_patch, xp, yp, best_guess, best_x, best_y, half_patch, error, lambda);
                    end
                end

                % Propagation (left or right).
                if j - y_change > 0 && j - y_change <= w
                    xp = NNF(i, j - y_change, 1);
                    yp = NNF(i, j - y_change, 2);
                    if yp <= size(B, 2) && yp > 0
                        [best_x, best_y, best_guess] = ImproveGuess(pad_A, pad_B, i + half_patch, j + half_patch, xp, yp, best_guess, best_x, best_y, half_patch, error, lambda);
                    end
                end
            
                [best_x, best_y, best_guess] = RandomSearch(pad_A, pad_B, mask, i + half_patch, j + half_patch, best_x, best_y, best_guess, A, half_patch, error, lambda);
            
                % Updating the parallel NNF accordingly by saving the new nearest-neighbour.
                NNF_chunk{N} = UpdateNNF(NNF_chunk{N}, i, j, best_x, best_y, best_guess);     
            end
        end
        
        % Updating the actual NNF using the activated parallel NNF pixels.
        NNF_copy = NNF;
        for i = 1 : nb_cores            
            NNF_copy(NNF_chunk{i} ~= NNF) = NNF_chunk{i}(NNF_chunk{i} ~= NNF);
        end
        
        NNF = NNF_copy;
        
        k = k + 1;
    end
toc;
end