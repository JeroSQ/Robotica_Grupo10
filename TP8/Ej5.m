fanuc;

% Definición de 4 posiciones articulares
q1 = [0, -pi/2, -pi/4, 0, pi/4, 0];       % posición inicial
q2 = [pi/6, -pi/3, -pi/6, 0, pi/4, 0];    % punto intermedio 1
q3 = [pi/3, -pi/4, -pi/8, 0, pi/4, 0];    % punto intermedio 2
q4 = [pi/2, -pi/2, -pi/4, 0, pi/4, 0];    % punto final

% Número de pasos por tramo
n = 50;

% Generación de trayectorias con "frenado" en cada punto
[q12, qd12, qdd12] = jtraj(q1, q2, n);
[q23, qd23, qdd23] = jtraj(q2, q3, n);
[q34, qd34, qdd34] = jtraj(q3, q4, n);

% Concatenar todos los tramos
q   = [q12; q23; q34];
qd  = [qd12; qd23; qd34];
qdd = [qdd12; qdd23; qdd34];

%%ANIMACION DE TRAYECTORIA
R.plot(q, 'fps', 100, 'trail', 'b', 'view', [135 30]);

t = linspace(0,6,length(q));   % tiempo total aprox (ajustable)

%%GRAFICADO
figure;
subplot(3,1,1);
plot(t, q, 'LineWidth', 1.2);
title('Posición articular (q)');
xlabel('Tiempo [s]'); ylabel('Ángulo [rad]');
grid on;

subplot(3,1,2);
plot(t, qd, 'LineWidth', 1.2);
title('Velocidad articular (qd)');
xlabel('Tiempo [s]'); ylabel('Velocidad [rad/s]');
grid on;

subplot(3,1,3);
plot(t, qdd, 'LineWidth', 1.2);
title('Aceleración articular (qdd)');
xlabel('Tiempo [s]'); ylabel('Aceleración [rad/s²]');
grid on;
