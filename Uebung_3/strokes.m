sep = repmat('#',1,60);
dispstat(sprintf('%s',sep),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

TR = normalizeInput(features_class(:,1:20));

%Changing class labels so that dry is 1,2,3 and wet 4,5,6

TRC = features_class(:,21);
TRC(TRC == 6) = -1;
TRC(TRC > 2) = TRC(TRC > 2) +1;
TRC(TRC == -1) = 3;

[TROrig TRC TSOrig TSC] = splitDataIntoTestAndTraining( ...
    TR, ...
    TRC, ...
    0.7, ...
    1 ...
    );

% if (false)
%     [mahalFeatures, knnFeatures, percoFeatures, globalBestFeatures] =
%     FeatureSelection(TROrig, TRC, TSOrig, TSC);
% else
%     load('bestFeatures.mat')
% end

maxFeatures = 5;
val = cellfun(@length, globalBestFeatures);
out = globalBestFeatures(val < (2*maxFeatures)+maxFeatures);

out = out(1:10);

clearvars features_class;


%bestFeautures = [1 3 5 7];

knns = zeros(1,numel(out));
mahals = knns;
percs = zeros(2,numel(out));
wets = knns;

for j=1:numel(out)
    
    total = 0;
    
    
    bestFeatures = str2num(out{j}); %#ok<ST2NM>
    fprintf('INDEX = %d | Using following features: %s\n', j, sprintf('%d ',bestFeatures));
    fprintf('\n%s\n#%33s%26s\n%s\n',sep,'WET/DRY','#',sep);
    
    
    TR = TROrig(:,bestFeatures);
    TS = TSOrig(:,bestFeatures);
    
    numTR = numel(TRC);
    numTS = numel(TSC);
    
    epoch = 100;
    
    
    [wTRC wTSC] = splitInTwo(TRC, TSC , @(x) x>3);
    
    fprintf('Perceptron (%d Epochs): ',epoch);
    
    percResult = perceptron(TS,TR,wTRC,epoch);
    effective = 100*nnz(percResult == wTSC)/numTS;
    wets(j) = effective;
    
    fprintf('%.2f%% correct\n' , effective);
    
    
    fprintf('K-NN: ');
    
    knnResult = tryAndPlotEveryK(TS,wTSC,TR,wTRC);
    effective = max(knnResult);
    effective = 100*effective;
    
    fprintf('%.2f%% correct\n' , effective);
    
    
    
    fprintf('Mahalanobis: ');
    
    mahalResult = mahalClassify(TS,TR,wTRC);
    
    effective = 100*nnz(mahalResult == wTSC)/numTS;
    
    fprintf('%.2f%% correct\n' , effective);
    
    
    fprintf('\n%s\n#%45s%14s\n%s\n',sep,'Classifying between 6 classes','#',sep);
    
    fprintf('%-30s','K-NN: ');
    knnResults = tryAndPlotEveryK(TS,TSC,TR,TRC);
    [effective k] = max(knnResults);
    effective = 100*effective;
    
    knns(j) = effective;
    
    fprintf('%.2f%% maximum at k = %d\n' , effective, k);
    total = total + effective;
    
    %figure;
    %plot(100*knnResults, 'b-o');
    %title('Effectivness of different classifiers');
    %xlabel('k');
    %ylabel('Effectivness in %');
    %hold on;
    
    fprintf('%-30s','Mahalanobis: ');
    
    mahalResult = mahalClassify(TS, TR, TRC);
    effective = 100*nnz(mahalResult == TSC)/numTS;
    mahals(j) = effective;
    
    fprintf('%.2f%% correct\n',effective);
    total = total + effective;
    
    %line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'r')
    %hold on;
    
    
    fprintf('%-30s', sprintf('Perceptron (%d Epochs): ', epoch));
    percResult = perceptron(TS,TR,TRC,epoch,true);
    
    classifiedIDX = percResult > 0;
    numUnclassified = numel(percResult(~classifiedIDX));
    numClassified = numTS-numUnclassified;
    
    percResult = percResult(classifiedIDX);
    effective = 100*nnz(percResult == TSC(classifiedIDX))/numClassified;
    
    percs(1,j) = effective;
    percs(2,j) = 100*numUnclassified/numTS;
    
    fprintf('%.2f%% correct\n%-30s(only %.2f%% classified)\n', ...
        effective,' ', 100*numClassified/numTS);
    total = total + effective;
    
    %line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'g')
    %legend('K-NN','Mahalanobis','Perceptron');
    %hold off;
    
end

figure;
plot(knns, 'b-o'); hold on;
plot(mahals, 'r-o'); hold on;
plot(percs(1,:), 'm-o'); hold on;
plot(percs(2,:), 'c--'); hold off;
legend('KNN','Mahalanobis','Perceptron','Perceptron - Unclassified');