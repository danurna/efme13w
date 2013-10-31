% Creates and plots a 2d plot with given data for 
% the two given parameters
function plot2D(regionpropsCells, prop1, prop2)
    dataSize = size(regionpropsCells);

    %-- Init with length
    prop1data = cell(dataSize);
    prop2data = cell(dataSize);
    for j = 1 : dataSize
        prop1data{j} = regionpropsCells{j}.(prop1);
        prop2data{j} = regionpropsCells{j}.(prop2);
    end

    %-- Linien Art, r rot, s square
    %-- plot (x, y) 
    plot(cell2mat(prop1data), cell2mat(prop2data), '--rs');

    xlabel(prop1);
    ylabel(prop2);
end