function showScatter(DATA, DATACLASSES, labelx, labely)

    gscatter(DATA(:,1),DATA(:,2),DATACLASSES, 'mcbrg', 'o');
    xlabel(labelx);
    ylabel(labely);

end