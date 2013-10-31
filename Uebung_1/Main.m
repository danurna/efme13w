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
    watchArea{j} = watchStatsDB{1,j}.Area;
    watchFilledArea{j} = watchStatsDB{1,j}.FilledArea;
end

for j = 1 : 20
    batArea{j} = batStatsDB{1,j}.Area;
    batFilledArea{j} = batStatsDB{1,j}.FilledArea;
end

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