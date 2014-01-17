function CLASSES = percClassify(w,INPUT, homogenize)

if(~exist('homogenize','var'))
    homogenize = false;
end

if homogenize
    entities = size(INPUT,1);
    homogen = ones(1,entities);
    INPUT = vertcat(homogen,INPUT');
end

N = size(INPUT,2);
CLASSES = zeros(N,1);


for i = 1:N
    CLASSES(i) = sign(dot(w,INPUT(:,i)));
end

end