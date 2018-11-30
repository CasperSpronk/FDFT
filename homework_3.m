%%
% This code is made by:
% Jorge Bonekamp
% Gerardo Moyers
% Casper Spronk
%% Deterministic Limit Checks
mean_change = 0.1;
x = rand(1,1000) - 0.5;
x = [x mean_change+rand(1,1000)];
  


out = deterministic_limit(x,0.5);
plot(x)
hold on
plot(out)


