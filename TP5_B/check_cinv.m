clc; clear; close all;

robot;

q = [35, -50, -35, 35, -35, 35] * pi/180;
disp("qoriginal= ")
disp(q)
% Se propone este vector articular a modo de ejemplo.
T = R.fkine(q); % Matriz T dato.

q0 = [0,0,0,0,0,0]*pi/180;

disp('Comparación de resultados:')
% Cinemática inversa
qsol = Ej_TF(T, R, q0,1)
%qsol = TP5B_EjercicioTF(T, R, q0, 0);

% Intentar de nuevo la cinemática inversa con un mayor número de iteraciones y tolerancia ajustada
qinv = R.ikine(T, 'q0', q, 'tol', 1e-6, 'ilimit', 500);
disp('Solucion calculada con el metodo ikine:')
disp(qinv);
figure(1)
R.plot(qsol)
T-R.fkine(qsol)
figure(2)
R.plot(qinv)
