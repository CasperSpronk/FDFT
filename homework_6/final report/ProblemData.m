clc
clear all
% Sampling time, stop time
Ts = 0.01;
Tstop = 1000;
Tdelay = 500;
% Real, physical parameters

tankCross = [0.156 0.156 0.156];
tankInit = [7 5 6];
tankMax = [10 10 10];
tankMin = [0 0 0];

pipeCross = [5 5 5]*1e-4;
pipeCoeff = [1 1 1];

g = 9.81;

% Inputs

pumpDCMag = [0 1.5]*1e-3;
pumpACPeriod = [10 50];
pumpACMagRelative = [0.1 0.25];
u0 = [1.5 2]*1e-3;

%Faults

faultTime = [1e6 1e6 1e6];
faultMag = [0 0 0];

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

% initial linear conditions
Xe = [7 5 6];
A11 = -pipeCoeff(1) * pipeCross(1) * sqrt(2*g) / (tankCross(1) * 2 * sqrt(Xe(1) - Xe(3)));
A22 = -pipeCoeff(2) * pipeCross(2) * sqrt(2*g) / (tankCross(2) * 2 * sqrt(Xe(3) - Xe(2))) - pipeCoeff(3) * pipeCross(3)* sqrt(2*g) / (tankCross(3) * 2 *sqrt(Xe(2)));
A33 = -pipeCoeff(1) * pipeCross(1) * sqrt(2*g) / (tankCross(3) * 2 * sqrt(Xe(1) - Xe(3))) - pipeCoeff(2) * pipeCross(2) * sqrt(2*g) / (tankCross(3) * 2 * sqrt(Xe(3) - Xe(2)));
A12 = 0;
A13 = -A11;
A21 = 0;
A23 = pipeCoeff(2) * pipeCross(2) * sqrt(2*g) / (tankCross(2) * 2 * sqrt(Xe(3) - Xe(2)));
A31 = pipeCoeff(1) * pipeCross(1) * sqrt(2*g) / (tankCross(3) * 2 * sqrt(Xe(1) - Xe(3)));
A32 = pipeCoeff(2) * pipeCross(2) * sqrt(2*g) / (tankCross(3) * 2 * sqrt(Xe(3) - Xe(2)));
A = [A11 A12 A13;
     A21 A22 A23;
     A31 A32 A33];
 
B = [1/tankCross(1) 0;
     0 1/tankCross(2);
     0 0];

C = [1 0 0;
     0 1 0 
     0 0 1];

p = [-1 -1.1 -1.2];



K = place(A,B,p)';
%% Run normal linear model with linear input
sim("linear_model_linear_input");
%% Run normal linear model with nonlinear input
sim("linear_model_nonlinear");
%% partial failure sensor
Cf = [1 0 0
      0 0.5 0 
      0 0 1];
P = C * Cf' * (Cf * Cf')^-1;
%%
run = sim("linear_model_partial_fault_sensor_linear");
plot(tankValuesHealthyLinear.time,tankValuesHealthyLinear.data)
ylim([0 10])
legend("tank 1","tank 2","tank 3")

figure
plot(pumpValuesLinear.time,pumpValuesLinear.data)
hold on
plot(pumpValuesPartialFaultSensorLinear.time,pumpValuesPartialFaultSensorLinear.data)
legend("tank 1","tank 2","tank 1 faulty actuator","tank 2 faulty actuator")
%% partial failure actuator
close all
Bf = [1/tankCross(1) 0;
      0 (1/tankCross(2))/2;
      0 0];

N = (Bf' * Bf)^-1 * Bf' * B;
 
run = sim("linear_model_partial_fault_actuator_linear");
plot(tankValuesPartialFaultActuatorLinear.time,tankValuesPartialFaultActuatorLinear.data)
ylim([0 10])
legend("tank 1","tank 2","tank 3")

figure
plot(pumpValuesLinear.time,pumpValuesLinear.data)
hold on
plot(pumpValuesPartialFaultActuatorLinear.time,pumpValuesPartialFaultActuatorLinear.data)
legend("pump 1 linear","pump 2 linear","pump 1 faulty actuator","pump 2 faulty actuator")

%% observer design
L = place(A',C',p);
%% full failure sensor
Cf = [1 0 0;
      0 0.5 0
      0 0 1];
Cv = C - P*Cf;
  
  
  
  
%% full failure actuator
Bf = [1/tankCross(1);
     0;
     0];
