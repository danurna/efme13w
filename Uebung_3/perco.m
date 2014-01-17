function [W, count, bestClassified] = perco(INPUT, TARGET, MAXEPOCH, calcBest, hasHomogenous)
%INPUT in following form: columns are features, lines are entities

entities = size(INPUT,1);

if( ~exist('hasHomogenous','var') )
    homogen = ones(1,entities);
    INPUT = vertcat(homogen,INPUT');
end

if(~exist('calcBest','var'))
    calcBest = false;
    if nargout > 2
       error('When trying to get bestClassified, calcBest must be set!'); 
    end
end

N = entities;
W = repmat(0.1,size(INPUT,1),1);
gamma = 0.5;

allGood = false;
count = 0;

bestW = W;
maxEffective = -1;

while ( ~allGood && count < MAXEPOCH )
    allGood = true;
    
    if calcBest
        classified = percClassify(W,INPUT);
        effective = nnz(classified == TARGET);
        if effective > maxEffective
            bestW = W;
            bestClassified = classified;
        end
    end
    
    for i = 1:N
        unWeighted = INPUT(:,i)*TARGET(i);
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