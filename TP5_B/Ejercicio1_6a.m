% Ejercicio 6 - Robot genérico 6GDL con longitudes unitarias
% Definición de la tabla DH: [theta d a alpha sigma]
% sigma=0 -> articulación revoluta
clc, clear,close all,


%dh = [
 %   0   1   0     pi/2     0;   % 1: q1  (d1=1, a1=0,  alpha1=0)  -> base
  %  0   0   1     0     0;   % 2: q2  (a2=1, alpha2=0)         -> plano
   % 0   0   1     0     0;   % 3: q3  (a3=1, alpha3=0)         -> plano
   % 0   0   0   +pi/2   0;   % 4: q4  (muñeca)                 -> Z4 ⟂ Z3
   % 0   0   0   -pi/2   0;   % 5: q5  (muñeca)                 -> Z5 ⟂ Z4
   % 0   1   0     0     0;   % 6: q6  (muñeca, d6=1)
%];

dh = [ ...
    0     1   0    pi/2;   % 1: q1
    0     0    1   0;      % 2: q2
    0     0    1   pi/2;      % 3: q3
    0     1   0    -pi/2;   % 4: q4
    0     0    0   pi/2;   % 5: q5
    0     1   0    0];     % 6: q6





% Crear el objeto SerialLink
R = SerialLink(dh, 'name', 'Robot6GDL_unitario');
% Mostrar información básica
disp(R);

% Graficar con una postura ejemplo
q = [30 -40 25  20 -25 15]*pi/180;
figure; R.plot(q);
