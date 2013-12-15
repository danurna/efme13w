function tryAndPlotEveryK(TEST, TESTCLASSES, TRAIN, TRAINCLASSES)

%Checking effectiveness of each k
disp('#####################################');
fprintf('%s\n\n','Checking effectiveness of each k');

elements = numel(TESTCLASSES);

effective = zeros(1,elements-1);
tic;
for k = 1:elements-1
    
    fprintf('k = %2d',k);
    if k == 1
       [knnCLASSES dist] = knn(TEST,TRAIN,TRAINCLASSES,k,isequal(TEST,TRAIN));
    else
       knnCLASSES = knn(TEST,TRAIN,TRAINCLASSES,k,isequal(TEST,TRAIN), dist); 
    end
    
    
    
    absolutDiff = nnz((TESTCLASSES == knnCLASSES));
    relative = absolutDiff/elements;
    effective(k) = relative;
    
    fprintf('\t%s / %3.2f%% Correctly classified\n','done', 100*effective(k));
    
    
end
toc;

figure;
plot(100*effective, 'b-o');
title('Effectivness of different k''s');

xlabel('k');
ylabel('Effectivness in %');

end