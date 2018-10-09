    function [cOut] = cirk( veci)

    %veci must be a row vector 
       num = numel(veci);
       cOut = zeros(num, num);
       p = ones(num - 1, 1);
       P = diag(p, 1);
       P(end, 1) = 1;
       for is = 1 : num;
           cOut(is, :) = veci;
           veci = veci * P;
       end
    end
