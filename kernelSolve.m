function [ K, W ] = kernelSolve( xf, yf, kernelParams )
    
	N = size(xf,1) * size(xf,2);
	xx = xf(:)' * xf(:) / N;  %squared norm of x
	yy = yf(:)' * yf(:) / N;  %squared norm of y
	
	%cross-correlation term in Fourier domain
	xyf = xf .* conj(yf);
	xy = sum(real(ifft2(xyf)), 3);  %to spatial domain
	
	%calculate gaussian response for all positions, then go back to the
	%Fourier domain
    sigma = kernelParams.sigma;
    k = exp(-1 / sigma^2 * max(0, (xx + yy - 2 * xy) / numel(xf)));
% 	kf = fft2(exp(-1 / sigma^2 * max(0, (xx + yy - 2 * xy) / numel(xf))));
    [m, n] = size(k);
    K = zeros(m * n);
    for i = 1 : m
        for j =1 :m
            cirrow = mod(j - i, m) + 1;
            tempv = k(cirrow, :);
            tempk = cirk(tempv);
            K((i - 1) * n + 1 : i * n, (j - 1) * n + 1 : j * n) = tempk;           
        end
    end
    W = 0;
end
