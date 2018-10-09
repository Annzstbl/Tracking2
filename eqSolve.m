function [ w ] = eqSolve( kernel )
    
    params = 'number of object is one';
    [ks, ~] = size(kernel);
    Kbar = kernel - 2 / ks * kernel * ones(ks) + ...
        1 / ks / ks * ones(ks) * kernel * ones(ks);
    W = blkdiag(1, ones(ks - 1)/(ks - 1));
    
    [P, E] = eig(Kbar);
    A = P' * W * P;
    [beita, lamuda] = eig(A);
    [lamudaMax, maxIndex] = max(diag(lamuda));
    beitaMax = beita(:, maxIndex);
    w = P / E * beitaMax;
    w = w' / sqrt(w' * w);
    
end

