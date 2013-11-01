function showHist(dataStruct, dataName, propName)
    
    dataSize = size(dataName, 2);
    c = ones(20, dataSize);

    for j = 1 : dataSize
        c(:, j) = getFeatureVector( dataStruct.(dataName{j}), propName) ;
    end

    hist(c);
    legend(dataName);
end