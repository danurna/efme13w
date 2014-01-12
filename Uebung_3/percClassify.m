function CLASSES = percClassify(w,INPUT)

N = size(INPUT,2);
CLASSES = zeros(N,1);


for i = 1:N
    CLASSES(i) = sign(dot(w,INPUT(:,i)));
end

end