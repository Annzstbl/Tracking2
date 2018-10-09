function [ bgImg ] = get_bgFeature( img,  box,  myParams)
    imgSz = size(img);
    objSz = [box(3)-box(1)+1, box(4)-box(2)+1];
    bgSz = objSz * myParams.padding;
    pos(1) = round(box(1) + objSz(1)/2);
    pos(2) = round(box(2) + objSz(2)/2);
    
    X = floor(pos(1)) + (1:bgSz(1)) - floor(bgSz(1)/2);
    Y = floor(pos(2)) + (1:bgSz(2)) - floor(bgSz(2)/2);
    
    X(X < 1) = 1;
    Y(Y < 1) = 1;
    X(X > imgSz(2)) = imgSz(2);
    Y(Y > imgSz(1)) = imgSz(1);
    
    bgImg = img(Y, X, :);
end

