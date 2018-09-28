function [ w ] = eqSolve( kernel, W )

    [P, E] = eig(kernel);
    A = P' * W * P;
    [beita, lamuda] = eig(A);
    [lamudaMax, maxIndex] = max(diag(lamuda));
    beitaMax = beita(:, maxIndex);
    w = P / E * beitaMax;
    w = w' / sqrt(w' * w);
    
end

