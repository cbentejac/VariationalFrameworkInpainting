% Given two images A and B, returns the nearest-neighbour field using the
% parallelized patch match method.
function NNF = ParallelizedPatchMatch(A, B, patch_size, iterations)
    tic;
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
   
    half_patch = floor(patch_size / 2);
    pad_A = padarray(A, [half_patch half_patch], -1);
    pad_B = padarray(B, [half_patch half_patch], -1);
    
    % Initializing the NNF (two output buffers).
    NNF = InitializeNNF(A, B, pad_A, pad_B, half_patch);

    % For hyperthreaded CPUs to work, we need to use a cluster profile and
    % not the local ones which is set to the number of physical cores...
    %     nb_cores = strsplit(evalc('feature(''numcores'')'));
    %     nb_cores = str2double(nb_cores{14});
    
    % Gets the number of available physical cores for parallelization and
    % start the parallel pool.
    nb_cores = maxNumCompThreads;
    size_chunk = floor(size(A, 1) / nb_cores);
    p = gcp; 
    
    % Splitting the image into chunks according to the number of CPUs.
    for i = 1 : nb_cores
        if i == nb_cores
            chunk{i} = A((i - 1) * size_chunk + 1 : end, :, :);
            NNF_chunk{i} = NNF((i - 1) * size_chunk + 1 : end, :, :);
        else
            chunk{i} = A((i - 1) * size_chunk + 1 : i * size_chunk, :, :);
            NNF_chunk{i} = NNF((i - 1) * size_chunk + 1 : i * size_chunk, :, :);
        end
        pad_chunk{i} = padarray(chunk{i}, [half_patch half_patch], -1);
    end
    
    k = 1;
    while k <= iterations 
        disp(['Starting iteration k = ', num2str(k), ' / ', num2str(iterations)]);        
        
        parfor N = 1 : nb_cores
            % Gets the propagation limits and order for the current chunk.
            [x_start, x_end, x_change, y_start, y_end, y_change] = GetPropapagationLimits(k, chunk{N}, half_patch);                        
            [m, n, ~] = size(chunk{N});
            
            for i = x_start : x_change : x_end
                for j = y_start : y_change : y_end
                    
                    % Current best guess.
                    [best_x, best_y, best_guess] = GetBestOffsets(NNF_chunk{N}, i - half_patch, j - half_patch);

                    % Propagation with absolute coordinates.
                    % Left (odd) or right (even) propagation.
                    if (i - half_patch - x_change) > 0 && (i - x_change - half_patch) <= m
                        xp = NNF_chunk{N}(i - half_patch - x_change, j - half_patch, 1) + x_change;
                        yp = NNF_chunk{N}(i - half_patch - x_change, j - half_patch, 2);
                        if xp <= size(B, 1) && xp > 0
                            [best_x, best_y, best_guess] = ImproveGuess(pad_chunk{N}, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);
                        end
                    end

                    % Top (odd) or bottom (even) propagation.
                    if (j - half_patch - y_change) > 0 && (j - y_change - half_patch) <= n
                        xp = NNF_chunk{N}(i - half_patch, j - half_patch - y_change, 1);
                        yp = NNF_chunk{N}(i - half_patch, j - half_patch - y_change, 2) + y_change;
                        if yp <= size(B, 2) && yp > 0
                            [best_x, best_y, best_guess] = ImproveGuess(pad_chunk{N}, pad_B, i, j, xp, yp, best_guess, best_x, best_y, half_patch);
                        end
                    end

                    [best_x, best_y, best_guess] = RandomSearch(pad_chunk{N}, pad_B, i, j, best_x, best_y, best_guess, chunk{N}, half_patch);

                    % Updating the NNF accordingly by saving the new nearest-neighbour.
                    NNF_chunk{N} = UpdateNNF(NNF_chunk{N}, i - half_patch, j - half_patch, best_x, best_y, best_guess);                       
                end
            end
        end
        
        % Update the global NNF.
        NNF = cat(1, NNF_chunk{:});

        k = k + 1;
    end  
    toc;
end