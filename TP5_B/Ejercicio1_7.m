clear; clc;
% Definición del robot con parámetros DH unitarios 
dh = [ ...
    0      1     0      pi/2;   % 1: base (z2 ⟂ z1)
    0      0      1     0;      % 2: brazo   (z3 ‖ z2)
    0      0      1     0;      % 3: antebrazo; x3 es a lo largo del eslabón
    0      0      0      pi/2;   % roll de la muñeca
    0      0      0     -pi/2;   % 5: pitch
    0      1     0      0];     % 6: yaw 
Robot = SerialLink(dh,'name','Robot6GDL_unitario');

% Postura de prueba (en radianes)
q_prueba = [35 -40 25 20 -25 15] * pi/180;

% Cinemática directa y cálculo del centro de la muñeca
T06 = Robot.fkine(q_prueba);
% p_muñeca = p_extremo - d6 * z6
p_muneca = T06.t - dh(6,2) * T06.a;

% Recuperar las 4 soluciones (q1,q2,q3) del Ejercicio 5
[Q123, T03_lista] = Ejercicio1_5(Robot, p_muneca);  % tu función del Ej.5

% Verificación #1: comprobar que todas las T03 llegan al mismo p_muñeca
fprintf('--- Verificación de posición de la muñeca ---\n');
for i = 1:4
    T03 = T03_lista{i};
    error_pos = norm(T03(1:3,4) - p_muneca);
    fprintf('Solución %d: ||p03 - p_muñeca|| = %.3e\n', i, error_pos);
end

% Verificación #2: comparar con la postura de prueba ---
q_prueba123 = q_prueba(1:3);   % solo las primeras 3 articulaciones
normalizar = @(x) atan2(sin(x), cos(x));
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

% Visualización: graficar robot en postura de prueba y las 4 soluciones ---
figure; hold on; grid on; title('Ejercicio 7: verificación con 4 ternas q1..q3');
Robot.plot(q_prueba);
axis([-4 4 -4 4 -1 4]);
for i = 1:4
    q_sol = [Q123(:,i).' 0 0 0];  
    Robot.plot(q_sol);
end
