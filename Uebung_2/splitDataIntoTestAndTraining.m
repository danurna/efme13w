% Splits given data into test and training classes. 
% Creates new classes vector for each created set.
function [TRAINING, TRAININGCLASSES, TEST, TESTCLASSES] = splitDataIntoTestAndTraining(Dataset, Dataclasses, Trainingsfactor, Seed)
    % Get unique class identifiers
    classes = unique(Dataclasses);
    % Get number of unique classes
    nClasses = size(classes, 1);
    TEST = [];
    TESTCLASSES = [];
    TRAINING = [];
    TRAININGCLASSES = [];
        
    % for each class, split into test and training and append
    % to the output
    for i = 1:nClasses 
        classDataSet = Dataset(Dataclasses == classes(i),:);
        nRows = size(classDataSet, 1) % number of rows
        nSample = floor(Trainingsfactor*nRows) % number of samples
        s = RandStream('mt19937ar','Seed', Seed);
        rndIDX = randperm(s, nRows);
        %TRAINING
        newTrainingSample = classDataSet(rndIDX(1:nSample), :);
        TRAINING = [TRAINING; newTrainingSample];
        tmpTrainClasses = zeros(size(newTrainingSample, 1), 1);
        tmpTrainClasses(:) = classes(i);
        TRAININGCLASSES = [TRAININGCLASSES; tmpTrainClasses];
        %TEST
        newTestSample = classDataSet(rndIDX(nSample+1:end), :);
        TEST = [TEST; newTestSample];
        tmpTestClasses = zeros(size(newTestSample, 1), 1);
        tmpTestClasses(:) = classes(i);
        TESTCLASSES = [TESTCLASSES; tmpTestClasses];
    end

    

end