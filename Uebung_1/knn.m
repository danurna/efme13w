function [SAMPLECLASSES] = knn(SAMPLE, TRAIN, TRAINCLASSES, K, LOOCV)
%KNN - Classify sample data based on k nearest neighbors in a given training set
%
%  Detailed 
%     Each row in SAMPLE gets a class in SAMPLECLASSES based on the
%     classification of the TRAIN set and TRAINCLASSES. Distances between
%     entry points are measured with euclidian method. When classifying to
%     more than two groups or when using an even value for K, it might be
%     necessary to break a tie in the number of nearest neighbors. The
%     algorithm uses the nearest neighbor among the tied groups to break
%     the tie. 
%
%  Syntax
%    Result = knn(SAMPLE, TRAIN, TRAINCLASSES, K, LOOCV)
%           SAMPLE - Matrix of Rows to classify
%           TRAIN  - Training set with known class
%           TRAINCLASSES  - Known Classes of TRAIN set
%           K - (Optional, default 1) specifies how many neighbors to look
%           at
%           LOOCV - (Optional, default false) if true ignores the closest
%           neighbor
%
%           Result - Classification of each SAMPLE row
%


    switch nargin
        case 3 %no k specified, standard value 1
            K = 1;
            LOOCV = false;
        case 4
            if(~isinteger(K) || K < 1)
               error('K must be an integer value bigger or equal to 1'); 
            end
            LOOCV = false;
        case 5
            if(~islogical(LOOCV))
                if ~(LOOCV == 1 || LOOCV == 0)
                    error('LOOCV flag must be a logical value');
                end
            end
        otherwise
            error('knn expects at least 3 input arguments');
    end
    
    trainSize = size(TRAIN,1);
    testSize = size(SAMPLE,1);
    
    if size(TRAIN,2) ~= size(SAMPLE,2)
        error('TRAIN and SAMPLE must have same number of columns');
    end
    
    if trainSize ~= size(TRAINCLASSES,1)
        error('TRAIN set and TRAINCLASSES must have same number of rows');
    end
    
    if K > trainSize-1
        fprintf('K(%d) bigger than TRAIN(%d)!\nreducing K to %d\n',K,trainSize,trainSize-1);
        
        K = trainSize-1;
    end
        
    SAMPLECLASSES = TRAINCLASSES(1:testSize);
    kClasses = TRAINCLASSES(1:K);
    
    dist = pdist2(SAMPLE,TRAIN);
    
    for i = 1 : testSize
       for j = 1 : K
           [~, minIndex] = sort(dist(i,:));
           ix = j;
           if LOOCV
               ix = j+1;
           end
           kClasses(j) = TRAINCLASSES(minIndex(ix));
       end
       
       [uniqueValues, ~, valueMap] = unique(kClasses);
       [M, ~, C] = mode(valueMap);
       
       if size(C{1},1) > 1
           for j = 1 : K
              if ismember(valueMap(j),C{1})
                  M = valueMap(j);
                  break;
              end
           end
       end
       
       SAMPLECLASSES(i) = uniqueValues(M);
       
    end
end
