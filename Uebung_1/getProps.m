function [props] = getProps(blob)
    
    props = regionprops(blob, 'all');
    n=size(props,1);
    if ( n > 1 )
       biggestArea = 0;
       biggestIndex = 1;
       for i = 1 : n
           currentArea = props(i,1).Area;
           if ( currentArea > biggestArea )
               biggestIndex = i;
               biggestArea = currentArea;
           end
       end
       
       props = props(biggestIndex,1);
    end
    
    props.formfactor = 4*pi*props.Area/(props.Perimeter)^2;
    props.roundness = 4*props.Area/(pi*props.MajorAxisLength^2);
    props.compactness = sqrt(props.roundness);
    props.aspectratio = props.MinorAxisLength/props.MajorAxisLength;

end