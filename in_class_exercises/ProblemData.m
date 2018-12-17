clc
clear all
close all
%%
tankCross = [0.156 0.156 0.156];
tankInit = [0 2.5 5];
tankMax = [10 10 10];
tankMin = [0 0 0];

pipeCross = [5 5 5]*1e-4;
pipeCoeff = [1 1 1];

pumpConst = [1.5 1.5]*1e-3;

faultTime = [500 200 400];
faultMag = [1 1 1];
sampleTime = 0.1;
%% nominal parameters
tankCrossNom = tankCross * (1 + 0.1 * (rand(1) - 1/2));
tankInitNom = tankInit * 1.5;%(1 + 0.1 * (rand(1) - 1/2));
tankMaxNom = tankMax * (1 + 0.1 * (rand(1) - 1/2));

pipeCrossNom = pipeCross * (1 + 0.1 * (rand(1) - 1/2));
pipeCoeffNom = pipeCoeff * (1 + 0.1 * (rand(1) - 1/2));
%% observer parameters
lambda = 0.1;
tankInitObs = tankInitNom;%* 1.5;%(1 + 0.2 * (rand(1) - 1/2));
%% Generating a random seed and running the simulink file
seed1 = randi([1 100000]);
seed2 = randi([1 100000]);
seed3 = randi([1 100000]);
simOut = sim("task_1_2_v01_observer.slx");
%% fault detection
fault_pipe1 = zeros(length(residual_Q4.data(:,1)),1);
fault_pipe2 = zeros(length(residual_Q4.data(:,2)),1);
fault_pipe3 = zeros(length(residual_Q4.data(:,3)),1);
delta = 0.02;
nextAbsEstResidualVec1 = zeros(length(residual_Q4.data(:,3)),1);
nextAbsEstResidualVec2 = zeros(length(residual_Q4.data(:,3)),1);
nextAbsEstResidualVec3 = zeros(length(residual_Q4.data(:,3)),1);
for i = 2:length(fault_pipe1)
    % if fault(i-1) == 0
    nextAbsEstResidualVec1(i) = lambda * abs(residual_Q4.data(i-1,1)) + delta;
    if abs(nextAbsEstResidualVec1(i)) < abs(residual_Q4.data(i))
        fault_pipe1(i) = 1;
    end
end
for i = 2:length(fault_pipe1)
    % if fault(i-1) == 0
    nextAbsEstResidualVec2(i) = lambda * abs(residual_Q4.data(i-1,1)) + delta;
    if abs(nextAbsEstResidualVec2(i)) < abs(residual_Q4.data(i))
        fault_pipe1(i) = 1;
    end
end
for i = 2:length(fault_pipe1)
    nextAbsEstResidualVec3(i) = lambda * abs(residual_Q4.data(i-1,1)) + delta;
    if abs(nextAbsEstResidualVec3(i)) < abs(residual_Q4.data(i))
        fault_pipe1(i) = 1;
    end
end
%% plots
close all
figure("name","real system vs model")
hold on
grid on
plot(tankTrueLevel.time,tankTrueLevel.data)
plot(tankNomLevel.time,tankNomLevel.data)
legend("Tank 1 true level","Tank 2 true level","Tank 3 true level","Tank 1 nominal level","Tank 2 nominal level","Tank 3 nominal level")


figure("name","real system vs observer")
hold on
grid on
plot(tankTrueLevel.time,tankTrueLevel.data)
plot(tankObsLevel.time,tankObsLevel.data)
legend("Tank 1 true level","Tank 2 true level","Tank 3 true level","Tank 1 observer level","Tank 2 observer level","Tank 3 observer level")

figure("name","residual levels observer")
hold on 
grid on
plot(residual_Q4.time,residual_Q4.data)
plot(residual_Q4.time,fault_pipe1)
plot(residual_Q4.time,fault_pipe2)
plot(residual_Q4.time,fault_pipe3)
legend("residual tank 1","residual tank 2","residual tank 3","fault pipe 1","fault pipe 2","fault pipe 3")


