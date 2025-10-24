% robot.m para el trabajo final
% ROBOT KUKA KR 50 R2100

dh = [
    0.000  0.575  0.175  -pi/2 0;
    0.000  0.000  0.890  0.000 0;
    0.000  0.000  0.050  -pi/2 0;
    0.000  1.035  0.000  pi/2 0;
    0.000  0.000  0.000  -pi/2 0;
    0.000  0.185  0.000  0.000 0];

R = SerialLink(dh,'name','KUKA KR 50 2100');
q = [0,0,0,0,0,0];

% Límites de cada articulación
R.qlim(1,1:2) = [-185,  185]*pi/180;
R.qlim(2,1:2) = [-175,  60]*pi/180;
R.qlim(3,1:2) = [-120, 165]*pi/180;
R.qlim(4,1:2) = [-180,  180]*pi/180;
R.qlim(5,1:2) = [-125,  125]*pi/180;
R.qlim(6,1:2) = [-350,  350]*pi/180;

% offset
% Es un desplazamiento angular o lineal inicial aplicado a cada articulación.
% Útil cuando la referencia física de la articulación no coincide con el cero matemático del modelo.
R.offset = [0 0 0 0 0 0 ];

% base
% Es una matriz homogénea que representa la transformación del sistema de coordenadas global 
% al sistema de coordenadas de la base del robot.
% Por ahora asumimos uno genérico
R.base = transl(-0.5,0.0,0);

% tool
% Es una matriz homogénea, pero describe la transformación desde la última articulación
% hasta el effector. Asumimos uno genérico
R.tool = transl(0, 0, 0.15);

% [-limX, +limX, -limY, +limY, -limZ, +limZ]
workspace = [-3, 3, -3, 3, -2, 3];