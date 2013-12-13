[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

for a = 1:13
    correlation = corrcoef(TRAIN);
    sort = zeros(13,1);
    sort(1)=a;
    total = 1:13;
    for i = 2 : 13
        correlation(:,sort(i-1)) = -Inf;
        [~, ix] = max(correlation(sort(i-1),:));
        sort(i) = ix;
    end
    figure(a);
    parallelcoords(TRAIN(:,sort),'Group',TRAINCLASSES);
    disp(sort');
end