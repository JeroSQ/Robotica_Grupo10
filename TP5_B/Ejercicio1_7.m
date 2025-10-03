%% === Ejercicio 7: Verificación del Ejercicio 1 con una postura de prueba ===
clear; clc;

% --- 1) Definición del robot con parámetros DH unitarios ---
dh = [ ...
    0   1   0    pi/2;    % Junta 1: base
    0   0   1    0;       % Junta 2: brazo
    0   0   1    0;       % Junta 3: antebrazo
    0   0   0    pi/2;    % Junta 4: roll muñeca
    0   0   0   -pi/2;    % Junta 5: pitch muñeca
    0   1   0    0];      % Junta 6: yaw muñeca (d6=1)
Robot = SerialLink(dh,'name','Robot6GDL_unitario');

% --- 2) Postura de prueba (en radianes) ---
q_prueba = [35 -40 25 20 -25 15] * pi/180;

% --- 3) Cinemática directa y cálculo del centro de la muñeca ---
T06 = Robot.fkine(q_prueba);
% p_muñeca = p_extremo - d6 * z6
p_muñeca = T06.t - dh(6,2) * T06.a;

% --- 4) Recuperar las 4 soluciones (q1,q2,q3) del Ejercicio 5 ---
[Q123, T03_lista] = Ejercicio1_5(Robot, p_muñeca);  % tu función del Ej.5

% --- 5) Verificación #1: comprobar que todas las T03 llegan al mismo p_muñeca ---
fprintf('--- Verificación de posición de la muñeca ---\n');
for i = 1:4
    T03 = T03_lista{i};
    error_pos = norm(T03(1:3,4) - p_muñeca);
    fprintf('Solución %d: ||p03 - p_muñeca|| = %.3e\n', i, error_pos);
end

% --- 6) Verificación #2: comparar con la postura de prueba ---
q_prueba123 = q_prueba(1:3);   % solo las primeras 3 articulaciones
normalizar = @(x) atan2(sin(x), cos(x));  % wrap (-pi,pi]
mejor_sol = 0; mejor_error = inf;

for i = 1:4
    dif = normalizar(Q123(:,i) - q_prueba123);
    n = norm(dif);
    if n < mejor_error
        mejor_error = n;
        mejor_sol = i;
    end
end

fprintf('\n--- Coincidencia con la postura propuesta ---\n');
fprintf('Mejor solución = %d, error angular = %.3e rad\n', mejor_sol, mejor_error);
disp('q_prueba123 (rad):'); disp(q_prueba123.');
disp('Q123(:,mejor) (rad):'); disp(Q123(:,mejor_sol).');

% --- 7) Visualización: graficar robot en postura de prueba y las 4 soluciones ---
figure; hold on; grid on; title('Ejercicio 7: verificación con 4 ternas q1..q3');
Robot.plot(q_prueba,'workspace',[-4 4 -4 4 -2 5]);  % postura de referencia

for i = 1:4
    q_sol = [Q123(:,i).' 0 0 0];  % completar con q4=q5=q6=0
    Robot.plot(q_sol);
end
