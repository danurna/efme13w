function [TEST, TRAINING] = splitDataIntoTestAndTraining(Dataset, Trainingsfactor, Seed)

    nRows = size(Dataset); % number of rows
    nSample = floor(Trainingsfactor*nRows); % number of samples
    s = RandStream('mt19937ar','Seed', Seed);
    rndIDX = randperm(s, nRows); 

    newSample = data(rndIDX(1:nSample), :);
    

end