clear; 
filenames = { 'watch', 'brick', 'crown', 'key', 'apple' }; % 'crown', 'brick', 'apple', 'key', 'fork', 'pencil', 'fountain', 'hammer', 'bone' };
dataStruct = readImagesAndCalculateProps(filenames);
%showHist(dataStruct, filenames, 'roundness');
showScatter(dataStruct, filenames, 'roundness', 'formfactor');
