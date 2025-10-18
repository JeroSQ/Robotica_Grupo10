%clc; clear;
%robot;

%syms q1 q2 q3 q4 q5 q6 real
%q = [q1 q2 q3 q4 q5 q6];
%J_sym = R.jacob0(q);
%J_func = matlabFunction(J_sym, 'Vars', {q});
qs=[pi,0,pi/2,0,0,0];
%con cualquier angulo funciona, miren nomas como queda
Jn = J_func(qs)
dJ = det(Jn)
R.plot(qs)