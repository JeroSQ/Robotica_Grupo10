function escena = generarEscena

    % Esta función devuelve un struct con todos los puntos y matrices
    % necesarias para animar los STL y calcular la trayectoria
    % trayectorias.m llama a esta función, y luego guarda el struct escena,
    % que contiene todos los datos en escena.mat
          
    X_F1_IDEAL = 2.5;
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
    pos_rueda_auto = [DIST_CENTRO_AUTO_RUEDA_X, DIST_CENTRO_AUTO_RUEDA_Y, 0];  
    T_rueda_auto   = eye(4);
    T_rueda_auto(1:3,4) = pos_rueda_auto;
    T_rueda_auto(1:3,1:3) = [0 0 1; 0 -1 0; 1 0 0];
    T_rueda_auto = T_rueda_auto * trotx(pi/2);
    
    % Desviacion aleatoria del auto
    rng("shuffle");
    desplazamiento_x = (rand - 0.5) * 0.2;
    desplazamiento_y = (rand - 0.5) * 0.2;
    rotacion_z = (rand - 0.5) * (10 * pi/180);

    auto_detenido.x = X_F1_IDEAL + desplazamiento_x;
    auto_detenido.y = Y_F1_IDEAL + desplazamiento_y;
    auto_detenido.z = Z_F1_LEVANTADO + DIAMETRO_RUEDA / 2;
    auto_detenido.theta = -pi/2 + rotacion_z;

    T_auto_detenido_global = transl(auto_detenido.x, auto_detenido.y, auto_detenido.z) * trotz(auto_detenido.theta);
    T_rueda_detenida_global = T_auto_detenido_global * T_rueda_auto;
    
    distancia_animacion_auto = 6;

    x_inicial_auto = auto_detenido.x + distancia_animacion_auto * cos(auto_detenido.theta);
    y_inicial_auto = auto_detenido.y + distancia_animacion_auto * sin(auto_detenido.theta);
    z_inicial_auto = auto_detenido.z;
    T_auto_inicial_global = transl(x_inicial_auto, y_inicial_auto, z_inicial_auto) * trotz(auto_detenido.z);

    x_final_auto = auto_detenido.x + 2 * distancia_animacion_auto * cos(auto_detenido.theta);
    y_final_auto = auto_detenido.y + 2 * distancia_animacion_auto * sin(auto_detenido.theta);
    z_final_auto = auto_detenido.z;
    T_auto_final_global = transl(x_final_auto, y_final_auto, z_final_auto) * trotz(auto_detenido.z);

    pos_rueda_nueva_inicial = [0 2  0.3525];
    T_rueda_nueva_inicial = trotx(pi);
    T_rueda_nueva_inicial(1:3,4) = pos_rueda_nueva_inicial;

    pos_rueda_gastada_final = [0 -2  0.3525];
    T_rueda_gastada_final = trotx(pi);
    T_rueda_gastada_final(1:3,4) = pos_rueda_gastada_final;

    versor_auto = [cos(auto_detenido.theta); sin(auto_detenido.theta); 0];

    escena = struct();

    escena.X_F1_IDEAL               = X_F1_IDEAL;
    escena.Y_F1_IDEAL               = Y_F1_IDEAL;
    escena.Z_F1_LEVANTADO           = Z_F1_LEVANTADO;
    
    escena.LARGO_AUTO               = LARGO_AUTO;
    escena.ANCHO_AUTO_DEL           = ANCHO_AUTO_DEL;
    escena.DIAMETRO_RUEDA           = DIAMETRO_RUEDA;
    escena.ANCHO_RUEDA_DEL          = ANCHO_RUEDA_DEL;
    
    escena.DIST_CENTRO_AUTO_RUEDA_X = DIST_CENTRO_AUTO_RUEDA_X;
    escena.DIST_CENTRO_AUTO_RUEDA_Y = DIST_CENTRO_AUTO_RUEDA_Y;
    
    escena.pos_rueda_auto           = pos_rueda_auto;
    escena.T_rueda_auto             = T_rueda_auto;
    
    escena.desplazamiento_x         = desplazamiento_x;
    escena.desplazamiento_y         = desplazamiento_y;
    escena.rotacion_z               = rotacion_z;
    
    escena.auto_detenido            = auto_detenido;
    
    escena.T_auto_detenido_global   = T_auto_detenido_global;
    escena.T_rueda_detenida_global  = T_rueda_detenida_global;
    
    escena.distancia_animacion_auto = distancia_animacion_auto;
    
    escena.x_inicial_auto           = x_inicial_auto;
    escena.y_inicial_auto           = y_inicial_auto;
    escena.z_inicial_auto           = z_inicial_auto;
    escena.T_auto_inicial_global    = T_auto_inicial_global;
    
    escena.x_final_auto             = x_final_auto;
    escena.y_final_auto             = y_final_auto;
    escena.z_final_auto             = z_final_auto;
    escena.T_auto_final_global      = T_auto_final_global;
    
    escena.pos_rueda_nueva_inicial  = pos_rueda_nueva_inicial;
    escena.T_rueda_nueva_inicial    = T_rueda_nueva_inicial;
    
    escena.pos_rueda_gastada_final  = pos_rueda_gastada_final;
    escena.T_rueda_gastada_final    = T_rueda_gastada_final;
    
    escena.versor_auto              = versor_auto;

end