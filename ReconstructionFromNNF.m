% Given a NNF, reconstruct the image A using pixels of B.
function output = ReconstructionFromNNF(A, B, NNF)
    output = uint8(zeros(size(A)));
    for i = 1 : size(A, 1)
        for j = 1 : size(A, 2)
            output(i, j, :) = B(NNF(i, j, 1), NNF(i, j, 2), :);
        end
    end
end