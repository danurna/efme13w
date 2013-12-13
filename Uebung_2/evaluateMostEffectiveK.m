function [bestK effectiveness] = evaluateMostEffectiveK(TEST, TESTCLASSES, TRAIN, TRAINCLASSES, highestK)

elements = numel(TESTCLASSES);

effective = zeros(1,elements-1);

effectiveness = 0;

for i = 1:numel(highestK)
    
    k = highestK(i);
    if i == 1
       [knnCLASSES dist] = knn(TEST, TRAIN, TRAINCLASSES, k, false);
    else
       knnCLASSES = knn(TEST, TRAIN, TRAINCLASSES, k, false, dist); 
    end
    
    absolutDiff = nnz(~(TESTCLASSES == knnCLASSES));
    
    difference = absolutDiff/elements;
    effective(k) = 1-(difference);
    
    if effective(k) > effectiveness
        effectiveness = effective(k);
        bestK = k;
    end
    
end

end