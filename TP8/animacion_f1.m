clc; clear;

global R X_F1_IDEAL Y_F1_IDEAL Z_F1_LEVANTADO DIAMETRO_RUEDA T_rueda_local;

robot;

X_F1_IDEAL = 2;
Y_F1_IDEAL = -1.4462;
Z_F1_LEVANTADO = 0.1; % El auto se levanta con un gato

LARGO_AUTO = 5.490;
ANCHO_AUTO_DEL = 1.852;
DIAMETRO_RUEDA = 0.72;
ANCHO_RUEDA_DEL = 0.305;

% Distancias desde el centro del auto al centro de la rueda
% delantera izquierda
DIST_CENTRO_AUTO_RUEDA_X = -1.4462; % medido en el stl
DIST_CENTRO_AUTO_RUEDA_Y = -ANCHO_AUTO_DEL/2+ANCHO_RUEDA_DEL/2;

% Posición de la rueda referida al sistema de coordenadas centrado en el auto
pos_rueda_local = [DIST_CENTRO_AUTO_RUEDA_X, -ANCHO_AUTO_DEL/2+ANCHO_RUEDA_DEL/2, 0];  
T_rueda_local   = eye(4);
T_rueda_local(1:3,4) = pos_rueda_local(:);
T_rueda_local(1:3,1:3) = [0 0 1; 0 -1 0; 1 0 0];

R.plot([0 -pi/2 0 0 0 0], 'workspace', workspace);

fv = stlread('f1_car.stl'); 
V = fv.Points * 0.001; % el stl está en mm
F = fv.ConnectivityList;

centro_modelo = (min(V, [], 1) + max(V, [], 1)) / 2;
centro_modelo(3) = 0;
V = V - centro_modelo;

% Coloco el F1 en su posición ideal
M = makehgtform('translate',[X_F1_IDEAL Y_F1_IDEAL Z_F1_LEVANTADO],'zrotate',-pi/2);
tform = hgtransform('Matrix',M);

h = patch('Faces', F, 'Vertices', V, ...
      'FaceColor', '#0000dd', ...
      'EdgeColor', 'none', ...
      'FaceAlpha', 0.9);
set(h, 'Parent', tform);

axis equal
camlight; lighting gouraud
rotate3d off; pan off; zoom off;

% Evento para presionar teclas
set(gcf, 'WindowKeyPressFcn', @(src,event) moverModelo(src,event,tform));

disp("Pulsar la tecla:");
disp("'m': Mueve el auto a una posición aleatoria");
disp("'a': Anima el auto llegando al box");
disp("IMPORTANTE: Desactivar rotación 3D en el plot para poder pulsar las teclas");

function T_FL = moverModelo(~, event, tform)

    global R X_F1_IDEAL Y_F1_IDEAL Z_F1_LEVANTADO DIAMETRO_RUEDA T_rueda_local;

    % Si se presiona la tecla 'm', se genera una nueva posición aleatoria para el auto
    if strcmp(event.Key, 'm')
        
        % Generamos pequeños desplazamientos y rotación al azar del F1 
        desplazamiento_x = (rand - 0.5) * 0.2;     % Valor al azar entre -0.1 y 0.1
        desplazamiento_y = (rand - 0.5) * 0.2;     % Valor al azar entre -0.1 y 0.1
        rotacion_z = (rand - 0.5) * (10 * pi/180); % Rotación al azar de +/- 5 grados
        
        % Calculamos la nueva posición final
        pose_final.x = X_F1_IDEAL + desplazamiento_x;
        pose_final.y = Y_F1_IDEAL + desplazamiento_y;
        pose_final.theta = -pi/2 + rotacion_z;
        
        % Guardamos esta posición para usarla después con la tecla 'a'
        setappdata(gcf, 'pose_final', pose_final);
        
        % Creamos la matriz para mover el auto a su nueva posición
        M = makehgtform('translate', [pose_final.x, pose_final.y, Z_F1_LEVANTADO], 'zrotate', pose_final.theta);
        
        % Aplicamos la transformación al modelo 3D del auto
        set(tform, 'Matrix', M);
    
        % Matriz de t. homog. del centro de la rueda del. izq
        T_FL = M * T_rueda_local * trotx(pi/2);
        T_FL(3,4) = DIAMETRO_RUEDA/2 + Z_F1_LEVANTADO; % Z no cambia
        
        % Matriz de t. homog. a 40 cm del centro de la rueda perpendicular
        % al F1. 
        T_FL_40cm = T_FL;
        T_FL_40cm(1:3,4) = T_FL(1:3,4) - T_FL(1:3,3) * 0.4;

        % --- Generación de trayectorias ---
        
        % por ahora solo muevo el robot al punto 3
        R.plot(R.ikine(T_FL_40cm));
        rotate3d off; pan off; zoom off;
        
        
    % Si se presiona la tecla 'a', se anima el auto llegando al box
    elseif strcmp(event.Key, 'a')
        
        % Verifico si ya se guardó una posición con la tecla 'm'
        if isappdata(gcf, 'pose_final')
            pose = getappdata(gcf, 'pose_final');

            % Punto de partida para la animación (detrás del auto)
            distancia_atras = 6;
            x_inicial = pose.x + distancia_atras * cos(pose.theta);
            y_inicial = pose.y + distancia_atras * sin(pose.theta);

            % Puntos intermedios para la animación
            pasos_animacion = 25;
            posiciones_x = linspace(x_inicial, pose.x, pasos_animacion);
            posiciones_y = linspace(y_inicial, pose.y, pasos_animacion);

            % Bucle para animar el movimiento
            for i = 1:pasos_animacion
                M = makehgtform('translate', [posiciones_x(i), posiciones_y(i), Z_F1_LEVANTADO], 'zrotate', pose.theta);
                set(tform, 'Matrix', M);
                drawnow; % Actualiza el dibujo en cada paso
            end
        else
            disp('Primero presiona "m" para generar una posición a la cual animar.');
        end
    end
end