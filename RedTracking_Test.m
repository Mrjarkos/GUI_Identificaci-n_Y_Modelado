close all
clear all
clc

%% Definitions
global KEY_IS_PRESSED;
KEY_IS_PRESSED = 0;
gcf;

%Vision parameters
Hth_min = 0.27;
Sth_min = 0.3;
Vth_min = 0.5;
Hth_max = 0.67;
Sth_max = 1;
Vth_max = 1;
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 800, ...
                                'MaximumBlobArea', 50000, ...
                                'MaximumCount', 10);
hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ... % Set Red box handling
                                        'CustomBorderColor', [1 0 0], ...
                                        'Fill', true, ...
                                        'FillColor', 'Custom', ...
                                        'CustomFillColor', [1 0 0], ...
                                        'Opacity', 0.5);
%% Read the camvideo into MATLAB

cam = webcam;
buffer = 100;
t = zeros(1,buffer, 'double');
x = zeros(1,buffer, 'double');
y = zeros(1,buffer, 'double');
offsetx = 640/2;
offsety = 360/2;
cam.Resolution = '640x360';
%% Tracking
figure(1)
set(gcf, 'Position', get(0, 'ScreenSize')); %Maximize Figure
set(gcf, 'KeyPressFcn', @MKeyPressFcn);
tic %Set time
while ~KEY_IS_PRESSED
tiempo_inicio = cputime; %set time2
frameRGB = snapshot(cam);
frameHSV = rgb2hsv(frameRGB);

Hband = frameHSV(:,:, 1); %Hue
Sband = frameHSV(:,:, 2); %Saturacion
Vband = frameHSV(:,:, 3); %Value

HMask = (Hband < Hth_max)&(Hband > Hth_min);
SMask = (Sband < Sth_max)&(Sband > Sth_min);
VMask = (Vband < Vth_max)&(Vband > Vth_min);

% Combine the masks to find where all 3 are "true."
redObjectsMask = HMask & SMask & VMask;
[centroid, bbox] = step(hblob, redObjectsMask);
centroid = uint16(centroid);
frameRGB = step(hshapeinsRedBox, frameRGB, bbox); % Instert the red box
t = [t(2:buffer) toc];
if length(bbox(:,1)) == 1
    x = [x(2:buffer) (double(centroid(1,1))-offsetx)/640];
    y = [y(2:buffer) (double(centroid(1,2))-offsety)/360];
else
    x = [x(2:buffer) x(buffer)];
    y = [y(2:buffer) y(buffer)];
end
subplot(221);
imshow(frameRGB);
title('Original RGB Image');

subplot(222);
imshow(redObjectsMask, []);
title('Red Objects Mask');
subplot(223);
plot(x, t)
set(gca,'ylim',[t(1) t(buffer)])
xlabel('Elapsed time (sec)')
title('X position');

subplot(224);
plot(t, -y)
set(gca,'xlim',[t(1) t(buffer)])
xlabel('Elapsed time (sec)')
title('Y position');
total = cputime - tiempo_inicio;
freq = 1/total
end
clear all
close all
clc

function MKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
end
