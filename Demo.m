clear
clc
%% Initialization
myParams.padding = 2;
myParams.overlapRateLimit = 0.5;

benchmarkPath='E:\Benchmark\tracker_benchmark_v1.0';
addpath(genpath(benchmarkPath));
seqs = configSeqs;
seqLength = size(seqs, 2);
seqIndex = 47;

seq = seqs{seqIndex};
pathAnno=[benchmarkPath, '/anno/'];
seq.rect_anno = dlmread([pathAnno seq.name '.txt']);
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
kernelParams.sigma = 0.5;
%% FirstFrame
img = imread(seq.s_frames{1});
initbox = [seq.init_rect(1:2) seq.init_rect(1:2)+seq.init_rect(3:4)-1];
object = img(initbox(2):initbox(4), initbox(1):initbox(3),:);
obFeature = fhog(im2single(object), 8, 9);
obFeatureR = reshape(obFeature, [1,numel(obFeature)]);
[bgFeatureAll, nearIndex, bgWindowPosAll] = get_bgFeature(img, initbox, myParams);
bgFeatureR = bgFeatureAll;
bgFeatureR(nearIndex, :)= [];
[kernel, W] = kernelSolve(obFeatureR, bgFeatureR, kernelParams);
w = eqSolve(kernel, W);
obScores = CalScores(obFeatureR, bgFeatureR, w, obFeatureR, kernelParams);
% [bgNum, ~] = size(bgFeatureAll);
% scores = zeros(bgNum, 1);
% for i = 1 : bgNum
%     scores(i) = CalScores(obFeatureR, bgFeatureR, w, bgFeatureAll(i,:), kernelParams);
% end
% 
% X1 = bgWindowPosAll(:,1);
% Y1 = bgWindowPosAll(:,2);
% figure
% scatter3(X1,Y1,scores);
% X = unique(X1);
% Y = unique(Y1);
% [Xm, Ym] = meshgrid(X, Y);
% figure
% mesh(Xm, Ym, reshape(scores, [numel(Y), numel(X)]));
ibox = initbox;
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

