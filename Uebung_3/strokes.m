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

clearvars features_class;


%bestFeautures = [1 3 5 7];

mxTot = 0;
mxIdx = -1;

for j=36%1:numel(out)
    
    total = 0;
    
    
    bestFeatures = str2num(out{j}); %#ok<ST2NM>
    fprintf('Using following features: %s\n',sprintf('%d ',bestFeatures));
    fprintf('\n%s\n#%33s%26s\n%s\n',sep,'WET/DRY','#',sep);
    
    
    TR = TROrig(:,bestFeatures);
    TS = TSOrig(:,bestFeatures);
    
    numTR = numel(TRC);
    numTS = numel(TSC);
    
    epoch = 100;
    
    fprintf('%s','Wet/Dry with Perceptron: ');
    [wTRC wTSC] = splitInTwo(TRC, TSC , @(x) x>3);
    percResult = perceptron(TS,TR,wTRC,epoch);
    effective = 100*nnz(percResult == wTSC)/numTS;
    if effective < 50
        continue;
    end
    
    fprintf('%.2f%% correct\n\n\n' , effective);
    
    wetDry = effective;
    
    fprintf('\n%s\n#%45s%14s\n%s\n',sep,'Classifying between 6 classes','#',sep);
    
    fprintf('%-30s','K-NN: ');
    knnResults = tryAndPlotEveryK(TS,TSC,TR,TRC);
    [effective k] = max(knnResults);
    effective = 100*effective;
    
    
    fprintf('%.2f%% maximum at k = %d\n' , effective, k);
    total = total + effective;
    
    %figure;
    %plot(100*knnResults, 'b-o');
    %title('Effectivness of different classifiers');
    %xlabel('k');
    %ylabel('Effectivness in %');
    %hold on;
    
    fprintf('%-30s','Mahalanobis: ');
    mahalResult = classify(TS, TR, TRC,'mahalanobis');
    effective = 100*nnz(mahalResult == TSC)/numTS;
    if effective < 50
        continue;
    end
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
    
    fprintf('%.2f%% correct\n%-30s(only %.2f%% classified)', ...
        effective,' ', 100*numClassified/numTS);
    total = total + effective;
    
    %line([1 numTS],[effective effective], 'LineStyle','--', 'Color', 'g')
    %legend('K-NN','Mahalanobis','Perceptron');
    %hold off;
    
    fprintf('\n\n%s\n',sep);
    fprintf('Added effectiveness = %.2f, Wet/Dry = %.2f, INDEX = %d', total, wetDry, j);
    if total > mxTot
        mxTot = total;
        mxIdx = j;
    end
    
    fprintf('\n%s\n',sep);
    
end

disp(mxTot);
disp(mxIdx);