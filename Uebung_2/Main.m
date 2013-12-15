clear;

[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

dispstat('','init'); % One time only initialization

titles = ['KNN', 'Mahalanobis'];

calculateFeatures = false;


%Split original Data into Train and Test Sets
trainSets = cell(1);
testSets = cell(1);
bestFeaturesPerSet = cell(1);
globalBestFeatures = cell(1);

trainFactors = [0.8 0.6 0.5];
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
    
    if calculateFeatures
        dispstat(sprintf('Finding best features for Test Set %d',i),'keepthis');
        
        mahalFeatures = getBestColumns(TS,TSC,TR,TRC,'mahalanobis');
        knnFeatures = getBestColumns(TS,TSC,TR,TRC,'knn',1:20);
        
        tmp = intersect(mahalFeatures(:,4), knnFeatures(:,4));
        tmp2 = cell(numel(tmp)*2,4);
        for x = 1:numel(tmp)
            r = 2*x;
            tmp2(r-1,:) = knnFeatures(strcmp(knnFeatures(:,4),tmp(x)),:);
            tmp2(r,:) = mahalFeatures(strcmp(mahalFeatures(:,4),tmp(x)),:);
        end
        bestFeaturesPerSet{i} = tmp2;
        
        
        if i ~= 1
            globalBestFeatures = intersect(globalBestFeatures,bestFeaturesPerSet{i}(:,4));
        else
            globalBestFeatures = bestFeaturesPerSet{i}(:,4);
        end
        dispstat(sprintf('%s\n\n',repmat('-',1,37)),'keepthis','keepprev');        
    end
    
end

if ~calculateFeatures
    line = '##############################################';
    line1 = '   Feature calculation has been turned off';
    line2 = '   to save you some time. Using pre ';
    line3 = '   calculated data instead.';
    line4 = '   To do the calculation, set';
    line5 = '   calculateFeatures in LINE 8 to TRUE';
    
    fprintf(' #%-46s#\n #%-46s#\n #%-46s#\n #%-46s#\n #%-46s#\n #%-46s#\n #%-46s#\n #%-46s#\n',line, line1, line2, line3,'', line4, line5, line);
    load('bestFeaturesResultsK_1_20');
end


%Get minimum combination of Features, that classifies more than 95 per cent
%correctly. => find shortest string in cell array
%Source: http://www.mathworks.com/matlabcentral/answers/63551

val = cellfun(@(x) numel(x),globalBestFeatures);
out = globalBestFeatures(val==min(val));
%print our best columns choice.
bestColumns = str2num(out{1}) %#ok<ST2NM>


disp('Effectiveness (percentage of correctly classified elements) of different classifiers on different test sets');
for i = 1 : numOfSets
    mahalResult = mahalClassify(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, true);
    
    k = cell2mat(bestFeaturesPerSet{i}(strcmp(bestFeaturesPerSet{i}(:,4),out{1}),2));
    k = max(k);
    
    knnResult = knn(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, k);
    
    totalMahal = nnz(mahalResult == testSets{i}.class);
    relativeMahal = 100*(totalMahal/numel(testSets{i}.class));
    
    totalKnn = nnz(knnResult == testSets{i}.class);
    relativeKnn = 100*(totalKnn/numel(testSets{i}.class));
    
    fprintf('\tSet %d: Mahalanobis %2.2f%% | KNN %2.2f%% (k: %d)\n',...
        i, ...
        relativeMahal, ...
        relativeKnn, k);
end

printPerformanceForDifferentK(testSets, trainSets, numOfSets, bestColumns);

%[bestColumns bestK] = getBestColumns(TRAIN,TRAINCLASSES,1:10);
%bestColumns = [1,7,10,11,13];
%bestK = 34;

[SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns), TRAIN(:,bestColumns), TRAINCLASSES, 1, true);

elements = numel(TRAINCLASSES);
mahalFeatures = zeros(size(TRAINCLASSES));
matlabmahal = zeros(size(TRAINCLASSES));

for j = 1:elements
    ix = [1:j-1,j+1:elements]; %all indices except j
    mahalFeatures(j) = mahalClassify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix));
    matlabmahal(j) = mahalClassify(TRAIN(j,bestColumns),TRAIN(ix,bestColumns),TRAINCLASSES(ix), false);
end

fprintf('\n%s\n','Effectiveness for leave-one-out-cross-validation on whole data set');
fprintf('\t%-15s %2.2f%% (equal covariance for each class)\n','Mahalanobis:',100*nnz(mahalFeatures == TRAINCLASSES)/elements);
fprintf('\t%-15s %2.2f%% (different covariance for each class)\n','Mahalanobis: ', 100*nnz(matlabmahal == TRAINCLASSES)/elements);
fprintf('\t%-15s %2.2f%%\n','KNN:',100*nnz(SAMPLECLASSES == TRAINCLASSES)/elements);

discriminantFunction;
