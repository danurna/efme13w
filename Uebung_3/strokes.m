dispstat(sprintf('\n\n\n%s',repmat('#',1,60)),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

TR = normalizeInput(features_class(:,1:20));

%Changing class labels so that dry is 1,2,3 and wet 4,5,6

TRC = features_class(:,21);
TRC(TRC == 6) = -1;
TRC(TRC > 2) = TRC(TRC > 2) +1;
TRC(TRC == -1) = 3;


[TR TRC TS TSC] = splitDataIntoTestAndTraining( ...
    TR, ...
    TRC, ...
    0.7, ...
    1 ...
);

clearvars features_class;

bestFeautures = [1 3 7 8];

TR = TR(:,bestFeautures);
TS = TS(:,bestFeautures);

numTR = numel(TRC);
numTS = numel(TSC);

epoch = 100;

fprintf('%s','Wet/Dry with Perceptron: ');
[wTRC wTSC] = splitInTwo(TRC, TSC , @(x) x>3);
percResult = perceptron(TS,TR,wTRC,epoch);
effective = 100*nnz(percResult == wTSC)/numTS;
fprintf('%.2f%% correct\n' , effective);


fprintf('%s\nClassifying between 6 classes\n',repmat('#',1,60));

fprintf('%-30s','K-NN: ');
knnResults = tryAndPlotEveryK(TS,TSC,TR,TRC);
[effective k] = max(knnResults);
fprintf('%.2f%% maximum correctnes(k = %d)\n' , 100*effective, k);

hold on;

fprintf('%-30s','Mahalanobis: ');
mahalResult = classify(TS, TR, TRC,'mahalanobis');
effective = 100*nnz(mahalResult == TSC)/numTS;
fprintf('%.2f%% correct\n',effective);

line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'r')
hold on;

fprintf('%-30s', sprintf('Perceptron (%d Epochs): ', epoch));
results = zeros(numTS,6);

for i = 1 : 6
    
    [tmpTRC tmpTSC] = splitInTwo(TRC,TSC, @(x) x==i);
    result = perceptron(TS,TR,tmpTRC,epoch,true);
    results(:,i) = result;
    
end


[~, percResult] = max(results, [], 2);
effective = 100*nnz(percResult == TSC)/numTS;
fprintf('%.2f%% correct\n',effective);

line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'g')
legend('K-NN','Mahalanobis','Perceptron');
hold off;
