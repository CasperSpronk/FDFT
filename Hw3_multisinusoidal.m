%% Homework 3
close all
clear all

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 2000;             % Length of signal
t = (0:L-1)*T;
a1=0.25;
a2=0.0625;
y=a1*sin(2*pi*t*1);
y2=a2*sin(2*pi*t*20);
z=y+y2;
%%
output=fft(z);
P2 = abs(output/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f=(Fs)*(0:(L/2))/L;
plot(f,P1,'b'); hold on;
a3=a2;
phase=0;
x=ceil(rand*3)
%x=2;
freq=20;

if x==1
    freq=ceil(rand*100);
    
elseif x==2
    a3=0.02;
else
    phase=pi;
end
y3=a3*sin(2*pi*t*freq+phase);
y2=[a2*sin(2*pi*t(1:1400)*20),a3*sin(2*pi*t(1401:1429)*freq+phase),a2*sin(2*pi*t(1430:2000)*20)];
z2=y+y2;
output2=fft(y3);
P2 = abs(output2/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
plot(f,P1,'r'); figure;
plot(t,z);
hold on; plot(t,z2);