%% Homework 3
close all
clear all

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 2000;             % Length of signal
t = (0:L-1)*T;
a1=0.25;
a2=0.0625;
F1=1;
F2=20;
y=a1*sin(2*pi*t*F1);  % fundamental signal
y2=a2*sin(2*pi*t*F2);  % upper harmonics
z=y+y2; %signal clean
%%
output=fft(z);  %fast fourier transform
P2 = abs(output/L);  % compute 2 sided spectrum 
P1 = P2(1:L/2+1);   % compute 1 sided spectrum
P1(2:end-1) = 2*P1(2:end-1); 
f=(Fs)*(0:(L/2))/L;
plot(f,P1,'b'); hold on;
a3=a2; phase=0;  freq=20;
x=ceil(rand*3) % make the fault random

if x==1
    freq=ceil(rand*100); %random freq
    
    
elseif x==2
    
    a3=rand*0.024; % random amplitud 
else
    phase=2*pi*ceil(rand*360)/360; % random phase
end
y3=a3*sin(2*pi*t*freq+phase); %fault
y2=[a2*sin(2*pi*t(1:1400)*20),a3*sin(2*pi*t(1401:1429)*freq+phase),a2*sin(2*pi*t(1430:2000)*20)]; %faulty upper harmonics
z2=y+y2; %new signal
m=zeros(26,1);

%%%%%% plotting the fault in the system
output2=fft(y3);
f=(Fs)*(0:(L/2))/L;
P2_2 = abs(output2/L);
P1_2 = P2_2(1:L/2+1);
P1_2(2:end-1) = 2*P1_2(2:end-1);
plot(f,P1_2,'r'); 
figure;

%%%%% fourier transform on each harmonic
for i=1:L/(F2*2):L-(L/(F2*2))
output2=fft(y2(i:i+50));
f=(Fs)*(0:((L/(F2*2))/2))/L;
P2_2 = abs(output2/L);
P1_2 = P2_2(1:(L/(F2*2))/2+1);
P1_2(2:end-1) = 2*P1_2(2:end-1);
plot(f,P1_2); hold on;
m=[m,P1_2'];
end
m(:,1)=[];
m=floor(m*1000000);
fault=zeros((L/(F2*4))+1,(L/1000)*F2-1);

for i=1:(length(m)-1)
 fault(:,i)=(m(:,1)==m(:,i+1));
end
fault=mean(fault); % fault is true if = to 0
[a,position]=min(fault); % find where is the fault
position

figure;
plot(t,z); % plot fft of the system
hold on; plot(t,z2); %plot fft of the faulty system.
