% Robot planar con 3 articulaciones: rotación, traslación, rotación (Spong 2005).
clc, clear, close all;

dh = [
    0.000  0.000  0.000  pi/2  0.000;
    0.000  0.000  0.000  -pi/2 1.000;
    0.000  0.000  1.000  0.000 0.000];

Rob1 = SerialLink(dh,'name','Spong 2005_2');
q = [0,0,0];

% Límites de cada articulación
Rob1.qlim(1,1:2) = [-180,  180]*pi/180;
Rob1.qlim(2,1:2) = [1,  2];
Rob1.qlim(3,1:2) = [-180, 180]*pi/180;


% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
Rob1.offset = [0 0 -pi/2];

Rob1.plot(q,'workspace',[-3.5 3.5 -3.5 3.5 -0.5 2]) %x, y, z
Rob1.plot(q,'scale',1 ,'trail',{'r', 'LineWidth', 2})
Rob1.teach()
view(0,90)