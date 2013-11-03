clear; 
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
showScatter(dataStruct, filenames, 'formfactor', 'roundness');
[props, classified] = simpleClassify(c, numberOfClasses);
hold on;
gscatter(props(:,1), props(:,2), classified, 'mcbry', 'x');
hold off;