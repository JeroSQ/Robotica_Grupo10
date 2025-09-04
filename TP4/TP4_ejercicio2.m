%SCARA IRB 910SC (ABB).
clc, clear, close all
%Matriz otorgada en el ejercicio
DH = [
0.000 0.195 0.300 0.000 0;
0.000 0.000 0.250 0.000 0;
0.000 0.000 0.000 pi 1;
0.000 0.000 0.000 0.000 0];
%Matriz obtenida en el trabajo anterior
dh = [
0.000  0.0595  0.200  0.000 0;
0.000  0.000  0.250  0.000 0;
0.000  0.000  0.000  pi 0;
0.000  0.000  0.000  0.000 1];

R = SerialLink(DH);
q = [0,0,0,0];
T = R.fkine(q);
disp(T)
fprintf('######################################################\n')
R2 = SerialLink(dh);
q2 = [0,0,0,0];
T2 = R2.fkine(q2);
disp(T2)

disp('Diferencia de posición:');
disp(T2.t - T.t);  

disp('Diferencia de orientación:');
disp(T2.R - T.R);