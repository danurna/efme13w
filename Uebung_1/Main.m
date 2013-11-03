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
      showScatter(dataStruct, filenames, fields{i}, fields{j});
      hLeg = legend('example');
      set(hLeg,'visible','off');
  end 
end

% Extract data of classes into one vector
numberOfClasses = size(filenames, 2);
c = cell(20*numberOfClasses, 1);
% Read data in. 
for j = 1 : numberOfClasses
    startValue = (j-1) * 20 + 1;
    endValue = j * 20;
    c( startValue:endValue, 1) = dataStruct.(filenames{j});
end 

figure();
suptitle('Data Classification');
% Display raw, unclassified data
subplot(1, 3, 1);
showScatter(dataStruct, filenames, 'formfactor', 'roundness');
title('Unclassified data');

% Display classified data by hardcoded values.
subplot(1, 3, 2);
showScatter(dataStruct, filenames, 'formfactor', 'roundness');
[props, classified] = simpleClassify(c, numberOfClasses);
hold on;
gscatter(props(:,1), props(:,2), classified, 'mcbrg', 'x');
hold off;
title('Classified by "hand"');

% Display classified data by knn.
subplot(1, 3, 3);
showScatter(dataStruct, filenames, 'formfactor', 'roundness');
myC = knn(props, props, classified, 5, true);
hold on;
gscatter(props(:,1),props(:,2),myC,'mcbrg','x'); 
hold off;
title('Classified by our K-NN. K = 5');