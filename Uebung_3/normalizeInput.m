function TRAIN = normalizeInput(INPUT)

means = INPUT(:,1:5);
vars = INPUT(:,11:15);

m = size(means,1);

minColumns = min(means);
minMatrix = repmat(minColumns, [m 1]);
diff = max(means) - minColumns;
diff = repmat(diff, [m 1]);    

means = (means-minMatrix)./diff;
vars = (vars-minMatrix)./diff;

TRAIN = horzcat(means, vars);

end