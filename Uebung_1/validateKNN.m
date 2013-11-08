function validateKNN(TRAIN, TRAINCLASSES)

k = [1,2,5,10,15,25,35,50,70,99];
elements = numel(TRAINCLASSES);

k = k(k < elements);

matC = repmat(TRAINCLASSES(1),size(TRAINCLASSES));

matlabTime = 0;
ourTime = 0;

diff = zeros(1,numel(k));

disp('#####################################');
disp('Validating KNN by comparing to Matlab');
for i = 1 : numel(k);
    fprintf('k = %3d',k(i));
    
    %Matlab doesn't have LOOCV flag, we need to do it in a for loop
    for j = 1:elements
        ix = [1:j-1,j+1:elements]; %all indices except j
        
        tic;
        matC(j) = knnclassify(TRAIN(j,:),TRAIN(ix,:),TRAINCLASSES(ix),k(i));
        matlabTime = matlabTime + toc;
    end
    
    
    tic;
    ourC = knn(TRAIN,TRAIN,TRAINCLASSES,k(i),true);
    ourTime = ourTime + toc;
    
    diffMatlab = nnz(~strcmp(matC,ourC)); %count number of different classifications
    diff(i) = diffMatlab;
    
    fprintf('%30s\n','done');
    
end

fprintf('\nDifference between Matlab and ours: %d\n', sum(diff));

fprintf('Our time: %.3fs\n',ourTime);
fprintf('Matlab time: %.2fs\n\n',matlabTime);


end