%% MAIN - Script Principal
% Este script ejecuta la simulación completa:
% 1. Genera los archivos de trayectoria (.mat).
% 2. Lanza la interfaz gráfica de animación.
clc; clear;close all;
disp('Paso 1: Generando trayectorias...');
trayectorias;
disp('Trayectorias generadas y guardadas.');
disp('Paso 2: Iniciando la interfaz de animación...');
InterfazDosRobots;
disp('Simulación lista.');