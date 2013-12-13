clear;

[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

%Split original Data into Train and Test Sets
TRAINSETS = cell(1);
TESTSETS = cell(1);
trainFactors = [0.9 0.75 0.5 0.3];
numOfSets = numel(trainFactors);

for i = 1:numOfSets
    [TR, TRC, TS, TSC] = splitDataIntoTestAndTraining(TRAIN, TRAINCLASSES, ...
                            trainFactors(i), i);
    
    trainStruct.data = TR;
    trainStruct.class = TRC;
    TRAINSETS{i} = trainStruct;
    
    testStruct.data = TS;
    testStruct.class = TSC;
    TESTSETS{i} = testStruct;
end


disp('# of missclassified Elements');
for i = 1 : numOfSets
    mahalResult = mahalClassify(TESTSETS{i}.data, TRAINSETS{i}.data, TRAINSETS{i}.class, true);
    knnResult = knn(TESTSETS{i}.data, TRAINSETS{i}.data, TRAINSETS{i}.class, 1);
    
    fprintf('\tTest Set %d (%d Elements in Total) Mahal: %d KNN: %d\n',...
                i, ...
                size(TESTSETS{i}.data, 1), ...
                nnz(~(mahalResult == TESTSETS{i}.class)), ...
                nnz(~(knnResult == TESTSETS{i}.class))); 
end

[bestColumns bestK] = getBestColumns(TRAIN,TRAINCLASSES,1);
%bestColumns = [1,7,10,11,13];
%bestK = 34;

[SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns), TRAIN(:,bestColumns), TRAINCLASSES, bestK, true);

elements = numel(TRAINCLASSES);
mahal = zeros(size(TRAINCLASSES));
matlabmahal = zeros(size(TRAINCLASSES));

for j = 1:elements
    ix = [1:j-1,j+1:elements]; %all indices except j
    mahal(j) = mahalClassify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix));
    matlabmahal(j) = classify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix),'mahalanobis');
end

fprintf('\tLOOCV (with best Feature combination) Mahal: %d KNN: %d\n', nnz(~(mahal == TRAINCLASSES)), nnz(~(SAMPLECLASSES == TRAINCLASSES)));
fprintf('\tLOOCV (with best Feature combination) MatlabMahal: %d KNN: %d\n', nnz(~(matlabmahal == TRAINCLASSES)), nnz(~(SAMPLECLASSES == TRAINCLASSES)));

%tryAndPlotEveryK(TRAIN(:,bestColumns), TRAINCLASSES);

