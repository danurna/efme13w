clear; 
watches = read_images('watch', 'MPEG7_CE-Shape-1_Part_B');
bats = read_images('bat', 'MPEG7_CE-Shape-1_Part_B');

for i = 1 : size( watches, 1 )
    watchStatsDB{i} = regionprops(watches{i},'all');
    batStatsDB{i} = regionprops(bats{i},'all');
end
watchSTATS = watchStatsDB{1,1}
batSTATS = batStatsDB{1,1}
figure;

for j = 1 : 20
    watchArea{j} = cell2mat(watchStatsDB{1,j}.Area(0));
    watchFilledArea{j} = cell2mat(watchStatsDB{1,j}.FilledArea(0));
end
plot(watchArea,watchFilledArea,'--rs');
%-- Linien Art, r rot, s square