%% EJ3_b - Jacobiano del R–P–R (planar) — versión simple
clear; clc;
syms q1 q2 q3 a3 L0 real   % L0 = offset telescópico cuando q2=0 (puede ser 0)

% Cinemática directa (planar):
x = (L0+q2)*cos(q1) + a3*cos(q1+q3);
y = (L0+q2)*sin(q1) + a3*sin(q1+q3);
phi = q1 + q3;   % orientación planar

% Jacobiano reducido XY (2x3): filas [x;y] vs [q1 q2 q3]
Jxy = simplify(jacobian([x;y],[q1 q2 q3]));

% Jacobiano planar 3x3 (x,y,phi):
Jplanar = [ Jxy; 1 0 1 ];

% (Si querés el 6x3 estilo Toolbox:)
J = [ Jxy; 0 0 0; 0 0 0; 0 0 0; 1 0 1 ];  % [vx; vy; vz; wx; wy; wz]

% Sub-Jacobianos 2x2 y determinantes (tarea XY)
detJ12 = simplify(det(Jxy(:,[1 2])));
detJ13 = simplify(det(Jxy(:,[1 3])));
detJ23 = simplify(det(Jxy(:,[2 3])));

disp('Jacobiano 6x3 (base):'); disp(J);
disp('Jacobiano reducido XY (2x3):'); disp(Jxy);
disp('det(Jxy(:,[1 2])) ='); disp(detJ12);
disp('det(Jxy(:,[1 3])) ='); disp(detJ13);
disp('det(Jxy(:,[2 3])) ='); disp(detJ23);
