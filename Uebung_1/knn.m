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

SAMPLECLASSES = TRAINCLASSES(1);
SAMPLECLASSES = repmat(SAMPLECLASSES,testSize,1);

%Pairwise euclidean distance between SAMPLE and TRAIN
%dist(i,j) is the distance between SAMPLE(i) and TRAIN(j)
dist = pdist2(SAMPLE,TRAIN);

%(asc) sort each row from the distances from the to each train vector
[~, minIndexMatrix] = sort(dist, 2);

%if LOOCV, skip first.
kClasses = TRAINCLASSES(minIndexMatrix(:, 1+LOOCV : K+LOOCV));


%uniqueValues is selfexplanatory, indexMap is basically a numerical
%representation of kClasses.
%example:
%   when:
%       kClasses =
%           'a' 'b' 'a'
%           'a' 'b' 'a'
%   then:
%       uniqueValues = 
%           'a'
%           'b'
%       indexMap = 
%           1   2   1
%           1   2   1

[uniqueValues, ~, indexMap] = unique(kClasses);
indexMap = reshape(indexMap, testSize, K);

[Modal, ~, Tie] = mode(indexMap,2);

for i = 1 : testSize
    if size(Tie{i,1},1) > 1
        %more than one modal value, break tie by choosing the nearest
        %of possible neighbor values
        for j = 1 : K
            if ismember(indexMap(i,j),Tie{i,1})
                Modal(i) = indexMap(i,j);
                break;
            end
        end
    end
    
    SAMPLECLASSES(i) = uniqueValues(Modal(i));
end


end
