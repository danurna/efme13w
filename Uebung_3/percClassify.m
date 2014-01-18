function CLASSES = percClassify(w,INPUT, noSign)

if(~exist('noSign','var'))
    noSign = false;
end


entities = size(INPUT,1);
homogen = ones(1,entities);
INPUT = vertcat(homogen,INPUT');


N = size(INPUT,2);
CLASSES = zeros(N,1);


for i = 1:N
    dotProduct = dot(w,INPUT(:,i));
    if noSign
        CLASSES(i) = dotProduct;
    else
        CLASSES(i) = sign(dotProduct);
    end
end

end