clear;

[TRAIN, TRAINCLASSES] = importTrainingSet('wine.data');

featureColumns = 1:13;

% bestK = 0;
% mostEffective = 0;
% bestColumns = 1;
% 
% for i = 1:13
%     
%     chosenColumns = nchoosek(featureColumns,i);
%     possibilities = size(chosenColumns,1);
%     
%     fprintf('Choose %d of 13 features (%d possibilities)\n',i,possibilities);
%     
%     for j = 1:possibilities
%         fprintf('Possibility %d of %d\n', j,possibilities);
%         [k effectiveness] = evaluateMostEffectiveK(TRAIN(:,chosenColumns(j,:)), TRAINCLASSES);
%         if effectiveness > mostEffective
%             mostEffective = effectiveness;
%             bestK = k;
%             bestColumns = chosenColumns(j,:);
%         end
%         if mod(j,4) == 0
%             clc
%         end;
%     end
%     
% end
% 
% disp(bestColumns);
% disp(bestK);
% disp(mostEffective);

bestColumns = [1,7,10,11,13];
bestK = 34;

[SAMPLECLASSES, ~, EFFECTIVENESS] = knn(TRAIN(:,bestColumns), TRAIN(:,bestColumns), TRAINCLASSES, bestK, true);

tryAndPlotEveryK(TRAIN(:,bestColumns), TRAINCLASSES);