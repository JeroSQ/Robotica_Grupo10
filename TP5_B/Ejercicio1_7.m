%% === Ejercicio 7: verificación de E1 con una postura de prueba ===
clear; clc;

% --- 1) Robot con DH unitaria (o la tuya) ---
dh = [  0   0   1     0     0;    % i: [theta d a alpha sigma]
        0   0   1     0     0;
        0   0   1     0     0;
        0   0   0   pi/2    0;
        0   0   0  -pi/2    0;
        0   1   0     0     0];

R = SerialLink(dh,'name','Robot6GDL_unitario');

% --- 2) Proponer una configuración articular (rad) ---
q_true = [ 35 -40 25  20 -25 15 ]*pi/180;

% --- 3) Cinemática directa y centro de muñeca ---
T06 = R.fkine(q_true);
% p_c = p6 - d6 * z6  (d6 es el 'd' del 6º eslabón)
pc  = T06.t - dh(6,2) * T06.n;

% --- 4) Recuperar las 4 ternas (q1,q2,q3) del Ej.5 ---
[Q123, T03_list] = Ejercicio1_5(R, pc);   % <-- tu función del Ej.5

% --- 5) Verificación #1: todas las T03 terminan en el mismo pc ---
fprintf('--- Verificación de posición de muñeca ---\n');
for i = 1:4
    T03 = T03_list{i};
    err_p = norm(T03(1:3,4) - pc);
    fprintf('sol %d: ||p03 - pc|| = %.3e\n', i, err_p);
end

% --- 6) Verificación #2: una terna coincide con (q_true1..3) ---
q_true123 = q_true(1:3);
% comparar con tolerancia y considerando 2*pi (normalizar)
wrap = @(x) atan2(sin(x), cos(x));    % wrap a (-pi,pi]
best_i = 0; best_norm = inf;

for i = 1:4
    d = wrap(Q123(:,i) - q_true123);
    n = norm(d);
    if n < best_norm
        best_norm = n; best_i = i;
    end
end

fprintf('\n--- Coincidencia con la postura propuesta ---\n');
fprintf('mejor columna = %d, norma angular = %.3e rad\n', best_i, best_norm);
disp('q_true123 (rad):'); disp(q_true123.');
disp('Q123(:,best) (rad):'); disp(Q123(:,best_i).');

% --- 7) (Opcional) Mostrar el robot y las 4 soluciones parciales ---
% Completar con q4=q5=q6=0 para graficar sólo la posición de la muñeca
figure; hold on; grid on; title('Verificación E1: 4 ternas q1..q3');
R.plot(q_true,'workspace',[-4 4 -4 4 -2 5]);     % postura de referencia
for i = 1:4
    qi = [Q123(:,i); 0; 0; 0];   % solo para visualizar la muñeca
    R.plot(qi);
end
