function [ scores ] = CalScores( obFeature, bgFeature, w, target, kernelParams)

    feature = [obFeature; bgFeature];
    [fNum, ~] = size(feature);
    sKernel = zeros(1, fNum);
    for i = 1 : fNum
        x = target - feature(i, :);
        sKernel(i) = x * x';
    end
    
    scores = w * sKernel';      

end

