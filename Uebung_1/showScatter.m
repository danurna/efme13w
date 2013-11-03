function showScatter(DATA, DATACLASSES, labelx, labely)

    gscatter(DATA(:,1),DATA(:,2),DATACLASSES, 'mcbrg');
    legend('Location','NorthWest');
    xlabel(labelx);
    ylabel(labely);

end