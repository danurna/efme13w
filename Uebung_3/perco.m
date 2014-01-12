function [W, OUTPUT] = perco(INPUT, TARGET, MAXEPOCH)

N = size(INPUT,2);
W = repmat(0.1,size(INPUT,1),1);
gamma = 0.5;

OUTPUT = zeros(size(TARGET));

allGood = false;

count = 0;
while ( ~allGood && count < MAXEPOCH )
    allGood = true;
    
    for i = 1:N
        unWeighted = INPUT(:,i)*TARGET(i);
        if dot(W,unWeighted) < 0
            W = W + gamma*unWeighted;
            allGood = false;
        end
    end
    
    count = count +1;
end

if nargout > 1
    OUTPUT(i) = sign(dot(W,INPUT(:,i)));
end

end