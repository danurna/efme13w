clear; 
filenames = { 'watch', 'brick' }; % 'crown', 'brick', 'apple', 'key', 'fork', 'pencil', 'fountain', 'hammer', 'bone' };
dataStruct = readImagesAndCalculateProps(filenames);
showHist(dataStruct, filenames, 'Solidity');