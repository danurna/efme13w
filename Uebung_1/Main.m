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
    watchesStatsDB{i} = getProps(watches{i});
    batsStatsDB{i} = getProps(bats{i});
    crownsStatsDB{i} = getProps(crowns{i});
    bricksStatsDB{i} = getProps(bricks{i});
    applesStatsDB{i} = getProps(apples{i});
    keysStatsDB{i} = getProps(keys{i});
    forksStatsDB{i} = getProps(forks{i});
    pencilsStatsDB{i} = getProps(pencils{i});
    bonesStatsDB{i} = getProps(bones{i});
    fountainsStatsDB{i} = getProps(fountains{i});
    hammersStatsDB{i} = getProps(hammers{i});
end

propName = 'formfactor';

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
