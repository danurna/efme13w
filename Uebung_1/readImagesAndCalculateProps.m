function s = readImagesAndCalculateProps(filenames)

warning off MATLAB:warn_r14_stucture_assignment
    for j = 1 : size(filenames, 2)
        %- Read images
        s.(filenames{j}) = read_images(filenames{j});
        
        %- Calculate properties for each image
        for i = 1 : size(s.(filenames{j}), 1)
            s.(filenames{j}){i} = getProps(s.(filenames{j}){i});
        end
    end
warning on MATLAB:warn_r14_stucture_assignment
    
end