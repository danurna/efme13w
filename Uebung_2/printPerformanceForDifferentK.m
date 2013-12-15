function printPerformanceForDifferentK(testSets, trainSets, numOfSets, bestColumns)

fprintf('Test performance for different K values for bestColumns\n');
bestColumns

for k = 1 : 10 
    errorRate = 0;
    fprintf('KNN with k = %i\n', k);
    for i = 1 : numOfSets
        knnResult = knn(testSets{i}.data(:,bestColumns), trainSets{i}.data(:,bestColumns), trainSets{i}.class, k);
    
        totalKnn = nnz(knnResult == testSets{i}.class);
        relativeKnn = 100*(totalKnn/numel(testSets{i}.class));
    
        fprintf('\t %i. Set KNN %2.2f%%\n',...
                i, relativeKnn);      
        errorRate = errorRate + relativeKnn;
    end
    
    errorRate = 100 - errorRate/numOfSets;
    fprintf('\t Mean ErrorRate %2.2f%%\n\n', errorRate);
end

end