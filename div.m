function M = div(px, py)
    [m, n, c] = size(px);
    M = zeros(m, n, c);
    Mx = M;
    My = M;
    Mx(2 :m - 1, :, :) = px(2 :m - 1, :, :) - px(1 : m - 2, :, :);
    Mx(1, :, :) = px(1, :, :);
    Mx(m, :, :) = -px(m - 1, :, :);
    My(:, 2 : n - 1, :) = py(:, 2 : n - 1, :) - py(:, 1 : n - 2, :);
    My(:, 1, :) = py(:, 1, :);
    My(:, n, :) = -py(:, n - 1, :);
    M = Mx + My;
end


