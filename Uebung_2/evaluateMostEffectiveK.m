function [bestK effectiveness] = evaluateMostEffectiveK(TEST, TESTCLASSES, TRAIN, TRAINCLASSES, highestK)

elements = numel(TESTCLASSES);

effective = zeros(1,elements-1);

effectiveness = 0;

for i = 1:numel(highestK)
    
    k = highestK(i);
    if i == 1
       [knnCLASSES dist] = knn(TEST, TRAIN, TRAINCLASSES, k, isequal(TEST,TRAIN));
    else
       knnCLASSES = knn(TEST, TRAIN, TRAINCLASSES, k, isequal(TEST,TRAIN), dist); 
    end
    
    absolutDiff = nnz((TESTCLASSES == knnCLASSES));
    
    relative = absolutDiff/elements;
    effective(k) = relative;
    
    if effective(k) > effectiveness
        effectiveness = effective(k);
        bestK = k;
    end
    
end

end