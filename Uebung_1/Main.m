clear; 
filenames = { 'watch', 'hammer', 'key', 'fountain', 'apple' }; % 'crown', 'brick', 'apple', 'key', 'fork', 'pencil', 'fountain', 'hammer', 'bone' };
dataStruct = readImagesAndCalculateProps(filenames);
%showHist(dataStruct, filenames, 'roundness');

fields = {'formfactor', 'roundness', 'aspectratio', ...
    'Solidity', 'compactness', 'Extent', 'Eccentricity', 'EulerNumber'};

% for i = 1:numel(fields)-1
%   for j = i+1:numel(fields)
%       showScatter(dataStruct, filenames, fields{i}, fields{j});
%   end
% end

% for i = 1:numel(fields)
%     subplot(2, 4, i);
%     showHist(dataStruct, filenames, fields{i});
%     title(fields{i});
% end

% START CLASSIFYING HERE
numberOfClasses = size(filenames, 2);
c = cell(20*numberOfClasses, 1);
% Read data in. 
for j = 1 : numberOfClasses
        startValue = (j-1) * 20 + 1;
        endValue = j * 20;
        c( startValue:endValue, 1) = dataStruct.(filenames{j});
end 
showScatter(dataStruct, filenames, 'roundness', 'Solidity');
simpleClassify(c, numberOfClasses);

