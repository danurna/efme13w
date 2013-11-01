function [I] = read_images(filename)
    l = length(filename);
    directoryPath = 'MPEG7_CE-Shape-1_Part_B';
    D = dir('MPEG7_CE-Shape-1_Part_B') ;
    I = cell( 20 , 1 ) ;
    j = 1;
    
    dirSeparator = '\';
    if(isunix || ismac)
        dirSeparator = '/';
    end
    
    for i = 1 : size( D, 1 )
        if D( i ).isdir == 0 && strncmp( D( i ).name( 1 : l ) , filename , l);
            %disp( D( i ).name ) ;
            I_temp = imread ( [directoryPath dirSeparator D( i ).name] ) ;
            I{j} = bwlabel(im2bw( I_temp , graythresh ( I_temp ) )) ;
            j = j + 1;
        end
    end
end