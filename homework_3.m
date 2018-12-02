%%
% This code is made by:
% Jorge Bonekamp
% Gerardo Moyers
% Casper Spronk
clear all
close all
clc
%% Deterministic Limit Checks
% Setting up signal with noise and mean change
k0                     = 1001;                                             % Time instant when the mean of the signal changes
Mean1                  = 10;
Mean_Change            = 1;
Mean2                  = Mean1 + Mean_Change;
k0                     = 1001;                                             % Time instant when the mean of the signal changes
Noise                  = wgn(1,(k0-1)*2,1);                                % White Gaussian Noise with variance 1
z1                     = Mean1 + Noise(1:k0-1);
z2                     = Mean2 + Noise(1+length(Noise)/2:end);
z                      = [z1 z2];                                          % The discrete time signal

% plotting the discrete time signal z
figure
plot(z)
hold on
Mean1_Vec              = Mean1 * ones(1,k0-1);
Mean2_Vec              = Mean2 * ones(1,k0-1);
Mean                   = [Mean1_Vec Mean2_Vec];
stairs(Mean, 'color','k')
hold off

%Setting up Deterministic Limit check
Limit_Size             = Mean_Change / 2;
Upper_Limit            = Mean1 + Limit_Size;
Lower_Limit            = Mean1 - Limit_Size;
Output_Test1           = (z > Upper_Limit) | (z < Lower_Limit);

% Plotting Results of test
figure
plot( z )
hold on
grid on
stairs( Mean                           , 'color', 'k' )
stairs( Output_Test1 )
plot( Upper_Limit * ones(1,length(z)), 'color', 'r' )
plot( Lower_Limit * ones(1,length(z)), 'color', 'r' )
hold off
%% Windowed Deterministic Limit Check

W = 30;

Average = movmean(z,W,'omitnan');                                   % Averaging signal
Output_Test2 = (Average > Upper_Limit) | (Average < Lower_Limit);   % Checking against limits

figure
plot( z )
hold on
stairs(Output_Test2)
stairs( Mean                         , 'color', 'k' )
plot( Upper_Limit * ones(1,length(z)), 'color', 'r' )
plot( Lower_Limit * ones(1,length(z)), 'color', 'r' )
plot(Average, 'linewidth', 2, 'color', 'm')
%legend TODO
hold off

%% Probablistic test
meanEst = zeros(1,length(x));
for i = 2:length(x)
    meanEst(i) = meanEst(i-1) + 1/i * (x(i) - meanEst(i-1)); 
end

variancesquared = zeros(1,length(x));

for i = 3:length(x)
    disp(i)
    disp(variancesquared(i))
    disp(x(i))
    disp(meanEst(i))
    variancesquared = (i-2)/(i-1) * variancesquared(i-1) + (x(i) - meanEst(i-1))^2;
end

figure
plot(x)
hold on
plot(meanEst)