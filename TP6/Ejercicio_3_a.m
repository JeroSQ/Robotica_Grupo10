%% EJ3 - Jacobiano del 3R (planar) — versión simple
clear; clc;
syms q1 q2 q3 a1 a2 a3 real

% DH estándar: [theta d a alpha] (3 revolutas en z, todas con alpha=0)
dh = [ q1  0  a1  0;
       q2  0  a2  0;
       q3  0  a3  0 ];

R   = SerialLink(dh, 'name', 'Planar3R');

J   = simplify(R.jacob0([q1 q2 q3]));  % Jacobiano espacial 6x3 (en la base)
Jxy = simplify(J(1:2,:));              % Jacobiano reducido de posición XY (2x3)

% Menores 2x2 (pares de columnas) para singularidades en XY
detJ12 = simplify(det(Jxy(:,1:2)));
detJ13 = simplify(det(Jxy(:,[1 3])));
detJ23 = simplify(det(Jxy(:,2:3)));

% Mostrar
disp('Jacobiano 6x3 (base):'); disp(J);
disp('Jacobiano reducido XY (2x3):'); disp(Jxy);
disp('det(Jxy(:,[1 2])) ='); disp(detJ12);
disp('det(Jxy(:,[1 3])) ='); disp(detJ13);
disp('det(Jxy(:,[2 3])) ='); disp(detJ23);
