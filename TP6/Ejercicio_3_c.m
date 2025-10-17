clear; clc;
syms q1 q2 q3 a2 a3 real
q = [q1 q2 q3];

dh = [   0    q1   0   0   1;   
         q2    0  a2   0   0;   
         q3    0  a3   0   0 ]; 

R  = SerialLink(dh, 'name', 'PRR_planar');

J  = simplify(R.jacob0(q));
Jxy = simplify(J(1:2,:));

detJ12 = simplify(det(Jxy(:,[1 2])));
detJ13 = simplify(det(Jxy(:,[1 3])));
detJ23 = simplify(det(Jxy(:,[2 3])));

disp('Jacobiano 6x3 (base):'); disp(J);
disp('Jacobiano reducido XY (2x3):'); disp(Jxy);
disp('det(Jxy(:,[1 2])) ='); disp(detJ12);
disp('det(Jxy(:,[1 3])) ='); disp(detJ13);
disp('det(Jxy(:,[2 3])) ='); disp(detJ23);
