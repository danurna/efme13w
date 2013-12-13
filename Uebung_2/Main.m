clear;

[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

%Split original Data into Train and Test Sets
trainSets = cell(1);
testSets = cell(1);
bestFeaturesPerSet = cell(1);
globalBestFeatures = cell(1);

trainFactors = [0.9 0.7 0.5];
numOfSets = numel(trainFactors);

for i = 1:numOfSets
    [TR, TRC, TS, TSC] = splitDataIntoTestAndTraining(TRAIN, TRAINCLASSES, ...
                            trainFactors(i), 1);
    
    trainStruct.data = TR;
    trainStruct.class = TRC;
    trainSets{i} = trainStruct;
    
    testStruct.data = TS;
    testStruct.class = TSC;
    testSets{i} = testStruct;
    
    bestFeaturesPerSet{i} = getBestColumns(TS,TSC,TR,TRC,'mahalanobis');
    %BESTFEATURESPERSET{i} = getBestColumns(TS,TSC,TR,TRC,'knn',1:30);
    
    if i ~= 1
        globalBestFeatures = intersect(globalBestFeatures,bestFeaturesPerSet{i}(:,4));
    else
        globalBestFeatures = bestFeaturesPerSet{i}(:,4);
    end
    
end

%Get minimum combination of Features, that classifies more than 95 per cent
%correctly. => find shortest string in cell array
%Source: http://www.mathworks.com/matlabcentral/answers/63551

val = cellfun(@(x) numel(x),globalBestFeatures);
out = globalBestFeatures(val==min(val));
bestColumns = str2num(out{1}); %#ok<ST2NM>


disp('# of missclassified Elements');
for i = 1 : numOfSets
    mahalResult = mahalClassify(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, true);
    knnResult = knn(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, 1);
    
    fprintf('\tTest Set %d (%d Elements in Total) Mahal: %d KNN: %d\n',...
                i, ...
                size(testSets{i}.data, 1), ...
                nnz(~(mahalResult == testSets{i}.class)), ...
                nnz(~(knnResult == testSets{i}.class))); 
end

%[bestColumns bestK] = getBestColumns(TRAIN,TRAINCLASSES,1:10);
%bestColumns = [1,7,10,11,13];
%bestK = 34;

[SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns), TRAIN(:,bestColumns), TRAINCLASSES, 1, true);

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

