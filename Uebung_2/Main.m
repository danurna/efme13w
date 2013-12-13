clear;

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
    sort'
end


[TR1, TRC1, TS1, TSC1] = splitDataIntoTestAndTraining(TRAIN, TRAINCLASSES, 0.75, 1);
[TR2, TRC2, TS2, TSC2] = splitDataIntoTestAndTraining(TRAIN, TRAINCLASSES, 0.75, 20);
[TR3, TRC3, TS3, TSC3] = splitDataIntoTestAndTraining(TRAIN, TRAINCLASSES, 0.75, 3);

mahal1 = mahalClassify(TS1, TR1, TRC1);
mahal2 = mahalClassify(TS2, TR2, TRC2);
mahal3 = mahalClassify(TS3, TR3, TRC3);

knn1 = knn(TS1,TR1,TRC1,1);
knn2 = knn(TS2,TR2,TRC2,1);
knn3 = knn(TS3,TR3,TRC3,1);

disp('# of missclassified Elements');
fprintf('\tTest Set 1 (%d Elements in Total) Mahal: %d KNN: %d\n',size(TS1, 1), nnz(~(mahal1 == TSC1)), nnz(~(knn1 == TSC1)));
fprintf('\tTest Set 2 (%d Elements in Total) Mahal: %d KNN: %d\n',size(TS2, 1), nnz(~(mahal2 == TSC2)), nnz(~(knn2 == TSC2)));
fprintf('\tTest Set 3 (%d Elements in Total) Mahal: %d KNN: %d\n',size(TS3, 1), nnz(~(mahal3 == TSC3)), nnz(~(knn3 == TSC3)));



bestColumns = [1,7,10,11,13];
bestK = 34;
%bestColumns = 1:13;
%bestK = 1;

[SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns), TRAIN(:,bestColumns), TRAINCLASSES, bestK, true);

elements = numel(TRAINCLASSES);
mahal = zeros(size(TRAINCLASSES));
matlabmahal = zeros(size(TRAINCLASSES));

for j = 1:elements
    ix = [1:j-1,j+1:elements]; %all indices except j
    mahal(j) = mahalClassify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix));
    matlabmahal(j) = classify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix),'mahalanobis');
end

fprintf('\tLOOCV (%d Elements in Total) Mahal: %d KNN: %d\n', size(TRAIN, 1), nnz(~(mahal == TRAINCLASSES)), nnz(~(SAMPLECLASSES == TRAINCLASSES)));
fprintf('\tLOOCV (%d Elements in Total) MatlabMahal: %d KNN: %d\n', size(TRAIN, 1), nnz(~(matlabmahal == TRAINCLASSES)), nnz(~(SAMPLECLASSES == TRAINCLASSES)));

%tryAndPlotEveryK(TRAIN(:,bestColumns), TRAINCLASSES);

