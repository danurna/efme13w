function [W, count, bestClassified] = perco(HOMOGENIZED, TARGET, MAXEPOCH, calcBest)
%INPUT in following form: columns are features, lines are entities

if(~exist('calcBest','var'))
    calcBest = false;
    if nargout > 2
        error('When trying to get bestClassified, calcBest must be set!');
    end
end

N = size(HOMOGENIZED,2);
W = repmat(0.1,size(HOMOGENIZED,1),1);
gamma = 0.5;

allGood = false;
count = 0;

bestW = W;
maxEffective = -1;

while ( ~allGood && count < MAXEPOCH )
    allGood = true;
    
    if calcBest
        classified = percClassify(W,HOMOGENIZED);
        effective = nnz(classified == TARGET);
        if effective >= maxEffective
            maxEffective = effective;
            bestW = W;
            bestClassified = classified;
        end
    end
    
    for i = 1:N
        unWeighted = HOMOGENIZED(:,i)*TARGET(i);
        
        if dot(W,unWeighted) < 0
            W = W + gamma*unWeighted;
            allGood = false;
        end
    end
    
    
    
    count = count +1;
end

if calcBest
    W = bestW;
end

end