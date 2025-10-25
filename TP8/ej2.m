fanuc;

P1 = [0 0 0.95];
P2 = [0.4 0 0.95];
qq = [0,-pi/2,-pi/4,0,pi/4,0];

T = R.fkine(qq).T;
orientacion = T(1:3,1:3);

T1 = zeros(4,4);
T1(1:3, 1:3) = orientacion;
T1(1:3,4) = P1;
T1(4,:) = [0,0,0,1];

T2 = T1;
T2(1:3,4) = P2;

q1 = R.ikine(T1, qq);
q2 = R.ikine(T2, qq);

N = 100;
t = linspace(0,2,N);   % tiempo de 0 a 2 segundos
[q, qd, qdd] = jtraj(q1, q2, t);

% Animación
R.plot(q, 'fps', 50,'trail', 'b', 'view', [pi/2 0]);

% Gráficos separados
figure;
plot(t, q); title('Posición articular'); xlabel('Tiempo [s]'); ylabel('Ángulo [rad]'); grid on;

figure;
plot(t, qd); title('Velocidad articular'); xlabel('Tiempo [s]'); ylabel('Velocidad [rad/s]'); grid on;

figure;
plot(t, qdd); title('Aceleración articular'); xlabel('Tiempo [s]'); ylabel('Aceleración [rad/s²]'); grid on;
