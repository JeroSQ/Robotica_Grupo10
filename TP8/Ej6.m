fanuc;

% === Puntos articulares ===
q1 = [0, -pi/2, -pi/4, 0, pi/4, 0];
q2 = [pi/6, -pi/3, -pi/6, 0, pi/4, 0];
q3 = [pi/3, -pi/4, -pi/8, 0, pi/4, 0];
q4 = [pi/2, -pi/2, -pi/4, 0, pi/4, 0];

viapoints = [q2; q3; q4];
q0 = q1;

dt = 0.05;
qdmax = [0.2 0.2 0.2 0.2 0.2 0.2];% velocidad máx por articulación
tacc = 1;                         % tiempo de aceleración (s)

%  Trayectoria multi-punto sin frenado
q = mstraj(viapoints, qdmax, [], q0, dt, tacc);

% === Calcular velocidades y aceleraciones ===
qd  = gradient(q, dt);
qdd = gradient(qd, dt);
t = (0:length(q)-1)*dt;

% ANIMACION
R.plot(q, 'fps', 100, 'trail', 'b', 'view', [135 30]);

%GRAFICADO
figure;
plot(t, q, 'LineWidth', 1.2);
title('Posición articular (mstraj)');
xlabel('Tiempo [s]'); ylabel('Ángulo [rad]');
grid on;

figure;
plot(t, qd, 'LineWidth', 1.2);
title('Velocidad articular');
xlabel('Tiempo [s]'); ylabel('Velocidad [rad/s]');
grid on;

figure;
plot(t, qdd, 'LineWidth', 1.2);
title('Aceleración articular');
xlabel('Tiempo [s]'); ylabel('Aceleración [rad/s²]');
grid on;


