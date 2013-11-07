function testKNN(TRAIN, TRAINCLASSES)

elements = size(TRAINCLASSES,1);
k = 1:99;

matC = repmat(TRAINCLASSES(1),[elements,1]);

matlabtime = 0;
mytime_ = 0;

for i = 1 : numel(k);
    fprintf('k = %d\n',k(i));
    for j = 1:100
        ix = [1:j-1,j+1:100];
        
        tic;
        matC(j) = knnclassify(TRAIN(j,:),TRAIN(ix,:),TRAINCLASSES(ix),k(i));
        matlabtime = matlabtime + toc;
        
    end
    
    
    tic;
    myC_ = knn(TRAIN,TRAIN,TRAINCLASSES,k(i),true);
    mytime_ = mytime_ + toc;
    
    diffMatlab = 100*(nnz(~strcmp(matC,myC_))/elements);
    diffTrain = 100*(nnz(~strcmp(TRAINCLASSES,myC_))/elements);
    
    fprintf('\tdifference between matlab & ours): %d%%\n',diffMatlab);
    fprintf('\tdifference between trainSet & knn classifier): %d%%\n', diffTrain);
end
disp(strcat('My singlecall-time: ',num2str(mytime_)));
disp(strcat('Matlab time: ',num2str(matlabtime)));

end