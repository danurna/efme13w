function tryAndPlotEveryK(TRAIN, TRAINCLASSES)

%Checking effectiveness of each k
disp('#####################################');
fprintf('%s\n\n','Checking effectiveness of each k');

elements = numel(TRAINCLASSES);

effective = zeros(1,elements-1);
tic;
for k = 1:elements-1
    
    fprintf('k = %2d',k);
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
    
    fprintf('\t%s / %3.2f%% Correctly classified\n','done', 100*effective(k));
    
    
end
toc;

plot(100*effective, 'b-o');
title('Effectivness of different k''s');

xlabel('k');
ylabel('Effectivness in %');

end