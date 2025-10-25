function T_FL = Graficar(siGrafico)
    global R X_F1_IDEAL Y_F1_IDEAL Z_F1_LEVANTADO DIAMETRO_RUEDA T_rueda_local Ts;
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
    
    fv = stlread('f1_car.stl'); 
    V = fv.Points * 0.001; % el stl está en mm
    F = fv.ConnectivityList;
    
    centro_modelo = (min(V, [], 1) + max(V, [], 1)) / 2;
    centro_modelo(3) = 0;
    V = V - centro_modelo;
    
    % Coloco el F1 en su posición ideal
    M = makehgtform('translate',[X_F1_IDEAL Y_F1_IDEAL Z_F1_LEVANTADO],'zrotate',-pi/2);
    tform = hgtransform('Matrix',M);
    if siGrafico
        h = patch('Faces', F, 'Vertices', V, ...
          'FaceColor', '#0000dd', ...
          'EdgeColor', 'none', ...
          'FaceAlpha', 0.9);
    set(h, 'Parent', tform);

    axis equal
    camlight; lighting gouraud
    rotate3d off; pan off; zoom off;
    end
            
    % Generamos pequeños desplazamientos y rotación al azar del F1 
    desplazamiento_x = (rand - 0.5) * 0.2;
    desplazamiento_y = (rand - 0.5) * 0.2;
    rotacion_z = (rand - 0.5) * (10 * pi/180);
    
    % Nueva posición final del F1
    pose_final.x = X_F1_IDEAL + desplazamiento_x;
    pose_final.y = Y_F1_IDEAL + desplazamiento_y;
    pose_final.theta = -pi/2 + rotacion_z;
    
    % Guardamos la posición
    setappdata(gcf, 'pose_final', pose_final);
    
    % Matriz de transformación del vehículo
    M = makehgtform('translate', [pose_final.x, pose_final.y, Z_F1_LEVANTADO], ...
                    'zrotate', pose_final.theta);
    
    T_FL = M * T_rueda_local * trotx(pi/2);
    T_FL(3,4) = DIAMETRO_RUEDA/2 + Z_F1_LEVANTADO;
    
    % Verifico si ya se guardó una posición
    if isappdata(gcf, 'pose_final')
        pose = getappdata(gcf, 'pose_final');
    
        distancia_atras = 6;
        x_inicial = pose.x + distancia_atras * cos(pose.theta);
        y_inicial = pose.y + distancia_atras * sin(pose.theta);
    
        pasos_animacion = 25;
        posiciones_x = linspace(x_inicial, pose.x, pasos_animacion);
        posiciones_y = linspace(y_inicial, pose.y, pasos_animacion);
        
        if siGrafico
            for i = 1:pasos_animacion
                M = makehgtform('translate', [posiciones_x(i), posiciones_y(i), Z_F1_LEVANTADO], ...
                                'zrotate', pose.theta);
                set(tform, 'Matrix', M);
                drawnow;
            end
        end
    else
        disp('Primero ejecuta moverModelo(''m'', tform) para generar una posición.');
    end
end


