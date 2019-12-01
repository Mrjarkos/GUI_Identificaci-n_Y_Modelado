function J = computeCost(X, y)
%COMPUTECOST Compute cost for linear regression
m = length(y); % number of training examples
h = X;
sqrErrors = (h-y).^2;
J = 1/(2*m)*sum(sqrErrors);
end
