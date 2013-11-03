function [SAMPLECLASSES] = knn(SAMPLE, TRAIN, TRAINCLASSES, K, LOOCV)
%KNN - Classify sample data based on k nearest neighbors in a given training set
%
%  Detailed 
%     Each row in SAMPLE gets a class in SAMPLECLASSES based on the
%     classification of the TRAIN set and TRAINCLASSES. Distances between
%     entry points are measured with euclidean method. When classifying to
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
            if(~isnumeric(K) || K < 1)
               error('K must be an numeric value bigger or equal to 1'); 
            end
            LOOCV = false;
        case 5
            if(~islogical(LOOCV))
                if ~(LOOCV == 1 || LOOCV == 0)
                    error('LOOCV flag must be a logical value');
                end
            end
        otherwise
            error('knn expects 3 to 5 input arguments');
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
    
    %Pairwise euclidean distance between SAMPLE and TRAIN
    %dist(i,j) is the distance between SAMPLE(i) and TRAIN(j)
    dist = pdist2(SAMPLE,TRAIN);
    
    for i = 1 : testSize
        %(asc) sort the distances from the sample i to each train vector
        [~, minIndex] = sort(dist(i,:));
        
        for j = 1 : K
            %collect classes for k nearest neighbors
            ix = j;
            
            if LOOCV
                %when doing LOOCV, distance 0 (same vector) is neglected
                ix = j+1;
            end
            kClasses(j) = TRAINCLASSES(minIndex(ix));
        end

        %uniqueValues is selfexplanatory, valueMap is basically a numerical
        %representation of kClasses.
        %example:
        %   when: kClasses = {'a','b','a'}
        %   then: uniqueValues = {'a','b'}
        %         valueMap = [1,2,1];
        [uniqueValues, ~, valueMap] = unique(kClasses);
        [M, ~, C] = mode(valueMap);
       
        if size(C{1},1) > 1
            %more than one modal value, choose the nearest neighbor of
            %modal values
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
