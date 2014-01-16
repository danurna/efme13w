dispstat(sprintf('\n\n\n%s',repmat('#',1,30)),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

TRAIN = normalizeInput(features_class(:,1:20));

[TRAIN TRAINCLASSES TEST TESTCLASSES] = splitDataIntoTestAndTraining( ...
    TRAIN, ...
    features_class(:,21), ...
    0.5, ...
    1 ...
);

clearvars features_class;

knnResult = knn(TEST(:,1:10), TRAIN(:,1:10), TRAINCLASSES, 1);
nnz(knnResult == TESTCLASSES)

mahalResult = mahalClassify(TEST(:,1:10), TRAIN(:,1:10), TRAINCLASSES);
nnz(mahalResult == TESTCLASSES)




PERCOTRAIN = vertcat(ones(size(TRAINCLASSES))',TRAIN');
PERCOTEST = vertcat(ones(size(TESTCLASSES))',TEST');

wetDecider = @(x) x>3;
paintDecider = @(x) x==4;
penDecider = @(x) x==5;

leadDecider = @(x) x==1;
chalkDecider = @(x) x==2;


[wetDryTrainTarget wetDryTestTarget] = splitInTwo(TRAINCLASSES, ...
    TESTCLASSES , wetDecider);


[w, count] = perco(PERCOTRAIN(1:11,:), wetDryTrainTarget,  200, true);
percResult = percClassify(w,PERCOTEST(1:11,:));
nnz(percResult == wetDryTestTarget)

