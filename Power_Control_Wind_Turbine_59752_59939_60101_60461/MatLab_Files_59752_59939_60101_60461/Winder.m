close all
rad2deg = 180.0 / pi;
load y221129_130505.dat
x = y221129_130505;
clear y221129_130505;

% t - time
t = x(:,1);

% y - frequency [Hz]
y = x(:,2);

% u - pitch control input [deg]
u = x(:,3);

% r - frequency reference [rad]
r = x(:,4);

% w - wind speed [m/s]
w = x(:,5);

% kpiTotal - performance index Total
kpi = x(:,6) + x(:,7);

clear x;

% figure('Name','Frequency');
% subplot(211);
% plot(t, [y r]); title('Frequency [Hz]'); ylabel('y, r [Hz]');
% 
% subplot(212);
% plot(t, u); title('Blade position [deg]'); ylabel('\beta [deg]'); xlabel('t [s]');
% 
% figure('Name','Wind speed');
% plot(t, w); title('Wind speed [m/s]'); ylabel('w [m/s]'); xlabel('t [s]');
% 
% figure('Name','Performance Index');
% plot(t, kpi); title('KPI'); ylabel('kpi'); xlabel('t [s]');

% --- 1. MODELAÇÃO ---
% --- a) MODELAÇÃO ---

b1 = 6
a1 = 0.11
D = 0.25
wn = 3.11
k0 = 0.1 * a1 * wn^2 / b1;

Fs = tf( -k0 * [1 b1], conv([ 1 2*D*wn wn^2 ], [1 a1]));

Fs = -Fs;

% --- b) TESTAR A MODELAÇÃO ---

figure(1) 
ysim = lsim(-Fs, u-u(1), t);
plot(t, [y ysim + y(1)]); title('Simulation vs Plant Model'); ylabel('Frequency [Hz]'); xlabel('t [s]');

% --- 2. CONTROLADOR ---

MF_espec = 45;

K = db2mag(47.3)
C1s = K;
G1s = series(C1s, Fs);

figure(2);
bode(Fs, G1s) 
grid

[MG,MF,wcp,wcg] = margin(G1s);

if (MF>180)
    MF = MF - 360;
end

phi_max = (MF_espec - MF) * pi/180; % transformar em graus
a = (1+sin(phi_max))/(1-sin(phi_max))
T = 1/(sqrt(a)*wcg)

if (a<1)
    a = 1;
end

C2s = tf(-K/sqrt(a) * [a*T 1], [T 1]);
G2s = series(C2s, Fs);

figure(3);
bode(-K * Fs, G2s)
grid

H2s = feedback(G2s, 1, -1);
figure(4);
bode(H2s)

figure(5);
step(H2s)






