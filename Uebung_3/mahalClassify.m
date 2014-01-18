function [TESTCLASS dist] = mahalClassify(TEST, TRAIN, TRAINCLASSES, EQUALCOV)

if ~exist('EQUALCOV', 'var')
    EQUALCOV = true;
end



if nargin < 3
    error('%s\n\t%s\n\t%s\n\t%s\n\t%s%s', ...
        'mahalClassify expects at least 3 input Arguments:', ...
        '- A TEST Matrix', ...
        '- A TRAIN Matrix', ...
        '- A TRAINCLASSES Vector with Classes for each row in TRAIN', ...
        '- An optional boolean (default = true), which indicates if all ', ...
        'Classes should have the same Covariance Matrix');
end

if ~islogical(EQUALCOV)
    error('EQUALCOV must be a logical value');
end

if ~isvector(TRAINCLASSES)
    error('TRAINCLASSES must be a vector');
end

if size(TRAIN,2) ~= size(TEST,2)
    error('TRAIN and TEST must have same number of columns');
end

uniqueClasses = unique(TRAINCLASSES);
numOfClasses = numel(uniqueClasses);


Classes = cell(numOfClasses,1);


for i = 1 : numOfClasses
    Classes{i} = TRAIN(TRAINCLASSES == uniqueClasses(i),:);
end

[COVs MEANS] = computeInverse(Classes,EQUALCOV);

numOfTestValues = size(TEST, 1);

dist = Inf(numOfTestValues,1);
TESTCLASS = zeros(numOfTestValues,1);


for i = 1 : numOfClasses
    for j = 1 : numOfTestValues
        diff = (TEST(j,:)-MEANS{i});
        tmpDist = diff / COVs{i} * diff';
        
        if tmpDist < dist(j)
            dist(j) = tmpDist;
            TESTCLASS(j) = uniqueClasses(i);
        end
    end
end

end

function [COVs MEANS] = computeInverse(Classes, EQUALCOV)

numOfClasses = size(Classes,1);
MEANS = cell(numOfClasses,1);
COVs = cell(numOfClasses,1);
eqCOV = zeros(size(Classes{1},2));
N = 0;

for i = 1 : numOfClasses
    currentClass = Classes{i};
    currentMean = mean(currentClass);
    MEANS{i} = currentMean;
    
    if EQUALCOV
        N = N + size(currentClass,1);
        eqCOV = eqCOV + diag(var(currentClass));
    else
        COVs{i} = cov(currentClass);
    end
    
end

if EQUALCOV
    eqCOV = eqCOV ./ (N-1);
    COVs(1:numOfClasses) = {eqCOV};
end
end