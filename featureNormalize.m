function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
mu = mean(X);
sigma = abs(max(X)-min(X));
X_norm = (X-mu)/sigma;
end
