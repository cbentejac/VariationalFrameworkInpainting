%% instruction
% This function is the auxiliary function for function
% <<calculate_confidence_mask>>, to get distance to the boundary
% in advance.

% For each point in the inpainting domain assigns the distance to the nearest point NOT belonging to
% the inpainting domain(amounts to the distance to the nearest point at the
% boundary)

% Here, we only care about the points inside the inpainting domain, so as for points outside 
% inpainting domain, to facilitate the following implement, all assigned to 1 
%%
function dist = distance2boundry(domain)
 
    dist = 1 - domain;

    se = strel('square', 3);
    boundary = imdilate(domain, se) - domain;

    [coordinate_bound(:, 1), coordinate_bound(:, 2), ~] = find(boundary);
    [coordinate_dom(:, 1), coordinate_dom(:, 2), ~] = find(domain);

    tmp = pdist2(coordinate_bound, coordinate_dom, 'Euclidean');
    tmp = min(tmp);

    for i = 1 : size(coordinate_dom(:, 1), 1)
        dist(coordinate_dom(i, 1), coordinate_dom(i, 2)) = tmp(i);    
    end

    dist = double(dist);

end