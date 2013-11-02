function testKNN()
    training = [mvnrnd([ 1  1],   eye(2), 100); ...
                mvnrnd([-1 -1], 2*eye(2), 100)];
    group = [ones(100,1); repmat(2,100,1)];
    sample = unifrnd(-5, 5, 100, 2);
    % Classify the sample using the nearest neighbor classification


    for k = 1 : 10
        figure;
        gscatter(training(:,1),training(:,2),group,'mc'); hold on;
        legend('Training Class 1', 'Training Class 2');
        title(k);

        c = knnclassify(sample, training, group,k);
        gscatter(sample(:,1),sample(:,2),c,'mc','x'); hold on;
        legend('Training Class 1', 'Training Class 2', ...
            'Matlab knn Class 1', 'Matlab knn Class 2');
        
        myC = knn(sample, training, group,k);
        gscatter(sample(:,1),sample(:,2),myC,'mc','o'); hold off;
        legend('Training Class 1', 'Training Class 2', ...
            'Matlab knn Class 1', 'Matlab knn Class 2', ...
            'MY knn Class 1', 'MY knn Class 2', ...
            'Location','SouthEastOutside');

    end
end