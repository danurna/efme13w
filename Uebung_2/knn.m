function [SAMPLECLASSES, DIST, EFFECTIVENESS] = knn(SAMPLE, TRAIN, TRAINCLASSES, K, LOOCV, DIST)
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
    case 6
        
    otherwise
        error('knn expects 3 to 6 input arguments');
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

doEffectiveness = false;
if nargout>=3
    if isequal(TRAIN, SAMPLE)
        doEffectiveness = true;
    else
        fprintf('%s\n','Can only calculate effectiveness if TRAIN and SAMPLE are equal');
    end
end


%Pairwise euclidean distance between SAMPLE and TRAIN
%dist(i,j) is the distance between SAMPLE(i) and TRAIN(j)
if ~exist('dist','var') || isempty(DIST)
    DIST = pdist2(SAMPLE,TRAIN);
end


%(asc) sort each row from the distances from the to each train vector
[~, minIndexMatrix] = sort(DIST, 2);

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
% tic
% for i = 1 : testSize
% [FastModal] = fastmode(indexMap(i,:));
% end
% toc;

for i = 1 : testSize
    Modal = fastmode(indexMap(i,:));
    TieSize = size(Modal,1);
    if TieSize > 1
        %more than one modal value, break tie by choosing the nearest
        %of possible neighbor values
        firstIx = -1*ones(TieSize,1);
        for j = 1:TieSize
            firstIx(j) = find(indexMap(i,:)==Modal(j),1);
        end
        Modal = indexMap(i,min(firstIx));
    end
    
    SAMPLECLASSES(i) = uniqueValues(Modal);
end

if doEffectiveness
    if isnumeric(SAMPLECLASSES(1))
        misClassified = nnz(~(SAMPLECLASSES == TRAINCLASSES));
    else
        misClassified = nnz(~strcmp(SAMPLECLASSES , TRAINCLASSES));
    end
    EFFECTIVENESS = 1-(misClassified/testSize);
end

end
