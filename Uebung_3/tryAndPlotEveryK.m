function effective = tryAndPlotEveryK(TEST, TESTCLASSES, TRAIN, TRAINCLASSES)

%Checking effectiveness of each k
elements = numel(TESTCLASSES);

effective = zeros(1,elements-1);
for k = 1:elements-1
    
    if k == 1
       [knnCLASSES dist] = knn(TEST,TRAIN,TRAINCLASSES,k,isequal(TEST,TRAIN));
    else
       knnCLASSES = knn(TEST,TRAIN,TRAINCLASSES,k,isequal(TEST,TRAIN), dist); 
    end
    
    
    
    absolutDiff = nnz((TESTCLASSES == knnCLASSES));
    relative = absolutDiff/elements;
    effective(k) = relative;
    
end

figure;
plot(100*effective, 'b-o');
title('Effectivness of different classifiers');

xlabel('k');
ylabel('Effectivness in %');

end