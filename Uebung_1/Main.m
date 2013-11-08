try
    close(1);
catch e
end

try
    close(2);
catch e
end

try
    close(3);
catch e
end

clear;
% filenames = {'apple', 'bat', 'beetle', 'bell', 'bird', 'Bone', 'bottle', ...
% 'brick', 'butterfly', 'camel', 'car', 'carriage', 'cattle', 'cellular', ...
% 'chicken', 'children', 'chopper', 'classic', 'Comma', 'crown', 'cup', ...
% 'deer', 'device0', 'device1', 'device2', 'device3', 'device4','device5', ...
% 'device6', 'device7', 'device8', 'device9', 'dog', 'elephant', 'face', ...
% 'fish', 'flatfish', 'fly', 'fork', 'fountain', 'frog', 'Glas', 'guitar', ...
% 'hammer', 'hat', 'HCircle', 'Heart', 'horse', 'horseshoe', 'jar', 'key', ...
% 'lizzard', 'lmfish', 'Misk', 'octopus', 'pencil', 'pocket', ...
% 'rat', 'ray', 'sea_snake', 'shoe', 'spoon', 'spring', 'stef', 'teddy', ...
% 'tree', 'truck', 'turtle', 'watch'};

% Define and read data.
filenames = { 'watch', 'brick', 'fork', 'fountain', 'apple'};
dataStruct = readImagesAndCalculateProps(filenames);
fields = {'formfactor', 'roundness', 'aspectratio', 'Solidity' };

figure(1);
% Maximize the figure window.
set(gcf, 'Position', get(0, 'ScreenSize'));
suptitle('Data Exploration - Finding the right features!');

combinations = nchoosek(fields,2);

% Draw scatter plots of all combinations of our fields.
p = 0;

for i = 1:size(combinations,1)
   subplot(2,3,i);
   [TRAIN, TRAINCLASSES] = getTrainingSet(dataStruct, filenames, combinations{i,1}, combinations{i,2});
   showScatter(TRAIN, TRAINCLASSES, combinations{i,1}, combinations{i,2});
   hLeg = legend('~');
   set(hLeg, 'visible', 'off');
end

%Choose best indices of best features (formfactor, and roundness)
ix1 = 1;
ix2 = 2;

% Make training Set out of chosen features
[TRAIN TRAINCLASSES] = getTrainingSet(dataStruct, filenames, fields{ix1}, fields{ix2});
numberOfClasses = size(filenames, 2);


figure(2);
set(gcf, 'Position', get(0, 'ScreenSize'));
% Display raw, unclassified data
subplot(1, 3, 1);
showScatter(TRAIN, TRAINCLASSES, fields{ix1}, fields{ix2});
title('Training data');

% Display classified data by hardcoded thresholds.
subplot(1, 3, 2);
simpleC = simpleClassify(TRAIN, numberOfClasses);
showScatter(TRAIN, simpleC, fields{ix1}, fields{ix2});
title('Classified by "hand"');

% Display classified data by knn.
subplot(1, 3, 3);
knnC = knn(TRAIN, TRAIN, TRAINCLASSES, 5, true);
showScatter(TRAIN, knnC, fields{ix1}, fields{ix2});
title('Classified by our K-NN. K = 5');

validateKNN(TRAIN,TRAINCLASSES);

figure(3);
set(gcf, 'Position', get(0, 'ScreenSize'));
tryAndPlotEveryK(TRAIN, TRAINCLASSES);

fprintf('\n\n%s\n', 'ALL DONE!');
