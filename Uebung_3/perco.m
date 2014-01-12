function [W, OUTPUT] = perco(INPUT, TARGET, MAXEPOCH)

N = size(INPUT,2);
W = zeros(1,size(INPUT,1));
gamma = 0.5;

OUTPUT = zeros(size(TARGET));

count = 0;
while ( ~isequal(OUTPUT,TARGET) && count < MAXEPOCH )
    for i = 1:N
        unWeighted = INPUT(:,i)*TARGET(i);
        OUTPUT(i) = dot(W,unWeighted);
        if OUTPUT(i) < 0
            W = W + gamma*unWeighted;
        end
    end
    
    count = count +1;
end


end