dispstat(sprintf('\n\n\n%s',repmat('#',1,30)),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

TR = normalizeInput(features_class(:,1:20));

[TR TRC TS TSC] = splitDataIntoTestAndTraining( ...
    TR, ...
    features_class(:,21), ...
    0.5, ...
    1 ...
);


%Changing class labels so that dry is 1,2,3 and wet 4,5,6
TRC(TRC == 6) = -1;
TRC(TRC > 2) = TRC(TRC > 2) +1;
TRC(TRC == -1) = 3;

if (true)
   FeatureSelection(TR, TRC, TS, TSC) 
end

clearvars features_class;

bestFeautures = 1:10;

TR = TR(:,bestFeautures);
TS = TS(:,bestFeautures);

knnResult = knn(TS, TR, TRC, 1);
nnz(knnResult == TSC)

mahalResult = mahalClassify(TS, TR, TRC);
nnz(mahalResult == TSC)


wet = @(x) x>3;
paint = @(x) x==4;
pen = @(x) x==5;

lead = @(x) x==1;
chalk = @(x) x==2;

epoch = 200;


[wetDryTrainTarget wetDryTestTarget] = splitInTwo(TRC, ...
    TSC , wet);

wWet = perco(TR, wetDryTrainTarget,...
    epoch, true);


[paintTrainTarget paintTestTarget] = splitInTwo(TRC(wet(TRC)), ...
    TSC(wet(TSC)) , paint);

wPaint = perco(TR(wet(TRC),:), paintTrainTarget,...
    epoch, true);



[penTrainTarget penTestTarget] = splitInTwo(...
    TRC(and(wet(TRC), ~paint(TRC))), ...
    TSC(and(wet(TSC), ~paint(TSC))) , pen);

wPen = perco(TR(and(wet(TRC), ~paint(TRC)),:), penTrainTarget,...
    epoch, true);


[leadTrainTarget leadTestTarget] = splitInTwo(TRC(~wet(TRC)),...
    TSC(~wet(TSC)) , lead);

wLead = perco(TR(~wet(TRC),:), leadTrainTarget,...
    epoch, true);

[chalkTrainTarget chalkTestTarget] = splitInTwo(...
    TRC(and(~wet(TRC), ~lead(TRC))), ...
    TSC , chalk);

wChalk = perco(TR(and(~wet(TRC), ~lead(TRC)),:), chalkTrainTarget,...
    epoch, true);





