% create predefined sine function
t = 0:1/144:5;
x = sin(t);
% Create daq session
s = daq.createSession('ni');
s.addAnalogInputChannel('Dev1',0,'Voltage');
% Create scatter plot to update in loop
h(1) = scatter(0,0,'b+');
hold on;
h(2) = scatter(0,0,'bo');
% Assign a time delay that, along with processing time, sets frequency around 144 Hz
time_delay = 0.001;
i = 1;
% Start Clock
tic;
while t(i) < t(end)
% Create small pause
while toc<time_delay
end
% Scan for voltage
data(i) = s.inputSingleScan;
% Set data values from scan and sine wave
set(h(1),'XData',data(i))
set(h(2),'XData',x(i))
% refresh graph
drawnow
end