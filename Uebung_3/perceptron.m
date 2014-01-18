function classified = perceptron(TS, TR, TRC, epoch, noSign)

if ~exist('noSign','var')
    noSign = false;
end

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
    %classified(mx<0) = -1;
else
    w = perco(TR,TRC,epoch,true);
    classified = percClassify(w,TS);
end





end