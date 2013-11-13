function [TRAIN TRAINCLASSES] = importTrainingSet(trainingFile)

rawData = importdata(trainingFile);

TRAINCLASSES = rawData(:,1);
TRAIN = rawData(:,2:end);

end