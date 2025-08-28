% Robot de 3 articulaciones: traslación, rotación, rotación (Craig 2006). 

clc, clear, close all;

dh = [
    0.000  0.000  1.000  0.000 1.000;
    0.000  0.000  2.000  0.000 0.000;
    0.000  0.000  1.000  0.000 0.000];

Rob3 = SerialLink(dh,'name','Craig 2006');
q = [0,0,0];

% Límites de cada articulación
Rob3.qlim(1,1:2) = [0,  2];
Rob3.qlim(2,1:2) = [-pi,  pi];
Rob3.qlim(3,1:2) = [-180, 180]*pi/180;


% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
Rob3.offset = [0 0 0];

Rob3.plot(q,'workspace',[-5 5 -5 5 -0.5 3.5]) %x, y, z
Rob3.plot(q,'scale',1 ,'trail',{'r', 'LineWidth', 2})
Rob3.teach()