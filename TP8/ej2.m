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

[q, qd, qdd] = jtraj(q1, q2, 100);

% Se observa que llega al punto final, pero que no sigue una línea recta,
% si no que sube un poco en el eje y y luego baja
R.plot(q, 'fps', 100, 'view', [pi/2 0]);
figure;

% No se especifica un tiempo asi que en el eje de abscisas se muestran los
% pasos
qplot(q)
grid on;
