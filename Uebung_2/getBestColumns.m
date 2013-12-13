function [bestColumns bestK mostEffective] = getBestColumns(TRAIN, TRAINCLASSES, highestK)


colNum = size(TRAIN,2);
featureColumns = 1:colNum;

bestK = cell(1);
bestColumns = cell(1);
mostEffective = 0;

totalPossibilities = 0;
for i = 1:colNum
    totalPossibilities = totalPossibilities + nchoosek(colNum,i);
end
done = 0;

for i = 1:colNum
    
    chosenColumns = nchoosek(featureColumns,i);
    possibilities = size(chosenColumns,1);
    
    for j = 1:possibilities
        fprintf('Possibility %d of %d\n', j+done,totalPossibilities);
        [k effectiveness] = evaluateMostEffectiveK(TRAIN(:,chosenColumns(j,:)), TRAINCLASSES, highestK);
        if effectiveness >= mostEffective
            mostEffective = effectiveness;
            nextCell = size(bestK,2);
            bestK{nextCell} = k;
            bestColumns{nextCell} = chosenColumns(j,:);
        end
        if mod(j,4) == 0
            clc
        end;
    end
    done = done + j;
    
end

disp(bestColumns);
disp(bestK);
disp(mostEffective);

end