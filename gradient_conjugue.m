function uz = gradient_conjugue(u0, epsilon, lambda, kz, fz, vx, vy, nb_iter)
    uz = u0;
    r = (1 - lambda) * div(gradx(kz .* vx), grady(kz .* vy)) - lambda * kz .* fz;
    p = r;
    for i = 1 : nb_iter
        Ap = (1 - lambda) * div (gradx(kz .* gradx(uz)), grady(kz .* grady(uz))) - lambda * kz .* uz;
        r_t = permute(r, [2, 1, 3]);
        p_t = permute(p, [2, 1, 3]);
        alpha(:, :, 1) = (r(:, :, 1) * r_t(:, :, 1)) ./ (Ap(:, :, 1) * p_t(:, :, 1));
        alpha(:, :, 2) = (r(:, :, 2) * r_t(:, :, 2)) ./ (Ap(:, :, 2) * p_t(:, :, 2));
        alpha(:, :, 3) = (r(:, :, 3) * r_t(:, :, 3)) ./ (Ap(:, :, 3) * p_t(:, :, 3));
        uz(:, :, 1) = uz(:, :, 1) + alpha(:, :, 1) * p(:, :, 1);
        uz(:, :, 2) = uz(:, :, 2) + alpha(:, :, 2) * p(:, :, 2);
        uz(:, :, 3) = uz(:, :, 3) + alpha(:, :, 3) * p(:, :, 3);
        r1(:, :, 1) = r(:, :, 1) - alpha(:, :, 1) * Ap(:, :, 1);
        r1(:, :, 2) = r(:, :, 2) - alpha(:, :, 2) * Ap(:, :, 2);
        r1(:, :, 3) = r(:, :, 3) - alpha(:, :, 3) * Ap(:, :, 3);
        if (norm2(r1) < epsilon)
            break;
        end
        r1_t = permute(r1, [2, 1, 3]);
        beta(:, :, 1) = (r1(:, :, 1) * r1_t(:, :, 1)) ./ (r(:, :, 1) * r_t(:, :, 1));
        beta(:, :, 2) = (r1(:, :, 2) * r1_t(:, :, 2)) ./ (r(:, :, 2) * r_t(:, :, 2));
        beta(:, :, 3) = (r1(:, :, 3) * r1_t(:, :, 3)) ./ (r(:, :, 3) * r_t(:, :, 3));
        p(:, :, 1) = r1(:, :, 1) + beta(:, :, 1) * p(:, :, 1);
        p(:, :, 2) = r1(:, :, 2) + beta(:, :, 2) * p(:, :, 2);
        p(:, :, 3) = r1(:, :, 3) + beta(:, :, 3) * p(:, :, 3);
    end
end