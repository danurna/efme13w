clear; 
watches = read_images('watch');
bats = read_images('bat');
dataSize = size( watches, 1 );

%-- Init with length
watchStatsDB = cell(dataSize, 1);
batStatsDB = cell(dataSize, 1);
for i = 1 : dataSize
    watchStatsDB{i} = regionprops(watches{i},'all');
    batStatsDB{i} = regionprops(bats{i},'all');
end

watchSTATS = watchStatsDB{1}
batSTATS = batStatsDB{1}
figure;

subplot(2, 2, 1);
plot2D(watchStatsDB, 'Area', 'FilledArea');
title( 'Watches 1' );
subplot(2, 2, 2);
plot2D(watchStatsDB, 'Solidity', 'Extent');
title( 'Watches 2' );

subplot(2, 2, 3);
plot2D(batStatsDB, 'Area', 'FilledArea');
title( 'Bats 1' );
subplot(2, 2, 4);
plot2D(batStatsDB, 'Solidity', 'Extent');
title( 'Bats 2' );
