% Paint Mate 200iA (FANUC). 

clc, clear, close all;

dh = [
    0.000  0.450  0.150  -pi/2 0.000;
    0.000  0.000  0.600  0.000 0.000;
    0.000  0.000  0.120  pi/2 0.000;
    0.000  0.620  0.000  -pi/2 0.000;
    0.000  0.000  0.000  pi/2 0.000;
    0.000  0.100  0.000  0.000 0.000];

Rob5 = SerialLink(dh,'name','Paint Mate 200iA');
q = [0,0,0,0,0,0];

% Límites de cada articulación
Rob5.qlim(1,1:2) = [-170, 170]*pi/180;
Rob5.qlim(2,1:2) = [-90,  140]*pi/180;
Rob5.qlim(3,1:2) = [-200, 200]*pi/180;
Rob5.qlim(4,1:2) = [-190,  190]*pi/180;
Rob5.qlim(5,1:2) = [-120,  120]*pi/180;
Rob5.qlim(6,1:2) = [-360,  360]*pi/180;


% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
Rob5.offset = [0 0 0 0 0 0];

Rob5.plot(q,'workspace',[-1.5 1.5 -1.5 1.5 -0.5 1.5]); %x, y, z
Rob5.plot(q,'scale',0.5, 'jointdiam', 0.5,'trail',{'r', 'LineWidth', 2})
Rob5.teach()