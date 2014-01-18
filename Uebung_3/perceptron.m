function classified = perceptron(TS, TR, TRC, epoch, noSign)

if ~exist('noSign','var')
    noSign = false;
end


TS_entities = size(TS,1);
homogen = ones(1,TS_entities);
TS = vertcat(homogen,TS');

TR_entities = size(TS,1);
homogen = ones(1,TR_entities);
TR = vertcat(homogen,TR');


numClass = numel(unique(TRC));
results = zeros(size(TS,1),numClass);

if numClass > 2
    for i = 1 : numClass
        
        tmpTRC = splitInTwo(TRC, TRC, @(x) x==i);
        
        w = perco(TR,tmpTRC,epoch,true);
        result = percClassify(w,TS,noSign);
        
        results(:,i) = result;
        
    end
    
    [mx, classified] = max(results, [], 2);
    classified(mx<0) = -1;
else
    w = perco(TR,TRC,epoch,true);
    classified = percClassify(w,TS);
end





end