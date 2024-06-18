close all
rad2deg = 180.0 / pi;
load y221108_122740.dat
x = y221108_122740;
clear y221108_122740;

% t - time
t = x(:,1);

% h - altitude [m]
h = x(:,2);

% theta - pitch angle [rad]
theta = x(:,3);

% q - pitch rate [rad/s]
q = x(:,4);

% u - elevator control input [rad]
u = x(:,5);

% r_theta - pitch angle reference [rad]
r_theta = x(:,6);

% r - altitude reference [m]
r_h = x(:,7);

% wg - vertical wind gust [m/s]
wg = x(:,8);

% kpiTotal - performance index Total
kpi = x(:,9);

clear x;

figure('Name','Altitude');
subplot(311);
plot(t, [h r_h]); title('Altitude [m]'); ylabel('h, r_h [m]');

subplot(312);
plot(t, [theta] * rad2deg); ylabel('\Theta, r_{\Theta} [deg]'); xlabel('t [s]');

subplot(313);
plot(t, [q] * rad2deg); ylabel('Q [deg/s]'); xlabel('t [s]');

figure('Name','Wind disturbance');
plot(t, wg); title('Wind gust speed [m/s]'); ylabel('wg [m/s]'); xlabel('t [s]');

figure('Name','Control action');
plot(t, u * rad2deg); title('Elevator position [deg]'); ylabel('\delta_e [deg]'); xlabel('t [s]');

figure('Name','Performance Index');
plot(t, kpi); title('KPI'); ylabel('kpi'); xlabel('t [s]');

% --- 1. MODELAÇÃO ---

b1 = 2.305148400378274 ;
b2 = 0.861103913823527 ;
b3 = 0.010626751575719 ;
a1 = 0.740551982652778 ;
a2 = 1.380681506199432 ;
a3 = 0.019931577735793 ;
a4 = 0.003595969889691 ;

Fs = tf( [ b1 b2 b3 ], [ 1 a1 a2 a3 a4]);

% --- 2. TESTAR A MODELAÇÃO ---

figure(5) 
ysim = lsim(Fs, u, t);
plot(t, [theta ysim] * rad2deg); ylabel('Pitch Angle [deg]'); xlabel('t [s]');

% --- 3. PZ MAP para Estabilidade ---

figure(6)
pzmap(Fs);

% --- 4. PITCH CONTROLLER DESIGN AND TEST ---

% Construir Hs - Especificação:
s_spec = 5.0; 
tr_spec = 0.9; %rise time
D = sqrt(log(s_spec/100)^2/(pi^2+log(s_spec/100)^2)) %sobre elevação
wn = 3.7 * D / tr_spec
Hs_spec = tf( wn^2, [1 2*D*wn wn^2] );

% Testar Especificação
figure(7)
step ( Hs_spec )

% Polos da Especificação
pole(Hs_spec)
figure(8)
pzmap ( Hs_spec ) % pole zero map

% Root Locus do anel aberto 
Us = tf([0.53 1], 1) % (alpha.s + 1)
Gs = series(Fs,Us) % retroação (neste caso é equivalente a série)

figure(9)
rlocus(Gs)
hold on 
plot( real( pole(Hs_spec) ), imag( pole(Hs_spec)),'rs') %red squares
axis([-5 0 -3 3])
hold off

% Testar com Step

Ktheta = 2.85
Ts = feedback(Ktheta * Fs, Us, -1)

figure(10)
step(Ts)
axis([0 5 0 1])

% --- 5. ALTITUDE CONTROLLER DESIGN AND TEST ---

% Root Locus do anel aberto

G2s = tf(250, [1 0])
F2s = series(Ts, G2s)

figure(11)
rlocus(F2s) %escolher um ganho (alto - oscilatório; baixo - lento)

% Testar com Step

figure(12)
Kh = 0.00371
Hs = feedback(Kh * F2s, 1, -1)
step(Hs)




