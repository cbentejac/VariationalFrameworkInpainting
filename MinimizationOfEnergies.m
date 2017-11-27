function [image, offset_map] = MinimizationOfEnergies(u_0, tolerance)
    
    u = u_0;
    % While norm(u_(k+1) - u_k) < tolerance
    while norm(u - u_0) < tolerance
        u_0 = u; % Update of u_0 for the tolerance criterium.
        
        % Correspondance update
        
        
        % Image update
        
    end

end