tic; % Start timer.
clear; 
watches = read_images('watch', 'MPEG7_CE-Shape-1_Part_B');
bats = read_images('bat', 'MPEG7_CE-Shape-1_Part_B');
dataSize = size( watches, 1 );

%-- Init with length
watchStatsDB = cell(1, dataSize);
batStatsDB = cell(1, dataSize);
for i = 1 : dataSize
    watchStatsDB{i} = regionprops(watches{i},'all');
    batStatsDB{i} = regionprops(bats{i},'all');
end

watchSTATS = watchStatsDB{1,1}
batSTATS = batStatsDB{1,1}
figure;

%-- Init with length
watchArea = cell(dataSize);
watchFilledArea = cell(dataSize);
for j = 1 : dataSize
    watchArea{j} = watchStatsDB{1,j}.Area;
    watchFilledArea{j} = watchStatsDB{1,j}.FilledArea;
end

%-- Init with length
batArea = cell(dataSize);
batFilledArea = cell(dataSize);
for j = 1 : dataSize
    batArea{j} = batStatsDB{1,j}.Area;
    batFilledArea{j} = batStatsDB{1,j}.FilledArea;
end

toc; % End timer.

%-- Linien Art, r rot, s square
%-- plot (x, y) 
subplot(1, 2, 1);
plot(cell2mat(watchArea), cell2mat(watchFilledArea), '--rs');

title('Watches');
xlabel('watchArea');
ylabel('watchFilledArea');

%--  Bats
subplot(1, 2, 2);
plot(cell2mat(batArea), cell2mat(batFilledArea), '--rs');

title('Bats');
xlabel('batArea');
ylabel('batFilledArea');