clc, clear, close all;
robot;

% === Puntos cartesianos ===
P1 = [0 -1.220 1.515];    % inicio (dentro del alcance con base=I)
P2 = [0.000 -0.860  0.3525];   % destino

qq = [0,-pi/2,-pi/4,0,pi/4,0];

T = R.fkine(qq).T;
orientacion = T(1:3,1:3);

T1 = zeros(4,4);
T1(1:3, 1:3) = orientacion;
T1(1:3,4) = P1;
T1(4,:) = [0,0,0,1];

T2 = T1;
T2(1:3,4) = P2;


% === Tercera pose: bajar 0.1525 m en Z desde P2 ===
T3 = T2;
T3(3,4) = T2(3,4) - 0.2;   % desplazamiento en Z negativo




q1 = R.ikine(T1, qq);
q2 = R.ikine(T2, qq);

% IK del tercer punto (usá q2 como semilla)
q3 = R.ikine(T3, q2);

% Tramo 1: q1 -> q2
[q12, qd12, qdd12] = jtraj(q1, q2, 100);

% Tramo 2: q2 -> q3 (podés usar 60 o 100 muestras)
[q23, qd23, qdd23] = jtraj(q2, q3, 60);

% Concatenar trayecto completo (con o sin pausa)
q   = [q12; q23];              % o [q12; hold12; q23] si activás la pausa
qd  = [qd12; qd23];
qdd = [qdd12; qdd23];


% Se observa que llega al punto final, pero que no sigue una línea recta,
% si no que sube un poco en el eje y y luego baja
R.plot(q, 'fps', 100, 'view', [pi/2 0]);

% No se especifica un tiempo asi que en el eje de abscisas se muestran los
% pasos
figure;
qplot(q);
grid on;
