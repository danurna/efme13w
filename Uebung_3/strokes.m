dispstat(sprintf('\n\n\n%s',repmat('#',1,30)),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

TR = normalizeInput(features_class(:,1:20));


[TR TRC TS TSC] = splitDataIntoTestAndTraining( ...
    TR, ...
    features_class(:,21), ...
    0.8, ...
    1 ...
);

%Changing class labels so that dry is 1,2,3 and wet 4,5,6

TRC = features_class(:,21);
TRC(TRC == 6) = -1;
TRC(TRC > 2) = TRC(TRC > 2) +1;
TRC(TRC == -1) = 3;


[TR TRC TS TSC] = splitDataIntoTestAndTraining( ...
    TR, ...
    TRC, ...
    0.8, ...
    1 ...
);

if (true)
   FeatureSelection(TR, TRC, TS, TSC); 
end


clearvars features_class;

bestFeautures = 1:10;

TR = TR(:,bestFeautures);
TS = TS(:,bestFeautures);

numTR = numel(TRC);
numTS = numel(TSC);

knnResult = knn(TS, TR, TRC, 1);
effective = nnz(knnResult == TSC)/numTS

mahalResult = mahalClassify(TS, TR, TRC);
effective = nnz(mahalResult == TSC)/numTS


wet = @(x) x>3;
epoch = 1000;

[wTRC wTSC] = splitInTwo(TRC, TSC , wet);
percResult = perceptron(TS,TR,wTRC,epoch);
effective = nnz(percResult == wTSC)/numTS


names = {'lead','chalk','point','paint','pen','quill'};
results = zeros(numTS,6);

for i = 1 : 6
    
    [tmpTRC tmpTSC] = splitInTwo(TRC,TSC, @(x) x==i);
    result = perceptron(TS,TR,tmpTRC,epoch,true);
    effective = nnz(sign(result) == tmpTSC)/numTS;
    fprintf('%s: %.2f\n',names{i},effective);
    
    results(:,i) = result;
    
end

[~, percResult] = max(results, [], 2);
effective = nnz(percResult == TSC)/numTS
