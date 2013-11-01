clear; 
watches = read_images('watch');
bats = read_images('bat');
crowns = read_images('crown');
bricks = read_images('brick');
apples = read_images('apple');
keys = read_images('key');
forks = read_images('fork');
pencils = read_images('pencil');
bones = read_images('Bone');
fountains = read_images('fountain');
hammers = read_images('hammer');


dataSize = size( watches, 1 );
%
%-- Init with length
watchesStatsDB = cell(dataSize, 1);
batsStatsDB = cell(dataSize, 1);
crownsStatsDB = cell(dataSize, 1);
bricksStatsDB = cell(dataSize, 1);
applesStatsDB = cell(dataSize, 1);
keysStatsDB = cell(dataSize, 1);
forksStatsDB = cell(dataSize, 1);
pencilsStatsDB = cell(dataSize, 1);
bonesStatsDB = cell(dataSize, 1);
fountainsStatsDB = cell(dataSize, 1);
hammersStatsDB = cell(dataSize, 1);

for i = 1 : dataSize
    watchesStatsDB{i} = regionprops(watches{i},'all');
    batsStatsDB{i} = regionprops(bats{i},'all');
    crownsStatsDB{i} = regionprops(crowns{i},'all');
    bricksStatsDB{i} = regionprops(bricks{i},'all');
    applesStatsDB{i} = regionprops(apples{i},'all');
    keysStatsDB{i} = regionprops(keys{i},'all');
    forksStatsDB{i} = regionprops(forks{i},'all');
    pencilsStatsDB{i} = regionprops(pencils{i},'all');
    bonesStatsDB{i} = regionprops(bones{i},'all');
    fountainsStatsDB{i} = regionprops(fountains{i},'all');
    hammersStatsDB{i} = regionprops(hammers{i},'all');
end

propName = 'Solidity';

hist( [ getFeatureVector(watchesStatsDB, propName), ...
        getFeatureVector(batsStatsDB, propName), ... 
        getFeatureVector(crownsStatsDB, propName), ...
        getFeatureVector(bricksStatsDB, propName), ... 
        getFeatureVector(applesStatsDB, propName), ... 
        getFeatureVector(keysStatsDB, propName), ...
        getFeatureVector(forksStatsDB, propName), ...
        getFeatureVector(pencilsStatsDB, propName), ...
        getFeatureVector(fountainsStatsDB, propName), ...
        getFeatureVector(hammersStatsDB, propName), ...
        getFeatureVector(bonesStatsDB, propName)
    ], 20);

legend('watch', 'bat', 'crown', 'brick', 'apple', 'key', 'fork', 'pencil', 'fountain', 'hammer', 'bone');
% 
% watchSTATS = watchStatsDB{1}
% batSTATS = batStatsDB{1}
% figure;
% 
% subplot(2, 2, 1);
% plot2D(watchStatsDB, 'Area', 'FilledArea');
% title( 'Watches 1' );
% subplot(2, 2, 2);
% plot2D(watchStatsDB, propName, 'Extent');
% title( 'Watches 2' );
% 
% subplot(2, 2, 3);
% plot2D(batStatsDB, 'Area', 'FilledArea');
% title( 'Bats 1' );
% subplot(2, 2, 4);
% plot2D(batStatsDB, propName, 'Extent');
% title( 'Bats 2' );
