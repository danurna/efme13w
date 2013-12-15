function [] = discriminantFunction()
A = [1 2 2 3; 2 1 3 1];
B = [5 6 4; 2 3 4];
AMEAN = mean(A,2);
BMEAN = mean(B,2);

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

COEF = COEF(2,1);

K = COEF.const;
L = COEF.linear;
Q = COEF.quadratic;

range = [min(TRAIN(:,1)-1),max(TRAIN(:,1)+1),min(TRAIN(:,2)-1),max(TRAIN(:,2)+1)];

%Decision Boundary Function. Values from classify.
FUNCTION = sprintf('%d + %d*x + %d*y + %d*x.^2 + (%d+%d)*x.*y + %d*y.^2', K, L(1), L(2), Q(1,1), Q(1,2), Q(2,1), Q(2,2));
ezplot(FUNCTION,range);

%Line between mean vectors
FUNCTION = sprintf('%d*x + %d', M, B);
ezplot(FUNCTION,range);

%Decision Boundary Function using covarianz
h=ezplot('y = (1/88)*(-12*log(.5)+12*log(.75)-6*x^2-92*x+591)',range); hold on;

%Decision Boundary Function using identity matrix
g=ezplot('y = -2.4*x + 10.775',range);

set(g,'Color','k')
set(h,'Color','m')

%
