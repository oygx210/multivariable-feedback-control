clear all;
close all;
clc;

s = tf('s');

% this plant has a RHP-zero at s = 0:5 The RHP-zero limits the achievable bandwidth
% and so the crossover region (defined as the frequencies between wc and w180) will
% be at about 0.5rad/s. We require the system to have one integrator (type 1system),
% and therefore a reasonable approach is to let the loop transfer function have a slope
% of -1 at low frequencies, and then to roll off with a higher slope at frequencies beyond
% 0.5rad/s.

% plant
G = 3*(-2*s+1)/(10*s+1)/(5*s+1); 

k = 0.05;

L = 3*k*(-2*s+1)/s/(2*s+1)/(0.33*s+1);

Kc = L/G;

T = L/(1+L);
S = 1 - T;
U = Kc*S;
step(T,U);
figure;
bode(Kc);grid on;