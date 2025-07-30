% Generate a random valid rotation matrix

function example()
    num_pts = 100;

    for dim = [2, 3]
        % disp(sprintf("%dD points\n", dim));
        disp("")

        R = random_rotation(dim);
        t = random_translation(dim);
        scale = random_scale();
        src = random_points(num_pts, dim);
        dst = scale * src * R' + t';

        % Recover R and t
        [ret_R, ret_t, ret_scale] = rigid_transform(src, dst, 1);
        dst2 = ret_scale * src * R' + ret_t';

        rmse = sqrt(mean((dst - dst2).^2, "all"));

        disp("Ground truth rotation\n")
        R
        disp("\n")
        disp("Recovered rotation\n")
        ret_R
        disp("\n")

        disp("Ground truth translation: ")
        t'
        disp("Recovered translation: ")
        ret_t'
        disp("")
        % disp("Ground truth scale: %f\n", scale)
        % disp("Recovered scale: %f\n", ret_scale)
        disp("")
        % disp("RMSE: %f", rmse)

        if rmse < 1e-6
            disp("Everything looks good!\n")
        else
            disp("Hmm something doesn't look right ...\n")
        end
    end
end

function pts = random_points(num, dim)
    pts = rand(num, dim);
end

function R = random_rotation(dim)
    R = orth(rand(dim, dim)); % random rotation matrix

    if det(R) < 0
        [U, S, V] = svd(R);
        S = eye(dim);
        S(dim, dim) = -1;
        R = V * S * U';
    end
end

function t = random_translation(dim)
    t = rand(dim, 1);
end

function scale = random_scale()
    scale = 0.1 + rand() * 10;
end

