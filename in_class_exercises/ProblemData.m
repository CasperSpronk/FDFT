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
%% Generating a random seed and running the simulink file
seed1 = randi([1 100000]);
seed2 = randi([1 100000]);
seed3 = randi([1 100000]);
simOut = sim("task_1_2_v01.slx");




