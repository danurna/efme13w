function simpleClassify(unclassifiedData, numberOfClasses)

    % Categorize data.
    classified = cell(20*numberOfClasses, 1);
    prop1 = ones(20*numberOfClasses, 1);
    prop2 = ones(20*numberOfClasses, 1);
    for j = 1 : size(unclassifiedData, 1)
        prop1(j) = unclassifiedData{j}.roundness;
        prop2(j) = unclassifiedData{j}.Solidity;

        if and(prop1(j) > 0.8, prop2(j) > 0.8)
            classified{j} = 'Apple';
        elseif and(prop1(j) > 0.45, prop2(j) > 0.7)
            classified{j} = 'Fountain';
        elseif and(prop1(j) > 0.22, prop2(j) > 0.65)
            classified{j} = 'Key';
        elseif and(prop1(j) > 0.05, prop2(j) > 0.65)
            classified{j} = 'Watch';
        else
            classified{j} = 'Hammer';
        end

    end

    hold on;
    gscatter(prop1, prop2, classified, 'mcbry', 'x');
    hold off;

end