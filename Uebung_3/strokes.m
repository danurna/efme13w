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
out = globalBestFeatures(val <= (3*maxFeatures)-1);
out = out(1);

%out = out(1:3);

clearvars features_class;


%bestFeautures = [1 3 5 7];

sixClass = zeros(3,numel(out));
wets = sixClass;

epoch = 100;
tic;
for j=1:numel(out)
    
    total = 0;
    
    
    bestFeatures = str2num(out{j}); %#ok<ST2NM>
    fprintf('INDEX = %d | Using following features: %s\n', j, sprintf('%d ',bestFeatures));
    fprintf('\n%s\n#%33s%26s\n%s\n',sep,'WET/DRY','#',sep);
    
    
    TR = TROrig(:,bestFeatures);
    TS = TSOrig(:,bestFeatures);
    
    numTR = numel(TRC);
    numTS = numel(TSC);
    
    
    
    [wTRC wTSC] = splitInTwo(TRC, TSC , @(x) x>3);
    
    fprintf('Perceptron (%d Epochs): ',epoch);
    
    percResult = perceptron(TS,TR,wTRC,epoch);
    percEffectiveWet = 100*nnz(percResult == wTSC)/numTS;
    wets(1,j) = percEffectiveWet;
    
    fprintf('%.2f%% correct\n' , percEffectiveWet);
    
    
    fprintf('K-NN: ');
    
    knnResultWet = tryAndPlotEveryK(TS,wTSC,TR,wTRC);
    knnEffectiveWet = max(knnResultWet);
    knnEffectiveWet = 100*knnEffectiveWet;
    wets(2,j) = knnEffectiveWet;
    
    fprintf('%.2f%% correct\n' , knnEffectiveWet);
    
    
    
    fprintf('Mahalanobis: ');
    
    mahalResult = mahalClassify(TS,TR,wTRC);
    mahalEffectiveWet = 100*nnz(mahalResult == wTSC)/numTS;
    wets(3,j) = mahalEffectiveWet;
    
    fprintf('%.2f%% correct\n' , mahalEffectiveWet);
    
    
    fprintf('\n%s\n#%45s%14s\n%s\n',sep,'Classifying between 6 classes','#',sep);
    
    fprintf('%-30s','K-NN: ');
    knnResultSix = tryAndPlotEveryK(TS,TSC,TR,TRC);
    [effective k] = max(knnResultSix);
    effective = 100*effective;
    sixClass(1,j) = effective;
    
    fprintf('%.2f%% maximum at k = %d\n' , effective, k);
    total = total + effective;
    
    fprintf('%-30s','Mahalanobis: ');
    
    mahalResult = mahalClassify(TS, TR, TRC);
    mahalEffectiveSix = 100*nnz(mahalResult == TSC)/numTS;
    sixClass(2,j) = mahalEffectiveSix;
    
    fprintf('%.2f%% correct\n',mahalEffectiveSix);
    total = total + mahalEffectiveSix;
    
    
    
    
    fprintf('%-30s', sprintf('Perceptron (%d Epochs): ', epoch));
    percResult = perceptron(TS,TR,TRC,epoch,true);
    
    classifiedIDX = percResult > 0;
    numUnclassified = numel(percResult(~classifiedIDX));
    numClassified = numTS-numUnclassified;
    
    classifiedResult = percResult(classifiedIDX);
    percEffectiveSix = 100*nnz(percResult == TSC)/numTS;
    
    classifiedEffective = 100*nnz(classifiedResult == TSC(classifiedIDX))/numClassified;
    classified = 100*numClassified/numTS;
    
    sixClass(3,j) = percEffectiveSix;
    
    
    
    fprintf('%.2f%%\n%-30s(only %.2f%% classified\n%-31s%.2f%% of which correctly)\n', ...
        percEffectiveSix, ' ', classified,' ', classifiedEffective);
    total = total + percEffectiveSix;
    
end
toc;

figure;

plot(100*knnResultWet, 'b-o'); hold on;
line([1 numTS],[mahalEffectiveWet mahalEffectiveWet], 'LineStyle','--', 'Color', 'r'); hold on;
line([1 numTS],[percEffectiveWet percEffectiveWet], 'LineStyle','--', 'Color', 'c');

legend('K-NN','Mahalanobis','Perceptron');
title('Effectivness of different classifiers WET/DRY');
xlabel('k');
ylabel('Effectivness in %');
hold off;

figure;
plot(100*knnResultSix, 'b-o');
line([1 numTS],[mahalEffectiveSix mahalEffectiveSix], 'LineStyle','--', 'Color', 'r'); hold on;
line([1 numTS],[classifiedEffective classifiedEffective], 'LineStyle','--', 'Color', 'c');
line([1 numTS],[100-classified 100-classified], 'LineStyle','--', 'Color', 'g');
legend('K-NN','Mahalanobis','Perceptron within classified','Perceptron unclassified');
title('Effectivness of different classifiers STROKES');
xlabel('k');
ylabel('Effectivness in %'); hold on;
hold off;

% figure;
% plot(wets(1,:), 'r-o'); hold on;
% plot(wets(2,:), 'g-o'); hold on;
% plot(wets(3,:), 'b-o');
% legend('KNN','Mahalanobis','Perceptron'); hold off;
%
%
% figure;
%
% plot(sixClass(1,:), 'r-o'); hold on;
% plot(sixClass(2,:), 'g-o'); hold on;
% plot(sixClass(3,:), 'b-o');
% legend('KNN','Mahalanobis','Perceptron'); hold off;

