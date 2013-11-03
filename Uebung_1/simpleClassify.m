function classified = simpleClassify(sampleData, numberOfClasses)
%simpleClassify - Classify sample data based on hardcoded classification values 
%
%  Detailed 
%     Each row in sampleData contains a regionprops+ cell. For each
%     cell we extract the FORMFACTOR and ROUNDNESS to classify the 
%     the sample entry and save the result inside our classified vector.
%
%  Syntax
%    Result = simpleClassify(sampleData, numberOfClasses)
%           sampleData - Matrix of Rows to classify
%           numberOfClasses  - Number of different classes inside the the
%           sampleData
%
%           Result - Properties used for classification and 
%           classification of each sampleData row.
%

    % Setup variables with correct size.
    classified = cell(20*numberOfClasses, 1);
    prop1 = ones(20*numberOfClasses, 1);
    prop2 = ones(20*numberOfClasses, 1);
    
    % Iterate over each row in sampleData
    for j = 1 : size(sampleData, 1)
        % Extract features of interest
        prop1(j) = sampleData(j,1); %formfactor
        prop2(j) = sampleData(j,2); %roundness

        % Classify 
        if and(prop1(j) > 0.4, prop2(j) > 0.8)
            classified{j} = 'apple';
        elseif and(prop1(j) > 0.3, prop2(j) > 0.45)
            classified{j} = 'fountain';
        elseif and(prop1(j) > 0.4, prop2(j) > 0.25)
            classified{j} = 'brick';
        elseif and(prop1(j) > 0.2, prop2(j) > 0.05)
            classified{j} = 'watch';
        else
            classified{j} = 'fork';
        end

    end

end