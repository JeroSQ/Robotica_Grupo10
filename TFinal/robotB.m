% robot.m para el trabajo final
% ROBOT KUKA KR 50 R2100

dhB = [
    0.000  0.575  0.175  -pi/2 0;
    0.000  0.000  0.890  0.000 0;
    0.000  0.000  0.050  -pi/2 0;
    0.000  1.035  0.000  pi/2 0;
    0.000  0.000  0.000  -pi/2 0;
    0.000  0.185  0.000  0.000 0];

RB = SerialLink(dhB,'name','KUKA KR 50 2100-B');
q = [0,0,0,0,0,0];

% Límites de cada articulación
RB.qlim(1,1:2) = [-185,  185]*pi/180;
RB.qlim(2,1:2) = [-175,  60]*pi/180;
RB.qlim(3,1:2) = [-120, 165]*pi/180;
RB.qlim(4,1:2) = [-180,  180]*pi/180;
RB.qlim(5,1:2) = [-125,  125]*pi/180;
RB.qlim(6,1:2) = [-350,  350]*pi/180;

% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
RB.offset = [0 -pi/2 0 0 0 0 ];

% base
% Es una matriz homogénea que representa la transformación del sistema de coordenadas global 
% al sistema de coordenadas de la base del robot.
% Por ahora asumimos uno genérico
RB.base = transl(0,-0.75,0);

% tool
% Es una matriz homogénea, pero describe la transformación desde la última articulación
% hasta el effector. Asumimos uno genérico
RB.tool = transl(0, 0, 0.245);

% [-limX, +limX, -limY, +limY, -limZ, +limZ]
workspaceB = [-3, 3, -3, 3, -2, 3];