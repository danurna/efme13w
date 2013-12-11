A = [1 2 2 3; 2 1 3 1];
B = [5 6 4; 2 3 4];
AMEAN = mean(A');
BMEAN = mean(B');

TRAIN = [A';B'];
GROUP = [1,1,1,1,2,2,2];

%COEF gives us the coefficients for the decision boundary.
[CLASSIFIED, ~, ~, ~, COEF] = classify(TRAIN, TRAIN, GROUP, 'mahalanobis');
gscatter(TRAIN(:,1), TRAIN(:,2), GROUP);

hold on
gscatter(AMEAN(1), AMEAN(2), '.', 'b', '+', 10, 'off')
gscatter(BMEAN(1), BMEAN(2), '.', 'b', '+', 10, 'off')

% y = mx+b
M = (BMEAN(2) - AMEAN(2)) / (BMEAN(1) - AMEAN(1));
B = BMEAN(2) - M*BMEAN(1);

K = COEF(1,2).const
L = COEF(1,2).linear
Q = COEF(1,2).quadratic

%Decision Boundary Function. Values from classify.
FUNCTION = sprintf('%d + %d*x + %d*y + %d*x.^2 + (%d+%d)*x.*y + %d*y.^2', K, L(1), L(2), Q(1,1), Q(1,2), Q(2,1), Q(2,2))
ezplot(FUNCTION,[min(TRAIN(:,1)-1),max(TRAIN(:,1)+1),min(TRAIN(:,2)-1),max(TRAIN(:,2)+1)]);

%Line between mean vectors
FUNCTION = sprintf('%d*x + %d', M, B);
ezplot(FUNCTION,[min(TRAIN(:,1)-1),max(TRAIN(:,1)+1),min(TRAIN(:,2)-1),max(TRAIN(:,2)+1)]);
hold off
