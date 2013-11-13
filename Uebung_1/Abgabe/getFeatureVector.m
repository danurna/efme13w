% Creates and plots a 2d plot with given data for 
% the two given parameters
function [featureVector] = getFeatureVector(regionpropsCells, prop1)
    dataSize = size(regionpropsCells);

    %-- Init with length
    prop1data = cell(dataSize);
    
    for j = 1 : dataSize
        prop1data{j} = regionpropsCells{j}.(prop1);
    end
    
    featureVector = cell2mat(prop1data);
end