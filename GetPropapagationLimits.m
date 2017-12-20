% Given the number of the current iteration (odd or even) and the image to
% which the patch match is applied, get the correct indices and step to go
% through the propagation and random search phases.
function [x_start, x_end, x_change, y_start, y_end, y_change] = GetPropapagationLimits(k, A, half_patch)
        [m, n, ~] = size(A);
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
end