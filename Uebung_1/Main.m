clear; 
filenames = { 'watch', 'brick', 'crown', 'key', 'apple' }; % 'crown', 'brick', 'apple', 'key', 'fork', 'pencil', 'fountain', 'hammer', 'bone' };
dataStruct = readImagesAndCalculateProps(filenames);
%showHist(dataStruct, filenames, 'roundness');

fields = {'formfactor', 'roundness', 'aspectratio', ...
    'Solidity'};

for i = 1:numel(fields)-1
  for j = i+1:numel(fields)
      showScatter(dataStruct, filenames, fields{i}, fields{j});
      
  end
end
