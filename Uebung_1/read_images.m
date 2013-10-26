function [I] = read_images(filename, directoryPath)
    l = length(filename);
    
    D = dir(directoryPath) ;
    I = cell( 20 , 1 ) ;
    j = 1 ;
    for i = 1 : size( D, 1 )
        if D( i ).isdir == 0 && strncmp( D( i ).name( 1 : l ) , filename , l);
            %disp( D( i ).name ) ;
            I_temp = imread ( [directoryPath  '\' D( i ).name] ) ;
            I{j} = bwlabel(im2bw( I_temp , graythresh ( I_temp ) )) ;
            j = j +1;
            
        end
    end
end