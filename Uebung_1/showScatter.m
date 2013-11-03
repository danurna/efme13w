function showScatter(dataStruct, classNames, prop1, prop2)
    
    numberOfClasses = size(classNames, 2);
    c = ones(20*numberOfClasses, 2);
    classifiers = cell(20*numberOfClasses, 1);
    
    for j = 1 : numberOfClasses
        startValue = (j-1) * 20 + 1;
        endValue = j * 20;
        c( startValue:endValue, 1) = getFeatureVector( dataStruct.(classNames{j}), prop1);
        c( startValue:endValue, 2) = getFeatureVector( dataStruct.(classNames{j}), prop2);
        for i = startValue : endValue
            classifiers{i, 1} = classNames{j};
        end
        
    end

    figure;
    gscatter(c(:,1), c(:,2), classifiers, 'mcbry', 'o');
    legend('Location','SouthEastOutside');
    xlabel(prop1);
    ylabel(prop2);
end