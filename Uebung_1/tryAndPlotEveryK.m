function tryAndPlotEveryK(TRAIN, TRAINCLASSES)

elements = numel(TRAINCLASSES);

effective = zeros(1,elements-1);
for k = 1:elements-1
    
    fprintf('k = %2d',k);
    knnCLASSES = knn(TRAIN,TRAIN,TRAINCLASSES,k,true);
    fprintf('\t%s\n','done');
    
    difference = nnz(~strcmp(TRAINCLASSES,knnCLASSES))/elements;
    effective(k) = 1-(difference);
    
end

plot(100*effective, 'b-o');
ylabel('Effectivness in %'); xlabel('k');

end