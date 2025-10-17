% R = SerialLink(dh, 'name','mi_robot');  % completa dh
syms q1 q2 q3 q4 q5 q6 real
q = [q1 q2 q3 q4 q5 q6];      % usa 3 si es planar
J = simplify(R.jacob0(q));    % 6xn, en la base
Jr = J(1:3,1:3);              % ej.: bloque de posición si analizás XYZ
