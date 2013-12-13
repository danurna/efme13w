function [bestColumns bestK mostEffective] = getBestColumns(TRAIN, TRAINCLASSES, highestK)


colNum = size(TRAIN,2);
featureColumns = 1:colNum;

bestK = 0;
mostEffective = 0;
bestColumns = 1;


for i = 1:colNum
    
    chosenColumns = nchoosek(featureColumns,i);
    possibilities = size(chosenColumns,1);
    
    fprintf('Choose %d of %d features (%d possibilities)\n',i,colNum,possibilities);
    
    for j = 1:possibilities
        fprintf('Possibility %d of %d\n', j,possibilities);
        [k effectiveness] = evaluateMostEffectiveK(TRAIN(:,chosenColumns(j,:)), TRAINCLASSES, highestK);
        if effectiveness > mostEffective
            mostEffective = effectiveness;
            bestK = k;
            bestColumns = chosenColumns(j,:);
        end
        if mod(j,4) == 0
            clc
        end;
    end
    
end

disp(bestColumns);
disp(bestK);
disp(mostEffective);

end