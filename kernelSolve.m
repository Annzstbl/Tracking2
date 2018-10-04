function [ kernel, W ] = kernelSolve( xf, yf, kernelParams )
    
	N = size(xf,1) * size(xf,2);
	xx = xf(:)' * xf(:) / N;  %squared norm of x
	yy = yf(:)' * yf(:) / N;  %squared norm of y
	
	%cross-correlation term in Fourier domain
	xyf = xf .* conj(yf);
	xy = sum(real(ifft2(xyf)), 3);  %to spatial domain
	
	%calculate gaussian response for all positions, then go back to the
	%Fourier domain
    sigma = kernelParams.sigma;
	kf = fft2(exp(-1 / sigma^2 * max(0, (xx + yy - 2 * xy) / numel(xf))));
    
    Wo = ones(obNum) / obNum;
    Wb = ones(bgNum) / bgNum;
    W = mdiag(Wo, Wb);
    feature = [obFeature; bgFeature];
    [fNum, fDim] = size(feature);
    kernel = zeros(fNum, fNum);
    for i = 1 : fNum
        for j = i : fNum
            x = feature(i, :) - feature(j, :);
            ker = x * x';
            kernel(i, j)=ker;
            kernel(j, i)=ker;
        end
    end
    kernel = exp(-kernel / (2 * kernelParams.sigma ^ 2));
    kernel = kernel - kernel * 2 / fNum + kernel / (fNum * fNum);
end