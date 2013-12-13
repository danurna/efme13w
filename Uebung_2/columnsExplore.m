[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

bestColumns = [];

for a = 1:13
    correlation = abs(corrcoef(TRAIN));
    sort = zeros(13,1);
    sort(1)=a;
    total = 1:13;
    for i = 2 : 13
        correlation(:,sort(i-1)) = Inf;
        [~, ix] = min(correlation(sort(i-1),:));
        sort(i) = ix;
    end
   % figure(a);
   % parallelcoords(TRAIN(:,sort),'Group',TRAINCLASSES);
    disp(sort');
    bestColumns = [bestColumns; sort'];
end
numberOfColumsToUse = 4;
maximumK = 10;
Effectivenesses = zeros(0);

for c = 1:size(bestColumns,1)
    fprintf('Taking %i row\n', c);
    for k = 1:maximumK
        fprintf('Using %i-NN', k);
        [SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns(c,1:numberOfColumsToUse)), TRAIN(:,bestColumns(c,1:numberOfColumsToUse)), TRAINCLASSES, k, true);
        fprintf('\tKNN errors: %d Effectiveness %f\n', nnz(~(SAMPLECLASSES == TRAINCLASSES)), EFFECTIVENESS)
        Effectivenesses = [Effectivenesses; EFFECTIVENESS];
    end
    
end

plot(1:size(bestColumns,1)*maximumK, Effectivenesses);