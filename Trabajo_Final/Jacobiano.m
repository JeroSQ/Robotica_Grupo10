clear; clc;
robot

syms q1 q2 q3 q4 q5 q6 real
q=[q1,q2,q3,q4,q5,q6];
disp("Calculando: ")
J=simplify(R.jacob0(q));
disp J