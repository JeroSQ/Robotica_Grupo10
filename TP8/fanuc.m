clc, clear, close all
%Matriz dh del Paint Mate 200iA (FANUC)
dh = [
    0.000  0.450  0.075  -pi/2 0.000;
    0.000  0.000  0.300  0.000 0.000;
    0.000  0.000  0.075  -pi/2 0.000;
    0.000  0.320  0.000  pi/2 0.000;
    0.000  0.000  0.000  -pi/2 0.000;
    0.000  0.008  0.000  0.000 0.000];

R = SerialLink(dh, 'name','Paint Mate 200iA (FANUC)');