function classified = perceptron(TEST, TRAIN, TRAINCLASSES, epoch, noSign)

if ~exist('noSign','var')
    noSign = false;
end

w = perco(TRAIN,TRAINCLASSES,epoch,true);
classified = percClassify(w,TEST,true,noSign);

end