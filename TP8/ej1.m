fanuc;

q0 = [0,-pi/2,0,0,0,0];
q1 = [-pi/3,pi/10,-pi/5,pi/2,pi/4,0];

t = 0:0.1:3;

[trayectoria, qd, qdd] = jtraj(q0, q1, t);
trayectoria

% A este plot no le estamos diciendo la duración de la trayectoria, si no que
% usa 10 fps por defecto. En este caso coincide perfectamente con la décima
% de paso que hemos usado, pero si fuese distinto, habría que especificarlo
% con el parámetro fps
% R.plot(trayectoria, 'fps', 10);
R.plot(trayectoria);

figure; 
qplot(t, trayectoria); 
grid on;