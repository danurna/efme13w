dispstat(sprintf('\n\n\n%s',repmat('#',1,30)),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

[TRAIN TRAINCLASSES TEST TESTCLASSES] = splitDataIntoTestAndTraining( ...
    features_class(:,1:20), ...
    features_class(:,21), ...
    0.5, ...
    1 ...
);

PERCOTRAIN = vertcat(ones(size(TRAINCLASSES))',TRAIN');

wetDryTrain = TRAINCLASSES;
wetDryTrain(TRAINCLASSES <= 3) = -1;
wetDryTrain(TRAINCLASSES > 3) = 1;

PERCOTEST = vertcat(ones(size(TESTCLASSES))',TEST');
wetDryTest = TESTCLASSES;
wetDryTest(TESTCLASSES <= 3) = -1;
wetDryTest(TESTCLASSES > 3) = 1;

clearvars features_class;

knnResult = knn(TEST(:,1:10), TRAIN(:,1:10), TRAINCLASSES, 1);
nnz(knnResult == TESTCLASSES)

mahalResult = mahalClassify(TEST(:,1:10), TRAIN(:,1:10), TRAINCLASSES, false);
nnz(mahalResult == TESTCLASSES)

[w, out, count] = perco(PERCOTRAIN(1:11,:),wetDryTrain,5000);
percResult = percClassify(w,PERCOTEST(1:11,:));
nnz(percResult == wetDryTest)

