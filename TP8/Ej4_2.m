fanuc;

% === Puntos del ejercicio 3 ===
P1 = [0 0 0.95];
P2 = [0.4 0 0.95];
qq = [0,-pi/2,-pi/4,0,pi/4,0];

% === Orientación de referencia (igual que en el ejercicio 2) ===
T = R.fkine(qq).T;
orientacion = T(1:3,1:3);

T1 = eye(4);
T1(1:3,1:3) = orientacion;
T1(1:3,4) = P1;

T2 = T1;
T2(1:3,4) = P2;

% === Trayectoria cartesiana (ctraj) ===
n = 100;
tc = ctraj(T1, T2, n);
q_trayectoria = R.ikine(tc, qq);

% === Derivadas numéricas (diferencias finitas) ===
t_total = 2;                   % 2 segundos de duración
dt = t_total / (n-1);
t = linspace(0, t_total, n);

qd_num = diff(q_trayectoria) / dt;     % velocidad
qdd_num = diff(qd_num) / dt;           % aceleración

% Ajuste de vectores de tiempo para graficar
t_qd  = t(1:end-1);
t_qdd = t(1:end-2);

% === Gráficos separados ===

%  Posición articular
figure;
plot(t, q_trayectoria, 'LineWidth', 1.2);
title('Posición articular (q)');
xlabel('Tiempo [s]');
ylabel('Ángulo [rad]');
legend({'q1','q2','q3','q4','q5','q6'}, 'Location', 'bestoutside');
grid on;

%  Velocidad articular (derivada numérica)
figure;
plot(t_qd, qd_num, 'LineWidth', 1.2);
title('Velocidad articular (derivada numérica de q)');
xlabel('Tiempo [s]');
ylabel('Velocidad [rad/s]');
legend({'q1','q2','q3','q4','q5','q6'}, 'Location', 'bestoutside');
grid on;

% Aceleración articular (segunda derivada numérica)
figure;
plot(t_qdd, qdd_num, 'LineWidth', 1.2);
title('Aceleración articular (segunda derivada numérica)');
xlabel('Tiempo [s]');
ylabel('Aceleración [rad/s²]');
legend({'q1','q2','q3','q4','q5','q6'}, 'Location', 'bestoutside');
grid on;
