dispstat(sprintf('\n\n\n%s',repmat('#',1,30)),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

[TRAIN TRAINCLASSES TEST TESTCLASSES] = splitDataIntoTestAndTraining( ...
    features_class(:,1:20), ...
    features_class(:,21), ...
    0.8, ...
    1 ...
);

PERCOTRAIN = vertcat(ones(size(TRAINCLASSES))',TRAIN');
wetDryClasses = TRAINCLASSES;
wetDryClasses(TRAINCLASSES <= 3) = -1;
wetDryClasses(TRAINCLASSES > 3) = 1;

clearvars features_class;

knnResult = knn(TEST(:,1:10), TRAIN(:,1:10), TRAINCLASSES, 1);
nnz(knnResult == TESTCLASSES)

mahalResult = mahalClassify(TEST(:,1:10), TRAIN(:,1:10), TRAINCLASSES, false);
nnz(mahalResult == TESTCLASSES)

[w, out] = perco(PERCOTRAIN,wetDryClasses,1000);
