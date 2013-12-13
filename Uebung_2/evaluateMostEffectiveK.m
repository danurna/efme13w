function [bestK effectiveness] = evaluateMostEffectiveK(TRAIN, TRAINCLASSES, highestK)

elements = numel(TRAINCLASSES);

effectiveness = 0;
bestK = 0;

effective = zeros(1,elements-1);
tic;
for k = 1:highestK
    
    if k == 1
       [knnCLASSES dist] = knn(TRAIN,TRAIN,TRAINCLASSES,k,true);
    else
       knnCLASSES = knn(TRAIN,TRAIN,TRAINCLASSES,k,true, dist); 
    end
    
    if isnumeric(knnCLASSES(1))
        absolutDiff = nnz(~(TRAINCLASSES == knnCLASSES));
    else
        absolutDiff = nnz(~strcmp(TRAINCLASSES,knnCLASSES));
    end
    difference = absolutDiff/elements;
    effective(k) = 1-(difference);
    
    if effective(k) > effectiveness
        effectiveness = effective(k);
        bestK = k;
    end
    
end
toc;
fprintf('%s\n\n','#####################################');

end