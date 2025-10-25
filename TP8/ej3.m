fanuc;

P1 = [0 0 0.95];
P2 = [0.4 0 0.95];

qq = [0,-pi/2,-pi/4,0,pi/4,0];

T = R.fkine(qq).T;
orientacion = T(1:3,1:3);

T1 = zeros(4,4);
T1(1:3, 1:3) = orientacion
T1(1:3,4) = P1;
T1(4,:) = [0,0,0,1];

T2 = T1
T2(1:3,4) = P2;

% ctraj toma como parámetro dos matrices de transformación homogénea y un
% número de pasos. Devuelve n matrices de transformación homogénea
tc = ctraj(T1,T2, 100);

q_trayectoria = R.ikine(tc,qq);

% Ahora si se ve que sigue una línea recta en el espacio de trabajo
R.plot(q_trayectoria, 'fps', 100,'trail', 'b', 'view', [pi/2 0]);

% No se especifica un tiempo asi que en el eje de abscisas se muestran los
% pasos
figure;
qplot(q_trayectoria);
grid on;