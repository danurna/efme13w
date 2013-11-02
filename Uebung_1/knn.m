function [testClassified] = knn(train, test, trainClassified, k)

    if nargin < 3
        error('knn expects at least 3 input arguments');
    elseif nargin == 3 %no k specified, standard value 1
        k = 1;
    end
    
    trainSize = size(train,1);
    testSize = size(test,1);
    
    if size(train,2) ~= size(test,2)
        error('training set and test must have same number of columns');
    end
    
    if trainSize ~= size(trainClassified,1)
        error('training set and training classified need to have same number of rows');
    end
    
    if k > trainSize
        fprintf('k(%d) bigger than training Set(%d)!\nreducing k to %d\n',k,trainSize,trainSize-1);
        
        k = trainSize-1;
    end
        
    testClassified = trainClassified(1:testSize);
    kClasses = trainClassified(1:k);
    
    dist = pdist2(test,train);
    
    for i = 1 : testSize
       for j = 1 : k
           [~, minIndex] = sort(dist(i,:));
           kClasses(k) = trainClassified(minIndex(k));
       end
       
       [uniqueValues, ~, valueMap] = unique(kClasses);
       [M, ~, C] = mode(valueMap);
       
       if size(C{1},1) > 1
           for j = 1 : k
              if ismember(valueMap(j),C{1})
                  M = valueMap(j);
              end
           end
       end
       
       testClassified(i) = uniqueValues(M);
       
    end
end
