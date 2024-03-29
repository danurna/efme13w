function tryAndPlotEveryK(TRAIN, TRAINCLASSES)

%Checking effectiveness of each k
disp('#####################################');
fprintf('%s\n\n','Checking effectiveness of each k');

elements = numel(TRAINCLASSES);

effective = zeros(1,elements-1);
tic;
for k = 1:elements-1
    
    fprintf('k = %2d',k);
    knnCLASSES = knn(TRAIN,TRAIN,TRAINCLASSES,k,true);
    
    difference = nnz(~strcmp(TRAINCLASSES,knnCLASSES))/elements;
    effective(k) = 1-(difference);
    
    fprintf('\t%s / %3.0f%% Correctly classified\n','done', 100*effective(k));
    
    
end
toc;

plot(100*effective, 'b-o');
title('Effectivness of different k''s');

xlabel('k');
ylabel('Effectivness in %');

end