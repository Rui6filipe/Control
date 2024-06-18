close all
load y221222_223557.dat
x = y221222_223557;
clear y221222_223557;
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

figure(1)
Kp = 1.428;
Ti = 5.975;
Td = 1.494;
PID = pid(Kp, Kp/Ti, Kp*Td);
PID_plant = series(PID, Ftotal);
PID_plant_total = feedback(PID_plant, 1, -1);
simulacao = lsim(PID_plant_total, r, t);
plot(t, [simulacao r]); ylabel('Temperature [C]'); xlabel('t [s]');

figure(2)
plot(t, [yb r]); ylabel('Temperature [C]'); xlabel('t [s]');
