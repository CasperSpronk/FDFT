%%
% This code is made by:
% Jorge Bonekamp
% Gerardo Moyers
% Casper Spronk
clear all
close all
%% Deterministic Limit Checks
limit = 0.25;
mean_change = 2;
Noise               = wgn(1,1000, 1);
x = Noise;
x = [x mean_change+Noise];
k = 100; 


out = deterministic_limit(x,limit);
% plot(x)
% hold on
plot(out)
hold on
plot(limit*ones(1,length(x)))
hold on
plot(-limit*ones(1,length(x)))

%% Windowed Deterministic Limit Check
[new_out, average] = new_deterministic_limit(x,limit,k);
figure
% plot(x)
% hold on
plot(new_out)
hold on
plot(limit*ones(1,length(x)))
hold on
plot(-limit*ones(1,length(x)))
hold on
plot(average)


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