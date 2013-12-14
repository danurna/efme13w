function [bestCombinations mostEffective] = getBestColumns(TEST, TESTCLASSES, TRAIN, TRAINCLASSES, type, kInterval)


colNum = size(TRAIN,2);
featureColumns = 1:colNum;

bestCombinations = cell(1,4);
mostEffective = 0;

totalPossibilities = 0;
for i = 1:colNum
    totalPossibilities = totalPossibilities + nchoosek(colNum,i);
end

done = 0;
nextRow = 0;
blub = 0;

for i = 1:colNum
    
    chosenColumns = nchoosek(featureColumns,i);
    possibilities = size(chosenColumns,1);
    
    for j = 1:possibilities
        
        
        percentageDone = (j+done)/totalPossibilities*100;
        if percentageDone > blub*10;
            fprintf('currently at %.2f%%\n', percentageDone);
            blub = blub+1;
        end
        
        if strcmp(type,'mahalanobis')
            k = 1;
            mahalClasses = mahalClassify(...
                            TEST(:,chosenColumns(j,:)), ...
                            TRAIN(:,chosenColumns(j,:)), ...
                            TRAINCLASSES);
                        
            absolutDiff = nnz(~(TESTCLASSES == mahalClasses));
            difference = absolutDiff/numel(TESTCLASSES);
            
            effectiveness = 1-(difference);
            
        else
            [k effectiveness] = evaluateMostEffectiveK(...
                TEST(:,chosenColumns(j,:)), ...
                TESTCLASSES, ...
                TRAIN(:,chosenColumns(j,:)), ...
                TRAINCLASSES, kInterval);
        end
        
        if effectiveness >= 0.95 %empirisch
            if effectiveness > mostEffective
                mostEffective = effectiveness;
            end
            nextRow = nextRow+1;
            
            bestCombinations{nextRow,1} = effectiveness;
            bestCombinations{nextRow,2} = k;
            bestCombinations{nextRow,3} = chosenColumns(j,:);
            bestCombinations{nextRow,4} = num2str(chosenColumns(j,:),'%02d ');
            
        end
    end
    done = done + j;
    
end

end