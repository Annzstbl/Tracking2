clear
clc
%% Initialization
myParams.padding = 2;
myParams.overlapRateLimit = 0.5;

benchmarkPath='D:\Repository\Sequences';
addpath(genpath(benchmarkPath));
% seqs = configSeqs;
% seqLength = size(seqs, 2);
% seqIndex = 47;


% seq = seqs{seqIndex};
pathAnno=[benchmarkPath, '/anno/'];
seq.name = 'Basketball';
seq.endFrame = 725;
seq.startFrame = 1;
seq.nz = 4;
seq.ext = 'jpg';
seq.path = [benchmarkPath '\' seq.name '\img\'];
seq.rect_anno = dlmread([benchmarkPath '\' seq.name '\groundtruth_rect.txt']);
% seq.rect_anno = dlmread([pathAnno seq.name '.txt']);
seq.init_rect = seq.rect_anno(1,:);
seq.len = seq.endFrame - seq.startFrame + 1;
seq.s_frames = cell(seq.len, 1);
nz = strcat('%0', num2str(seq.nz), 'd');
for i = 1:seq.len
    imageNo = seq.startFrame + i - 1;
    id = sprintf(nz, imageNo);
    seq.s_frames{i} = strcat(seq.path, id, '.', seq.ext);
end

%% KernelParams
kernelParams.sigma = 0.2;
%% FirstFrame
img = imread(seq.s_frames{1});
initbox = [seq.init_rect(1:2) seq.init_rect(1:2)+seq.init_rect(3:4)-1];
% object = img(initbox(2):initbox(4), initbox(1):initbox(3),:);
% obFeature = fhog(im2single(object), 8, 9);
% obFeatureR = reshape(obFeature, [1,numel(obFeature)]);
bgImg = get_bgFeature(img, initbox, myParams);
x = fhog(im2single(bgImg), 8, 9);
x(:, :, end) = [];
xf = fft2(x);
kernel = kernelSolve(xf, xf, kernelParams);
w = eqSolve(kernel);
for i = 1:20
    for j = 1:8
        index = (i - 1) * 8 + j;
        scores(i, j) = kernel(index, :) * w';
    end
end

ibox = initbox;
obScores = CalScores(obFeatureR, bgFeatureR, w, obFeatureR, kernelParams);
%% Tracking
img = imread(seq.s_frames{2});
bgImg = get_bgFeature(img, ibox, myParams);
y = fhog(im2single(bgImg), 8, 9);
y(:, :, end) = [];
yf = fft2(y);
skernel = kernelSolve(xf, yf, kernelParams);
for i = 1:20
    for j = 1:8
        index = (i - 1) * 8 + j;
        scores2(i, j) = skernel(index, :) * w';
    end
end
%% Tracking
for imgIndex = 77 : seq.len
    img = imread(seq.s_frames{imgIndex});
    disp(seq.s_frames{imgIndex})
    tic
    [bgFeatureAll2, nearIndex, bgWindowPosAll] = get_bgFeature(img, ibox, myParams);
    [bgNum, ~] = size(bgFeatureAll2);
    scores = zeros(bgNum, 1);
    for i = 1 : bgNum
        scores(i) = CalScores(obFeatureR, bgFeatureR, w, bgFeatureAll2(i,:), kernelParams);
    end
    scores = scores - obScores;
    scores = abs(scores);
    [~, locationIndex] = min(scores);
    location = bgWindowPosAll(locationIndex, :);
    ibox = location;
    toc
%     X1 = bgWindowPosAll(:,1);
%     Y1 = bgWindowPosAll(:,2);
%     X = unique(X1);
%     Y = unique(Y1);
%     [Xm, Ym] = meshgrid(X, Y);
%     figure
%     mesh(Xm, Ym, reshape(scores, [numel(Y), numel(X)]));
%     figure, imshow(img);
%     rectangle('Position', [location(1:2) ,location(3:4) - location(1:2)], 'edgecolor', 'Red', 'LineWidth', 3);
%     drawnow
    Result(imgIndex, :)=location;
end

h = figure;
for i = 2:185
    figure(h)
    imgTemp = imread(seq.s_frames{i});
    imshow(imgTemp)
    locationTemp = Result(i, :);
    rectangle('Position', [locationTemp(1:2) ,locationTemp(3:4) - locationTemp(1:2)], 'edgecolor', 'Red', 'LineWidth', 3);
    pause(0.03)
end

