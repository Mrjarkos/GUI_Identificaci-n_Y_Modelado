function [theta, J_history, iters] = gradientDescent(t, y, theta, alpha, delta, num_iters, type, error, theta_min, theta_max)
%GRADIENTDESCENT Performs gradient descent to learn theta
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);
derivates = zeros(1, length(theta));
iters = 0;
    for iter = 1:num_iters
        iters=iters+1;
        for i = 1:length(theta)
            theta_temp = theta;
            theta_temp(i) = theta(i)+delta;
            derivates(i) = computeCost(computefunction(t, theta, type), y) - computeCost(computefunction(t, theta_temp, type), y);
        end
        for i=1:length(theta)
            temp = theta(i) + derivates(i)*alpha;
            if temp> theta_min(i) && temp< theta_max(i)
                theta(i) = temp;
            end
        end
        % Save the cost J in every iteration
        y_teo=computefunction(t, theta, type);
        J_history(iter) = computeCost(y_teo, y);
        if J_history(iter)<error&& mean(derivates)<error 
            break;
        end
    end
end
