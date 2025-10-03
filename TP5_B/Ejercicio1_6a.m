% Ejercicio 6 - Robot genérico 6GDL con longitudes unitarias
% Definición de la tabla DH: [theta d a alpha sigma]
% sigma=0 -> articulación revoluta
clc, clear,close all,


dh = [ ...
    0     1   0    pi/2;   % 1: q1
    0     0    1   0;      % 2: q2
    0     0    1   -pi/2;      % 3: q3
    0     0    1   pi/2;   % 4: q4
    0     0    0   -pi/2;   % 5: q5
    0     1   0    0];     % 6: q6





% Crear el objeto SerialLink
R = SerialLink(dh, 'name', 'Robot6GDL_unitario');
% Mostrar información básica
disp(R);

% Graficar con una postura ejemplo
q = [0 40 -30  20 15 0]*pi/180;
figure; R.plot(q);
