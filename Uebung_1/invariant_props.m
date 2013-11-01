function [I] = invariant_props(regionprops)
    I.formfactor = 4*pi*regionprops.Area/(regionprops.Perimeter)^2;
    I.roundness = 4*regionprops.Area/(pi*regionprops.MajorAxisLength^2);
    I.compactness = sqrt(I.roundness);
    I.aspectratio = regionprops.MinorAxisLength/regionprops.MajorAxisLength;
end