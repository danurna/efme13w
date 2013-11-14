function [TRAIN TRAINCLASSES] = importTrainingSet(trainingFile)

if ~exist('trainingFile','var') || isempty(trainingFile)
  trainingFile = 'wine.data';
end

rawData = importdata(trainingFile);

TRAINCLASSES = rawData(:,1);
TRAIN = rawData(:,2:end);

m = size(TRAIN,1);

minColumns = min(TRAIN);
minMatrix = repmat(minColumns, [m 1]);
diff = max(TRAIN) - minColumns;
diff = repmat(diff, [m 1]);    

TRAIN = (TRAIN-minMatrix)./diff;

end