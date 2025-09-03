clc; clear;

robot;

% La idea de la primer visualización es recrear el esquema del espacio de
% trabajo que se muestra en la datasheet del robot. Es decir, en el plano
% x1z1. Para ello sólo nos interesa mover las articulaciones 2,3 y 5.
% Para ello seguimos la secuencia especificada en el informe.

% Para la segunda visualización, mostramos una vista superior.

qlim = R.qlim;

N = 10;  % Puntos por segmento para la primera vista
N2 = 20; % Puntos por segmento para la segunda vista

% Límites útiles
q1min = R.qlim(1,1);  q1max = R.qlim(1,2);
q2min = R.qlim(2,1);  q2max = R.qlim(2,2);
q3min = R.qlim(3,1);  q3max = R.qlim(3,2);

% Punto inicial
Qall = [];
q0 = [0, q2min, q3max, 0, -pi/2, 0];

% Voy creando los segmentos, me guardo el último punto
% para empezar el próximo segmento y voy guardando
% los resultados en la matriz Qall

Qseg = crear_segmento(q0, 2, q2max, N, false);      
Qall = [Qall; Qseg];
qk   = Qseg(end,:);

Qseg = crear_segmento(qk, 5, 0, N, true);           
Qall = [Qall; Qseg];
qk   = Qseg(end,:);

Qseg = crear_segmento(qk, 3, 0, N, true);           
Qall = [Qall; Qseg];
qk   = Qseg(end,:);

Qseg = crear_segmento(qk, 2, q2min, N, true);       
Qall = [Qall; Qseg];
qk   = Qseg(end,:);

Qseg = crear_segmento(qk, 3, q3min, N, true);       
Qall = [Qall; Qseg];
qk   = Qseg(end,:);

Qseg = crear_segmento(qk, 2, -pi/4, N, true);       
Qall = [Qall; Qseg];
qk   = Qseg(end,:);

% Cerrar el lazo (conectar último con el primero)
Qall = [Qall; q0];

T  = R.fkine(Qall);      % Obtengo las matrices de TF Homog
P  = transl(T);          % [x y z] para cada punto
XZ = P(:,[1 3]);         % columnas x y z

q_robot = [0 -pi/2 pi/2 0 0 0];
R.plot(q_robot, 'workspace', workspace, 'view', [0 0]);

view(0,0);
hold on; grid on; axis equal
plot3(XZ(:,1), zeros(size(XZ(:,1))), XZ(:,2), '-o', 'LineWidth', 1.2, 'MarkerSize', 3);
xlabel('X [m]'); zlabel('Z [m]');
title('Vista lateral (plano XZ)');
rotate3d off;

% VISTA SUPERIOR

% Trayectoria: solo q1 varía; q2..q6 = 0
Qtop = repmat([0 0 0 0 0 0], N2, 1);
Qtop(:,1) = linspace(q1min, q1max, N2)';

Ttop = R.fkine(Qtop);
Ptop = transl(Ttop);   % [x y z]
XY   = Ptop(:, 1:2);   % [x y]

% Figura nueva con el robot y la trayectoria, vista superior
figure('Color','w');
R.plot(q_robot, 'workspace', workspace, 'view', [0 90]);


view(0,90);
hold on; grid on; axis equal;
rotate3d off;
set(gca, 'CameraViewAngleMode','manual');

plot3(XY(:,1), XY(:,2), zeros(size(XY,1),1), 'r-o', 'LineWidth',1.2, 'MarkerSize',3);

xlabel('X [m]'); ylabel('Y [m]');
title('Vista superior (plano XY)');

function Qsegmentos = crear_segmento(q_inicial, indice_art, q_final, N, omitir_primero)
%Genera una trayectoria donde solo varía una articulación
%
% Entradas:
%   q_inicial     -> vector fila con las 6 articulaciones iniciales
%   indice_art -> número de la articulación que queremos variar (1 a 6)
%   q_final       -> valor final para esa articulación
%   N           -> cantidad de puntos en el trayecto
%   omitir_primero  -> si es true (1), se omite el primer punto
%
% Salida:
%   Qsegmentos -> matriz [M x 6] con los valores articulares de cada punto
%                 (M = N si omitir_primero = false, M = N-1 si omitir_primero = true)

    % Inicializamos la matriz con el valor inicial repetido N veces
    Qsegmentos = repmat(q_inicial, N, 1);

    % Reemplazamos la columna de la articulación que queremos variar
    % con valores que van desde q_start(joint_index) hasta q_end
    Qsegmentos(:, indice_art) = linspace(q_inicial(indice_art), q_final, N)';

    if omitir_primero
        Qsegmentos = Qsegmentos(2:end, :);
    end
end
