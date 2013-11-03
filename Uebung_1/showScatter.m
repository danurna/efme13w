function showScatter(DATA, DATACLASSES, labelx, labely)
%showScatter plots a gscatter() - plot with sorted dataclasses, so that the
%coloring will be the same as long as the DATACLASSES have the same
%elements

    [sortedClasses ix] = sort(DATACLASSES);
    dataByClasses = DATA(ix,:);

    gscatter(dataByClasses(:,1),dataByClasses(:,2),sortedClasses, 'mcbrg');
    legend('Location','NorthWest');
    xlabel(labelx);
    ylabel(labely);

end