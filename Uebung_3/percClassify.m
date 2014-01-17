function CLASSES = percClassify(w,INPUT, homogenize, noSign)

if(~exist('homogenize','var'))
    homogenize = false;
end

if(~exist('noSign','var'))
    noSign = false;
end

if homogenize
    entities = size(INPUT,1);
    homogen = ones(1,entities);
    INPUT = vertcat(homogen,INPUT');
end

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