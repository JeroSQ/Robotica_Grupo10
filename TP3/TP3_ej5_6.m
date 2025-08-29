% LBR iiwa 7 R800 (KUKA)

clc, clear, close all;

dh = [
    0.000  0.340  0.000  pi/2 0.000;
    0.000  0.000  0.000  -pi/2 0.000;
    0.000  0.400  0.000  pi/2 0.000;
    0.000  0.000  0.000  -pi/2 0.000;
    0.000  0.400  0.000  pi/2 0.000;
    0.000  0.000  0.000  -pi/2 0.000;
    0.000  0.126  0.000  pi/2 0.000];

Rob6 = SerialLink(dh,'name','LBR iiwa 7 R800');
q = [0,0,0,0,0,0,0];

% Límites de cada articulación
Rob6.qlim(1,1:2) = [-170, 170]*pi/180;
Rob6.qlim(2,1:2) = [-120,  120]*pi/180;
Rob6.qlim(3,1:2) = [-170, 170]*pi/180;
Rob6.qlim(4,1:2) = [-120,  120]*pi/180;
Rob6.qlim(5,1:2) = [-170,  170]*pi/180;
Rob6.qlim(6,1:2) = [-120,  120]*pi/180;
Rob6.qlim(7,1:2) = [-175, 175]*pi/180;


% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
Rob6.offset = [0 0 0 0 0 0 0];

Rob6.plot(q,'workspace',[-1.5 1.5 -1.5 1.5 -0.5 1.5]); %x, y, z
Rob6.plot(q,'scale',0.5, 'jointdiam', 0.5,'trail',{'r', 'LineWidth', 2})
Rob6.teach()