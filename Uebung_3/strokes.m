sep = repmat('#',1,60);
dispstat(sprintf('%s',sep),'keepprev','keepthis');
dispstat('STROKES','keepprev');

load('data/strokefeatures.mat');

TR = normalizeInput(features_class(:,1:20));

% Changing class labels so that dry is 1 (black lead), 2 (black chalk),
% 3 (silver point) and wet 4 (paint brush), 5 (reed pen), 6 (goose quill).
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


useBestFeaturesFound = true;
if( useBestFeaturesFound ) 
    clearvars out;
    out{1} = '1 10 13 16 17';
end

clearvars features_class;

sixClass = zeros(3,numel(out));
wets = sixClass;

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
    wets(1,j) = effective;
    
    fprintf('%.2f%% correct\n' , effective);
    
    
    fprintf('K-NN: ');
    
    knnResult = tryAndPlotEveryK(TS,wTSC,TR,wTRC);
    effective = max(knnResult);
    effective = 100*effective;
    wets(2,j) = effective;
    
    fprintf('%.2f%% correct\n' , effective);
    
    
    
    fprintf('Mahalanobis: ');
    
    mahalResult = mahalClassify(TS,TR,wTRC);
    effective = 100*nnz(mahalResult == wTSC)/numTS;
    wets(3,j) = effective;
    
    fprintf('%.2f%% correct\n' , effective);
    
    
    fprintf('\n%s\n#%45s%14s\n%s\n',sep,'Classifying between 6 classes','#',sep);
    
    fprintf('%-30s','K-NN: ');
    knnResults = tryAndPlotEveryK(TS,TSC,TR,TRC);
    [effective k] = max(knnResults);
    effective = 100*effective;
    sixClass(1,j) = effective;
    
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
    sixClass(2,j) = effective;
    
    fprintf('%.2f%% correct\n',effective);
    total = total + effective;
    
    %line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'r')
    %hold on;
    
    
    fprintf('%-30s', sprintf('Perceptron (%d Epochs): ', epoch));
    percResult = perceptron(TS,TR,TRC,epoch,true);
    
    classifiedIDX = percResult > 0;
    numUnclassified = numel(percResult(~classifiedIDX));
    numClassified = numTS-numUnclassified;
    
    classifiedResult = percResult(classifiedIDX);
    effective = 100*nnz(percResult == TSC)/numTS;
    
    classifiedEffective = 100*nnz(classifiedResult == TSC(classifiedIDX))/numClassified;
    classified = 100*numClassified/numTS;
    
    sixClass(3,j) = effective;
    
    
    
    fprintf('%.2f%%\n%-30s(only %.2f%% classified\n%-31s%.2f%% of which correctly)\n', ...
        effective, ' ', classified,' ', classifiedEffective);
    total = total + effective;
    
    %line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'g')
    %legend('K-NN','Mahalanobis','Perceptron');
    %hold off;
    
end

figure;
plot(wets(1,:), 'r-o'); hold on;
plot(wets(2,:), 'g-o'); hold on;
plot(wets(3,:), 'b-o'); 
legend('KNN','Mahalanobis','Perceptron'); hold off;


figure;

plot(sixClass(1,:), 'r-o'); hold on;
plot(sixClass(2,:), 'g-o'); hold on;
plot(sixClass(3,:), 'b-o'); 
legend('KNN','Mahalanobis','Perceptron'); hold off;

