%% EJ3_c - Jacobiano del P–R–R (planar) — versión simple
clear; clc;
syms q1 q2 q3 a2 a3 real
q = [q1 q2 q3];

% DH estándar: [theta d a alpha sigma]; sigma=1 prismática, 0 revoluta
% q1: prismática vertical (z)  |  q2, q3: revolutas en z (planar XY)
dh = [   0    q1   0   0   1;   % P en z
         q2    0  a2   0   0;   % R
         q3    0  a3   0   0 ]; % R

R  = SerialLink(dh, 'name', 'PRR_planar');

J  = simplify(R.jacob0(q));     % 6x3  [vx; vy; vz; wx; wy; wz]
Jxy = simplify(J(1:2,:));       % 2x3  (posición XY)

% Menores 2x2 para singularidades en XY
detJ12 = simplify(det(Jxy(:,[1 2])));
detJ13 = simplify(det(Jxy(:,[1 3])));
detJ23 = simplify(det(Jxy(:,[2 3])));

disp('Jacobiano 6x3 (base):'); disp(J);
disp('Jacobiano reducido XY (2x3):'); disp(Jxy);
disp('det(Jxy(:,[1 2])) ='); disp(detJ12);
disp('det(Jxy(:,[1 3])) ='); disp(detJ13);
disp('det(Jxy(:,[2 3])) ='); disp(detJ23);
