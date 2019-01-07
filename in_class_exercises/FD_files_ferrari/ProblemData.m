clc
clear all
% Sampling time, stop time
Ts = 0.01;
Tstop = 1000;
Tdelay = 500;

% Real, physical parameters

tankCross = [0.156 0.156 0.156];
tankInit = [0 2.5 5];
tankMax = [10 10 10];
tankMin = [0 0 0];

pipeCross = [5 5 5]*1e-4;
pipeCoeff = [1 1 1];

% Inputs

pumpDCMag = [1.5 1.5]*1e-3;
pumpACPeriod = [10 50];
pumpACMagRelative = [0.1 0.25];

%Faults

faultTime = [1e6 1e6 400];
faultMag = [0 0 1];

% Measurement noise

peakNoise = tankMax*1e-2; % one percent on maximum
noiseRange = [-peakNoise ; +peakNoise];


% Nominal parameters

uncRelative = 10e-2; % ten percent on actual values

tankCrossN = makeParUncertain(tankCross,uncRelative);
tankInitN = makeParUncertain(tankInit,uncRelative);
tankMaxN = makeParUncertain(tankMax,uncRelative);
tankMinN = tankMin;

pipeCrossN = makeParUncertain(pipeCross,uncRelative);
pipeCoeffN = makeParUncertain(pipeCoeff,uncRelative);

% FD estimator parameters

Lambda = diag([0.91 0.91 0.91]);

time_delay = 0.5;
%%

simOut = sim("centralized_FD_basic_01_2017b.slx");
%% check if LFD observer without delay is the same as FD observer
clc
max_acceptable_deviation = 0.001;
max_deviation_delay = 0;
max_deviation_no_delay = 0;
flag = 0;
for i = 1:length(zero_check_no_delay)
    if zero_check_no_delay(i,1) ~= 0
        flag = 1;
        if max_deviation_delay <= abs(zero_check_no_delay(i,1))
            max_deviation_no_delay = abs(zero_check_no_delay(i,1));
        end
    end
    if zero_check_no_delay(i,2) ~= 0
        flag = 1;
        if max_deviation_delay <= abs(zero_check_no_delay(i,2))
            max_deviation_no_delay = abs(zero_check_no_delay(i,2));
        end
    end
    if zero_check_no_delay(i,3) ~= 0
        flag = 1;
        if max_deviation_delay <= abs(zero_check_no_delay(i,3))
            max_deviation_no_delay = abs(zero_check_no_delay(i,3));
        end
    end
end
if flag == 0
    disp("LFD observer without time delay is working correctly")
else
    disp("fault in LFD observer without time delay")
    disp("max deviation = " + max_deviation_no_delay + " liter")
end

flag = 0;
for i = 1:length(zero_check_delay)
    if abs(zero_check_delay(i,1)) >= max_acceptable_deviation
        flag = 1;
        if max_deviation_delay <= abs(zero_check_delay(i,1))
            max_deviation_delay = abs(zero_check_delay(i,1));
        end
    end
    if abs(zero_check_delay(i,2)) >= max_acceptable_deviation
        flag = 1;
        if max_deviation_delay <= abs(zero_check_delay(i,2))
            max_deviation_delay = abs(zero_check_delay(i,2));
        end
    end
    if abs(zero_check_delay(i,3)) >= max_acceptable_deviation
        flag = 1;
        if max_deviation_delay <= abs(zero_check_delay(i,3))
            max_deviation_delay = abs(zero_check_delay(i,3));
        end
    end
end
if flag == 0
    disp("LFD observer with time delay is acceptable")
else
    disp("fault in LFD observer with time delay")
    disp("max deviation = " + max_deviation_delay + " liter")
end
%% plots
close all
figure("name","check if FD observer is the same as LFD observer")
subplot(1,2,1)
plot(y_hat.time,y_hat.data)
legend("Tank 1 level","Tank 2 level","Tank 3 level")
grid on
subplot(1,2,2)
plot(y_hat_LFD_delayed.time,y_hat_LFD_delayed.data)
legend("Tank 1 level","Tank 2 level","Tank 3 level")
grid on