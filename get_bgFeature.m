function [ bgFeature , index, bgWindowPos ] = get_bgFeature( img,  box,  myParams)
    imgSz = size(img);
    objSz = [box(3)-box(1)+1, box(4)-box(2)+1];
    bgSz = objSz * myParams.padding;
    bgArea = prod(objSz);
    extendSz = round((bgSz - objSz)/2);
    %bgBox objBox的padding倍
    bgBox(1) = max(round(box(1) - extendSz(1) + 1), 1);
    bgBox(3) = min(round(box(3) + extendSz(1) - 1), imgSz(2));
    bgBox(2) = max(round(box(2) - extendSz(2) + 1), 1);
    bgBox(4) = min(round(box(4) + extendSz(2) - 1), imgSz(1));
    
    % X1：背景框的x坐标取值；X2：x坐标取值+objsize
    X = bgBox(1):bgBox(3) - objSz(1) + 1;
    Y = bgBox(2):bgBox(4) - objSz(2) + 1;
    [X1, Y1]=meshgrid(X, Y);
    X1 = reshape(X1, [numel(X1),1]);
    Y1 = reshape(Y1, [numel(Y1),1]);
    X2 = X1 + objSz(1)-1;
    Y2 = Y1 + objSz(2)-1;
    
    bgWindowPos = [X1, Y1, X2, Y2];
    featureSz = prod(floor(objSz/8)) * 32;
    X1num = numel(X1);
    index = zeros(numel(X1),1);
    bgFeature = zeros(X1num, featureSz);
    for i = 1:numel(X1)
        bgPos = bgWindowPos(i,:);
        x1 = max(bgPos(1), box(1));
        y1 = max(bgPos(2), box(2));
        x2 = min(bgPos(3), box(3));
        y2 = min(bgPos(4), box(4));
        overlapArea = (x2 - x1) * (y2 - y1);
        overlapRate = overlapArea / bgArea;
        if overlapRate > myParams.overlapRateLimit
            index(i) = i;
        end
        bg = im2single(img(bgPos(2):bgPos(4), bgPos(1):bgPos(3), :));
        bgFeature(i,:) = reshape(fhog(bg),[1,featureSz]);
    end     
    index(index==0)=[];
end

