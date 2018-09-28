function [ kernel, W ] = kernelSolve( obFeature, bgFeature, kernelParams )

    [obNum, obDim] = size(obFeature);
    [bgNum, bgDim] = size(bgFeature);
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