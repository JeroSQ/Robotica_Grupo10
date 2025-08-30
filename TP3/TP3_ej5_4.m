% SCARA IRB 910SC

clc, clear, close all;

dh = [
    0.000  0.0595  0.200  0.000 0;
    0.000  0.000  0.25  0.000 0;
    0.000  0.000  0.000  pi 0;
    0.000  0.000  0.000  0.000 1];

Rob4 = SerialLink(dh,'name','Scada');
q = [0,0,0,0];

% Límites de cada articulación
Rob4.qlim(1,1:2) = [-140,  140]*pi/180;
Rob4.qlim(2,1:2) = [-150,  150]*pi/180;
Rob4.qlim(3,1:2) = [-400, 400]*pi/180;
Rob4.qlim(4,1:2) = [0.04, 0.22];


% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
Rob4.offset = [0 0 0 0];

Rob4.plot(q,'workspace',[-1 1 -1 1 -0.5 1]); %x, y, z
Rob4.plot(q,'scale',0.5 ,'trail',{'r', 'LineWidth', 2})
Rob4.teach()