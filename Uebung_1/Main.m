clear; 
filenames = { 'watch', 'brick', 'crown', 'key' }; % 'crown', 'brick', 'apple', 'key', 'fork', 'pencil', 'fountain', 'hammer', 'bone' };
dataStruct = readImagesAndCalculateProps(filenames);
showHist(dataStruct, filenames, 'formfactor');