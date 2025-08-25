% robot.m para el trabajo final
% ROBOT KUKA KR 30 R2100
clc, clear, close all

dh = [
    0.000  0.575  0.175  -pi/2 0;
    0.000  0.000  0.890  0.000 0;
    0.000  0.000  0.000  -pi/2 0;
    0.000  1.035  0.050  pi/2 0;
    0.000  0.000  0.000  -pi/2 0;
    0.000  0.185  0.000  0.000 0];

% setear los parámetros que faltan
R = SerialLink(dh,'name','KUKA KR 30 2100');
q = [0,0,0,0,0,0];

% definir la variable workspace