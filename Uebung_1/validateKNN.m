function validateKNN(TRAIN, TRAINCLASSES)

k = [1,2,5,10,15,25,35,50,70,99, 110, 119];
elements = numel(TRAINCLASSES);

k = k(k < elements);

matC = repmat(TRAINCLASSES(1),size(TRAINCLASSES));

matlabTime = 0;
ourTime = 0;

diff = zeros(1,numel(k));

disp('#####################################');
for i = 1 : numel(k);
    fprintf('k = %3d',k(i));
    for j = 1:elements
        ix = [1:j-1,j+1:elements];
        
        tic;
        matC(j) = knnclassify(TRAIN(j,:),TRAIN(ix,:),TRAINCLASSES(ix),k(i));
        matlabTime = matlabTime + toc;
    end
    
    
    tic;
    ourC = knn(TRAIN,TRAIN,TRAINCLASSES,k(i),true);
    ourTime = ourTime + toc;
    
    diffMatlab = nnz(~strcmp(matC,ourC));
    diff(i) = diffMatlab;
    
    fprintf('%30s\n','done');
    
end
disp('#####################################');
fprintf('\nDifference between Matlab and ours: %d\n', sum(diff));

fprintf('Our time: %.3fs\n',ourTime);
fprintf('Matlab time: %.2fs\n\n',matlabTime);


end