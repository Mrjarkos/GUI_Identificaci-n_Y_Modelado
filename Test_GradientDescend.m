%test
%close all
%clear all
data =  csvread("Sub2.csv");
tic
%theta = rand(1,5);
theta_min = [0    0    0.01    0   -1];
theta_max = [1    1    10*pi    1   1];
theta = [1    0.5    2*pi    2   -0.0432]
derivates = zeros(1, length(theta));
%t = data(:,1);
%y = data(:,3);
 t = 0:0.1:10;
 y = 1.*exp(-0.5.*t).*cos(2.*pi.*t)+2.*exp(-0.5.*t).*sin(2.*pi.*t);

%%Filter
order = 1;
y_filter = filter(ones(1, order)/order, 1, y); 
%t
%y_estimate = computefunction(t, theta, type);
%J = computeCost(y_estimate, y)
[y_norm, mu, sigma] = featureNormalize(y_filter);
%%Proces
alpha = 0.999;
delta = 0.05;
num_iters = 1000;
type = "1";
error = 0.00001;
[theta, J_history, iters] =  gradientDescent(t, y_norm, theta, alpha, delta, num_iters, type, error, theta_min, theta_max);
y_estimate = computefunction(t, theta, type);
iters
error = J_history(iters)*100
theta
toc
H = tfestimate(t,y);

figure(1)
subplot(221),plot(t, y ,t, y_filter), title("Y original vs Y filter")
subplot(222),plot(t, y_norm,t, y_estimate), title("Y filter vs Y estimado")
subplot(224),plot(t, y_estimate), title("Y estimado")
%subplot(222), plot(t,y_norm), title("Y norm")
%subplot(223), plot(t,y_estimate), title("Y estimate")
subplot(223), plot(1:iters, J_history(1:iters)), title("Cost function")