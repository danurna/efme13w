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


%Changing class labels so that dry is 1,2,3 and wet 4,5,6
TRAINCLASSES(TRAINCLASSES == 6) = -1;
TRAINCLASSES(TRAINCLASSES > 2) = TRAINCLASSES(TRAINCLASSES > 2) +1;
TRAINCLASSES(TRAINCLASSES == -1) = 3;

clearvars features_class;

bestFeautures = 1:10;

TRAIN = TRAIN(:,bestFeautures);
TEST = TEST(:,bestFeautures);

knnResult = knn(TEST, TRAIN, TRAINCLASSES, 1);
nnz(knnResult == TESTCLASSES)

mahalResult = mahalClassify(TEST, TRAIN, TRAINCLASSES);
nnz(mahalResult == TESTCLASSES)


wet = @(x) x>3;
paint = @(x) x==4;
pen = @(x) x==5;

lead = @(x) x==1;
chalk = @(x) x==2;

epoch = 200;


[wetDryTrainTarget wetDryTestTarget] = splitInTwo(TRAINCLASSES, ...
    TESTCLASSES , wet);

wWet = perco(TRAIN, wetDryTrainTarget,...
    epoch, true);


[paintTrainTarget paintTestTarget] = splitInTwo(TRAINCLASSES(...
    wet(TRAINCLASSES)), TESTCLASSES , paint);

wPaint = perco(TRAIN(wet(TRAINCLASSES),:), paintTrainTarget,...
    epoch, true);



[penTrainTarget penTestTarget] = splitInTwo(...
    TRAINCLASSES(and(wet(TRAINCLASSES), ~paint(TRAINCLASSES))), ...
    TESTCLASSES , pen);

wPen = perco(TRAIN(and(wet(TRAINCLASSES), ~paint(TRAINCLASSES)),:), paintTrainTarget,...
    epoch, true);


[leadTrainTarget leadTestTarget] = splitInTwo(TRAINCLASSES(...
    ~wet(TRAINCLASSES)), TESTCLASSES , lead);

wLead = perco(TRAIN, paintTrainTarget,...
    epoch, true);

[chalkTrainTarget chalkTestTarget] = splitInTwo(...
    TRAINCLASSES(and(~wet(TRAINCLASSES), ~lead(TRAINCLASSES))), ...
    TESTCLASSES , chalk);

wChalk = perco(TRAIN, paintTrainTarget,...
    epoch, true);





