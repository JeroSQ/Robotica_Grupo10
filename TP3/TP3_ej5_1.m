% Robot planar de 3 articulaciones rotacionales (Spong 2005). 
clc, clear, close all;

dh = [
    0.000  0.000  1  0.000 0.000;
    0.000  0.000  1  0.000 0.000;
    0.000  0.000  1  0.000 0.000];

Rob2 = SerialLink(dh,'name','Spong 2005_1');
q = [0,0,0];

% Límites de cada articulación
Rob2.qlim(1,1:2) = [-180,  180]*pi/180;
Rob2.qlim(2,1:2) = [-180,  180]*pi/180;
Rob2.qlim(3,1:2) = [-180, 180]*pi/180;


% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
Rob2.offset = [0 0 0 0 0 0 ];

Rob2.plot(q,'workspace',[-1.5 1.5 -1.5 1.5 -0.5 1]) %x, y, z
Rob2.plot(q,'scale',0.8,'trail',{'r', 'LineWidth', 2})
Rob2.teach()
view(0,90)