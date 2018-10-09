function [ w ] = eqSolve( kernel )
    
    params = 'number of object is one';
    [ks, ~] = size(kernel);
    W = blkdiag(1, ones(ks - 1)/(ks - 1));
    
    [P, E] = eig(kernel);
%     [P, E] = eig(Kbar);
    A = P' * W * P;
    [beita, lamuda] = eig(A);
    [lamudaMax, maxIndex] = max(diag(lamuda));
    beitaMax = beita(:, maxIndex);
    beitaMax = real(beita(:,maxIndex));
    w = P / E * beitaMax;
    w = w' / sqrt(w' * w);
    
end

