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

faultTime = [1e6 1e6 1e6];
faultMag = [1 0 0];
sampleTime = 0.1;
%% nominal parameters
tankCrossNom = tankCross * (1 + 0.1 * (rand(1) - 1/2));
tankInitNom = tankInit * (1 + 0.1 * (rand(1) - 1/2));
tankMaxNom = tankMax * (1 + 0.1 * (rand(1) - 1/2));

pipeCrossNom = pipeCross * (1 + 0.1 * (rand(1) - 1/2));
pipeCoeffNom = pipeCoeff * (1 + 0.1 * (rand(1) - 1/2));
%% Generating a random seed and running the simulink file
seed1 = randi([1 100000]);
seed2 = randi([1 100000]);
seed3 = randi([1 100000]);
simOut = sim("task_1_2_v01.slx");

%% plots
hold on
grid on
plot(tankTrueLevel1.time,tankTrueLevel1.data)
plot(tankTrueLevel2.time,tankTrueLevel2.data)
plot(tankTrueLevel3.time,tankTrueLevel3.data)
plot(tankNomLevel1.time,tankNomLevel1.data)
plot(tankNomLevel2.time,tankNomLevel2.data)
plot(tankNomLevel3.time,tankNomLevel3.data)
legend("Tank 1 true level","Tank 2 true level","Tank 3 true level","Tank 1 nominal level","Tank 2 nominal level","Tank 3 nominal level")




