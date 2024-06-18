close all
load y221012_170415.dat
x = y221012_170415;
clear y221012_170415;
% t - time
t = x(:,1);
% ya - output A : temperature [C]
ya = x(:,2);
% yb - output B : temperature [C]
yb = x(:,3);
% u - control input [%]
u = x(:,4);
% r - reference : reference temperature [C]
r = x(:,5);
% q - flow [L/s]
q = x(:,6);
% kpiTotal - performance index Total
kpi = x(:,7);
clear x;

% figure('Name','Temperature');
% subplot(211);
% plot(t, [ya r]); title('Temperature [C]'); ylabel('y_A, r [C]');
%
% subplot(212);
% plot(t, [yb r]); ylabel('y_B, r [C]'); xlabel('t [s]');
%
% figure('Name','Flow disturbance');
% plot(t, q); title('Flow [L/s]'); ylabel('q [L/s]'); xlabel('t [s]');
%
% figure('Name','Control action');
% plot(t, u); title('Valve position [%]'); ylabel('u [%]'); xlabel('t [s]');
%
% figure('Name','Performance Index');
% plot(t, kpi); title('KPI'); ylabel('kpi'); xlabel('t [s]');

% figure(1)
% subplot(211)
% plot(t, [ya, yb]);  title('Temperature [C]');ylabel('y_A, y_B [C]'); xlabel('t [s]');
% axis([18 60 52 68])
% subplot(212)
% plot(t, u); title('Valve position [%]'); ylabel('u [%]'); xlabel('t [s]');
% axis([18 62 48 72])

% figure(2)
% tau=0.47;
% k0=0.62;
% wn=0.60;
% D=0.80;
% alpha=0.4;
% Fbs=tf(k0*[alpha 1]*wn^2, conv([ 1 2*D*wn wn^2],[ tau 1]));
% [ysim, tsim] = step(Fbs,20);
% hold on
% plot(tsim,ysim, '-k', 'LineWidth',1)
% hold on
% plot( t-20.4, (ya - 53.46)/10, '-r',t - 42.6, (ya - 59.80)/10, '-r');
% axis([0 20 0 0.8])	

figure(3)
tau=0.47;
Fv=tf(1,[tau 1]);
u0=50;
y0=53.20;
k0=0.62;
wn=0.60;
D=0.80;
alpha=0.4;
Fb=tf(k0*[alpha 1]*wn^2,[ 1 2*D*wn wn^2], 'InputDelay',3.05);
Ftotal=series(Fv, Fb );
ysim=lsim(Ftotal, u-u0,t);
plot(t,[yb ysim+y0]);
axis([15 75 50 75])
Error = trapz(abs(((ysim+y0) - yb).^2))

