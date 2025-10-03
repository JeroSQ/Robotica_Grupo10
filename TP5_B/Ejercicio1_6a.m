% Ejercicio 6 - Robot genérico 6GDL con longitudes unitarias
% Definición de la tabla DH: [theta d a alpha sigma]
% sigma=0 -> articulación revoluta
clc, clear,close all,


dh = [ ...
    0      1     0      pi/2;   % 1: base (z2 ⟂ z1)
    0      0      1     0;      % 2: brazo   (z3 ‖ z2)
    0      0      1     0;      % 3: antebrazo; x3 es a lo largo del eslabón
    0      0      0      pi/2;   % 4: ***z4 || x3***  (roll de la muñeca)
    0      0      0     -pi/2;   % 5: pitch
    0      1     0      0];     % 6: yaw + offset herramienta
% -------------------------------------------------------




% Crear el objeto SerialLink
R = SerialLink(dh, 'name', 'Robot6GDL_unitario');

% Graficar con una postura ejemplo
q = [0 40 -30  20 15 0]*pi/180;
figure; R.plot(q);
