function [mahalFeatures, knnFeatures, percoFeatures, globalBestFeatures] = FeatureSelection(TRAIN, TRAINCLASSES, TEST, TESTCLASSES)

%PERCOTRAIN = vertcat(ones(size(TRAINCLASSES))',TRAIN');

wetDryTrain = TRAINCLASSES;
wetDryTrain(TRAINCLASSES <= 3) = -1;
wetDryTrain(TRAINCLASSES > 3) = 1;

%PERCOTEST = vertcat(ones(size(TESTCLASSES))',TEST');
wetDryTest = TESTCLASSES;
wetDryTest(TESTCLASSES <= 3) = -1;
wetDryTest(TESTCLASSES > 3) = 1;

TR = TRAIN;
TS = TEST;
TSC = wetDryTest;
TRC = wetDryTrain;
i = 0;
dispstat(sprintf('Finding best features for Test Set %d',i),'keepthis');
            
mahalFeatures = getBestColumns(TS,TSC,TR,TRC,'mahalanobis')
knnFeatures = getBestColumns(TS,TSC,TR,TRC,'knn',1:20)
percoFeatures = getBestColumns(TS, TSC, TR, TRC, 'perceptron')
      
        tmp = intersect(mahalFeatures(:,4), knnFeatures(:,4));
        tmp2 = cell(numel(tmp)*2,4);
        for x = 1:numel(tmp)
            r = 2*x;
            tmp2(r-1,:) = knnFeatures(strcmp(knnFeatures(:,4),tmp(x)),:);
            tmp2(r,:) = mahalFeatures(strcmp(mahalFeatures(:,4),tmp(x)),:);
        end
        bestFeaturesPerSet{i} = tmp2per
        
        
        if i ~= 1
            globalBestFeatures = intersect(globalBestFeatures,bestFeaturesPerSet{i}(:,4));
        else
            globalBestFeatures = bestFeaturesPerSet{i}(:,4);
        end
        dispstat(sprintf('%s\n\n',repmat('-',1,37)),'keepthis','keepFinding best features for Test Set 0');
        
        
end
