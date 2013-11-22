function TESTCLASS = mahalClassify(TEST, TRAIN, TRAINCLASSES, EQUALCOV)

if ~exist('EQUALCOV', 'var')
    EQUALCOV = true;
end

if nargin < 3
    error('%s\n\t%s\n\t%s\n\t%s\n\t%s', ...
        'mahalClassify expects at least 3 input Arguments:', ...
        '- A TEST Matrix', ...
        '- A TRAIN Matrix', ...
        '- A TRAINCLASSES Vector with Classes for each row in TRAIN', ...
        '- An optional boolean (default = true), which indicates if all Classes should have the same Covariance Matrix');
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

MEANS = cell(numOfClasses,1);
COVs = cell(numOfClasses,1);


for i = 1 : numOfClasses
    classI = TRAIN(TRAINCLASSES == uniqueClasses(i),:);
    COVs{i} = cov(classI);
    MEANS{i} = mean(classI);
end
INVC = computeInverse(COVs,EQUALCOV);

numOfTestValues = size(TEST, 1);

dist = Inf(numOfTestValues,1);
TESTCLASS = zeros(numOfTestValues,1);


for i = 1 : numOfClasses
    for j = 1 : numOfTestValues
        diff = (TEST(j,:)-MEANS{i});
        tmpDist = diff * INVC{i} * diff';
        
        if tmpDist < dist(j)
            dist(j) = tmpDist;
            TESTCLASS(j) = i;
        end
    end
end

end

function INVC = computeInverse(COVs, EQUALCOV)

INVC = COVs;

numOfCOVs = size(COVs,1);

if EQUALCOV
    
    COV = zeros(size(COVs{1}));
    for i = 1 : numOfCOVs
        COV = COV + COVs{i};
    end
    COV = COV / numOfCOVs;
    
    INVC(1:3) = {diag(diag(inv(COV)))};
    
else
    for i = 1 : numOfCOVs
        INVC{i} = inv(COVs{i});
    end
end
end
