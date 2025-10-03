%Robotica 1
% Prueba de CinInv
close all; clc; clear all;

R = RobotCI();
%disp(class(R)); % Debería mostrar 'SerialLink'
% Verificación del objeto SerialLink

q = [35, -70, -35, 35, -35, 35] * pi/180; % Se propone este vector articular a modo de ejemplo.
T = R.fkine(q); % Matriz T dato.

q0 = [0,0,0,0,0,0]*pi/180;

disp('Comparación de resultados:')
% Cinemática inversa
qsol = TP5B_EjercicioTF(T, R, q0, 1);
%qsol = TP5B_EjercicioTF(T, R, q0, 0);

% Intentar de nuevo la cinemática inversa con un mayor número de iteraciones y tolerancia ajustada
qinv = R.ikine(T, 'q0', q, 'tol', 1e-6, 'ilimit', 500);
disp('Solucion calculada con el metodo ikine:')
disp(qinv');

% Corroboración
%qalt = [ -2.5307, -0.5243, 0.0598, -0.8308, -0.4617, -1.2344];
Tp = R.fkine(qsol).double;
%Tpb = R.fkine(qalt).double;

disp('Matriz T calculada con fkine para el q semilla:')
disp(T)
disp('Matriz T calculada con fkine para la mejor solución de mi metodo de CInv:')
disp(Tp)
%disp('Matriz T calculada con fkine para la primer solución de mi metodo de CInv:')
%disp(Tpb)