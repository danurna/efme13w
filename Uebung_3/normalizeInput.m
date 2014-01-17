function TRAIN = normalizeInput(INPUT)

means = INPUT(:,[1 2 4 5 7 9]);
vars = INPUT(:,[11 13 14 15 16 17]);

m = size(means,1);

minColumns = min(means);
minMatrix = repmat(minColumns, [m 1]);
diff = max(means) - minColumns;
diff = repmat(diff, [m 1]);    

means = (means-minMatrix)./diff;
vars = (vars-minMatrix)./diff;

TRAIN = horzcat(means, vars);

end