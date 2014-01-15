function [W, count, bestClassified] = perco(INPUT, TARGET, MAXEPOCH, calcBest)

if(~exist('calcBest','var'))
    calcBest = false;
end

N = size(INPUT,2);
W = repmat(0.1,size(INPUT,1),1);
gamma = 0.5;

allGood = false;
count = 0;

bestW = W;
maxEffective = 0;


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