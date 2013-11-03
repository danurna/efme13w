function testKNN(TRAIN, TRAINCLASSES)

k = [1,2,3,5,10,15,20,25];
diff = zeros(1,numel(k));

for i = 1 : numel(k);
    fprintf('k = %d\n',k(i));
    for j = 1:100
        ix = [1:j-1,j+1:100];
        
        matC = knnclassify(TRAIN(ix,:),TRAIN,TRAINCLASSES,k(i));
        myC = knn(TRAIN(ix,:),TRAIN,TRAINCLASSES,k(i));
        diff(i) = diff(i) + nnz(~strcmp(matC,myC));
    end
    fprintf('difference between matlab knn and our knn: %d\n\n',diff(i));
end
end