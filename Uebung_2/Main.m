clear;

[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

dispstat('','init'); % One time only initialization

%Split original Data into Train and Test Sets
trainSets = cell(1);
testSets = cell(1);
bestFeaturesPerSet = cell(1);
globalBestFeatures = cell(1);

trainFactors = [0.9 0.7 0.5];
numOfSets = numel(trainFactors);

for i = 1:numOfSets
    [TR, TRC, TS, TSC] = splitDataIntoTestAndTraining(TRAIN, TRAINCLASSES, ...
                            trainFactors(i), i);
    
    trainStruct.data = TR;
    trainStruct.class = TRC;
    trainSets{i} = trainStruct;
    
    testStruct.data = TS;
    testStruct.class = TSC;
    testSets{i} = testStruct;
    
    dispstat(sprintf('Finding best features for Test Set %d',i),'keepthis');
    
    %bestFeaturesPerSet{i} = getBestColumns(TS,TSC,TR,TRC,'mahalanobis');
    bestFeaturesPerSet{i} = getBestColumns(TS,TSC,TR,TRC,'knn',1:1);
    
    dispstat(sprintf('%s\n\n',repmat('-',1,37)),'keepthis','keepprev');
    
    if i ~= 1
        globalBestFeatures = intersect(globalBestFeatures,bestFeaturesPerSet{i}(:,4));
    else
        globalBestFeatures = bestFeaturesPerSet{i}(:,4);
    end
    
end

% Find the best (=least) combination of columns from intersected features.
bestColumns = [];
shortest = Inf;

for i = 1:size(globalBestFeatures,1)
    % Convert strings to values and compare the length
    columnsToTest = [str2num(globalBestFeatures{i})];
    if( size(columnsToTest, 2) < shortest )
       bestColumns = columnsToTest;
       shortest = size(bestColumns, 2);
    end
end

%Get minimum combination of Features, that classifies more than 95 per cent
%correctly. => find shortest string in cell array
%Source: http://www.mathworks.com/matlabcentral/answers/63551

%val = cellfun(@(x) numel(x),globalBestFeatures);
%out = globalBestFeatures(val==min(val));
%bestColumns = str2num(out{1}); %#ok<ST2NM>




disp('Effectiveness (percentage of correctly classified elements) of different classifiers on different test sets');
for i = 1 : numOfSets
    mahalResult = mahalClassify(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, true);
    knnResult = knn(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, 1);
    
    totalMahal = nnz(mahalResult == testSets{i}.class);
    relativeMahal = 100*(totalMahal/numel(testSets{i}.class));
    
    totalKnn = nnz(knnResult == testSets{i}.class);
    relativeKnn = 100*(totalKnn/numel(testSets{i}.class));
    
    fprintf('\tSet %d: Mahalanobis %2.2f%% | KNN %2.2f%% \n',...
                i, ...
                relativeMahal, ...
                relativeKnn); 
end

%[bestColumns bestK] = getBestColumns(TRAIN,TRAINCLASSES,1:10);
%bestColumns = [1,7,10,11,13];
%bestK = 34;
bestColumns = 1:13;

[SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns), TRAIN(:,bestColumns), TRAINCLASSES, 1, true);

elements = numel(TRAINCLASSES);
mahal = zeros(size(TRAINCLASSES));
matlabmahal = zeros(size(TRAINCLASSES));

for j = 1:elements
    ix = [1:j-1,j+1:elements]; %all indices except j
    mahal(j) = mahalClassify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix));
    matlabmahal(j) = classify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix),'mahalanobis');
end

fprintf('\n%s\n','Effectiveness for leave-one-out-cross-validation on whole data set');
fprintf('\t%-20s %2.2f%% (equal covariance for each class)\n','Our Mahalanobis:',100*nnz(mahal == TRAINCLASSES)/elements);
fprintf('\t%-20s %2.2f%%\n','Matlab Mahalanobis: ', 100*nnz(matlabmahal == TRAINCLASSES)/elements);
fprintf('\t%-20s %2.2f%%\n','KNN:',100*nnz(SAMPLECLASSES == TRAINCLASSES)/elements);

%tryAndPlotEveryK(TRAIN(:,bestColumns), TRAINCLASSES);

