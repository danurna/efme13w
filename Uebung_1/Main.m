clear; 
% Define and read data.
filenames = { 'watch', 'brick', 'fork', 'fountain', 'apple' };
dataStruct = readImagesAndCalculateProps(filenames);
fields = {'formfactor', 'roundness', 'aspectratio', 'Solidity', 'compactness' };

figure();
% Maximize the figure window.
set(gcf, 'Position', get(0, 'ScreenSize'));
suptitle('Data Exploration - Finding the right features!');

% Draw scatter plots of all combinations of our fields.
p = 0;
for i = 1:numel(fields)-1
  for j = i+1:numel(fields)
      p = p + 1;
      subplot(3, 4, p);
      [TRAIN TRAINCLASSES] = getTrainingSet(dataStruct, filenames, fields{i}, fields{j});
      showScatter(TRAIN, TRAINCLASSES, fields{i}, fields{j});
      hLeg = legend('~');
      set(hLeg,'visible','off');
  end 
end

%Choose best indices of best features (formfactor, and roundness)
ix1 = 1;
ix2 = 2;

% Make training Set out of chosen features
[TRAIN TRAINCLASSES] = getTrainingSet(dataStruct, filenames, fields{ix1}, fields{ix2});
numberOfClasses = size(filenames, 2);


figure();
% Display raw, unclassified data
subplot(1, 3, 1);
showScatter(TRAIN, TRAINCLASSES, fields{ix1}, fields{ix2});
title('Training data');

% Display classified data by hardcoded thresholds.
subplot(1, 3, 2);
showScatter(TRAIN, TRAINCLASSES, fields{ix1}, fields{ix2});
[props, classified] = simpleClassify(TRAIN, numberOfClasses);
hold on;
gscatter(props(:,1), props(:,2), classified, 'mcbrg', 'x');
hold off;
title('Classified by "hand"');

% Display classified data by knn.
subplot(1, 3, 3);
showScatter(TRAIN, TRAINCLASSES, fields{ix1}, fields{ix2});
myC = knn(props, props, classified, 5, true);
hold on;
gscatter(props(:,1),props(:,2),myC,'mcbrg','x'); 
hold off;
title('Classified by our K-NN. K = 5');