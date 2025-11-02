classdef Animador < handle
    % Clase encargada de animar el F1 y las dos ruedas, sincronizada con los
    % efectores de RA y RB. Recibe datos de escena y crea/gestiona
    % los objetos STL

    properties
        ax
        escena
        estado
        pasosAnimacionAuto

        nodo_auto
        malla_auto
        nodo_soporte_rueda         

        nodo_rueda_nueva
        malla_rueda_nueva

        nodo_rueda_gastada
        malla_rueda_gastada

        geometria_rueda

        matriz_auto_actual
    end

    methods
        function animador = Animador(ax, escena)

            animador.ax = ax;
            animador.escena = escena;
            animador.pasosAnimacionAuto = 25;

            animador.estado.auto = "no_cargado";
            animador.estado.rueda_nueva = "en_piso";
            animador.estado.rueda_gastada = "pegada";

            animador.inicializarGeometriaRueda();
        end

        function mostrarInicial(animador)
            
            % Recupero los datos para la crear la malla
            Xs = animador.geometria_rueda.Xs;
            Ys = animador.geometria_rueda.Ys;
            Zs = animador.geometria_rueda.Zs;

            Xc = animador.geometria_rueda.Xc;
            Yc = animador.geometria_rueda.Yc;
            Ztop = animador.geometria_rueda.Ztop;
            Zbot = animador.geometria_rueda.Zbot;
            
            % Creo el nodo y las mallas
            animador.nodo_rueda_nueva = hgtransform("Parent", animador.ax, "Matrix", animador.escena.T_rueda_nueva_inicial);
            malla_lado_cilindro = surf(Xs, Ys, Zs, 'EdgeColor','none', 'FaceColor',[0.85 0 0], 'Parent', animador.nodo_rueda_nueva, 'FaceLighting','none');
            malla_tapa_cilindro_top  = patch('XData',Xc,'YData',Yc,'ZData',Ztop*ones(size(Xc)),'FaceColor',[0.85 0 0],'EdgeColor','none','Parent',animador.nodo_rueda_nueva);
            malla_tapa_cilindro_bot  = patch('XData',Xc,'YData',Yc,'ZData',Zbot*ones(size(Xc)),'FaceColor',[0.85 0 0],'EdgeColor','none','Parent',animador.nodo_rueda_nueva);
        end

        function actualizarRuedas(animador, T_RA, T_RB, fase)

            % Actualiza las posiciones de las ruedas a medida que se van
            % moviendo los efectores finales.
            % Con 'fase' se especifica en qué etapa del cambio de rueda nos
            % encontramos
            % 'fase' puede ser:
            %
            % -reposo
            % -rueda_nueva_tomada
            % -rueda_gastada_retirada
            % -ruedas_tomadas
            % -rueda_nueva_colocada

            switch string(fase)
                case "rueda_nueva_tomada"
                    
                    % Hago un offset pq considera que la posición de la
                    % rueda es la tapa superior, no el centro
                    set(animador.nodo_rueda_nueva, 'Matrix', T_RB);
                    if ~(animador.estado.rueda_nueva == "tomada")
                        animador.estado.rueda_nueva = "tomada";
                    end

                case "rueda_gastada_retirada"

                    if animador.estado.rueda_gastada == "pegada"
                        % le cambio el Parent a la rueda gastada (pasa del auto a global)
                        set(animador.nodo_rueda_gastada, "Parent", animador.ax, "Matrix", T_RA);
                        animador.estado.rueda_gastada = "tomada";
                    else
                        set(animador.nodo_rueda_gastada, "Matrix", T_RA);
                    end

                case "ruedas_tomadas"
                    set(animador.nodo_rueda_gastada, "Matrix", T_RA);
                    set(animador.nodo_rueda_nueva, 'Matrix', T_RB);

                case "rueda_nueva_colocada"
                   
                    if animador.estado.rueda_nueva == "tomada"
                        % le caambio el parent a la rueda nueva (pasa de global al auto)
                        set(animador.nodo_rueda_nueva, "Parent", animador.nodo_soporte_rueda, "Matrix", eye(4));
                        animador.estado.rueda_nueva = "pegada";
                    end
            end

        end 

        function entraAuto(animador)
            
            animador.cargarAuto();

            % Creo las mallas de la rueda gastada
            Xs = animador.geometria_rueda.Xs;
            Ys = animador.geometria_rueda.Ys;
            Zs = animador.geometria_rueda.Zs;

            Xc = animador.geometria_rueda.Xc;
            Yc = animador.geometria_rueda.Yc;
            Ztop = animador.geometria_rueda.Ztop;
            Zbot = animador.geometria_rueda.Zbot;

            animador.nodo_rueda_gastada = hgtransform("Parent", animador.nodo_soporte_rueda, "Matrix", eye(4));
            
            malla_lado_cilindro = surf(Xs, Ys, Zs, 'EdgeColor','none', 'FaceColor','k', 'Parent', animador.nodo_rueda_gastada, 'FaceLighting','none');
            malla_tapa_cilindro_top  = patch('XData',Xc,'YData',Yc,'ZData',Ztop*ones(size(Xc)),'FaceColor','k','EdgeColor','none','Parent',animador.nodo_rueda_gastada);
            malla_tapa_cilindro_bot  = patch('XData',Xc,'YData',Yc,'ZData',Zbot*ones(size(Xc)),'FaceColor','k','EdgeColor','none','Parent',animador.nodo_rueda_gastada);
            
            N = animador.pasosAnimacionAuto;
            T0 = animador.escena.T_auto_inicial_global;
            T1 = animador.escena.T_auto_detenido_global;
            for k = 1:N
                s = k/N;
                p = (1-s) * T0(1:3,4) + s * T1(1:3,4); % es como un ctraj pero casero. No uso ctraj para que Animador.m no dependa de robot.m
                Tk = eye(4); 
                Tk(1:3,1:3) = T1(1:3,1:3); 
                Tk(1:3,4) = p;
                set(animador.nodo_auto, "Matrix", Tk);
                drawnow
            end

            animador.estado.auto = "detenido";
        end

        function saleAuto(animador)
            
            N = animador.pasosAnimacionAuto;
            T0 = animador.escena.T_auto_detenido_global;
            T1 = animador.escena.T_auto_final_global;
            for k = 1:N
                s = k/N;
                p = (1-s) * T0(1:3,4) + s * T1(1:3,4); % es como un ctraj pero casero. No uso ctraj para que Animador.m no dependa de robot.m
                Tk = eye(4); 
                Tk(1:3,1:3) = T1(1:3,1:3); 
                Tk(1:3,4) = p;
                set(animador.nodo_auto, "Matrix", Tk);
                drawnow
            end

            set(animador.nodo_auto,'Visible','off');

            animador.estado.auto = "ido";

        end

        function reset(animador)
            
            % Borro todo lo gráfico (si existe)
            if isgraphics(animador.nodo_rueda_nueva),   delete(animador.nodo_rueda_nueva);   end
            if isgraphics(animador.nodo_rueda_gastada), delete(animador.nodo_rueda_gastada); end
            if isgraphics(animador.nodo_soporte_rueda), delete(animador.nodo_soporte_rueda); end
            if isgraphics(animador.nodo_auto),          delete(animador.nodo_auto);          end
        
            % Reseteo todo
            animador.nodo_rueda_nueva    = [];
            animador.malla_rueda_nueva   = [];
            animador.nodo_rueda_gastada  = [];
            animador.malla_rueda_gastada = [];
            animador.nodo_soporte_rueda  = [];
            animador.nodo_auto           = [];
            animador.malla_auto          = [];
            animador.matriz_auto_actual  = [];
        
            % Estado inicial
            animador.estado.auto          = "no_cargado";
            animador.estado.rueda_nueva   = "en_piso";
            animador.estado.rueda_gastada = "pegada";
        
            % Vuelvo a mostrar el estado inicial (rueda nueva en el piso)
            animador.mostrarInicial();

        end
    end

    methods (Access = private)
        function inicializarGeometriaRueda(animador)

            % Malla del cilindro, resolución 16
            [Xs,Ys,Zs] = cylinder(animador.escena.DIAMETRO_RUEDA/2, 16); 
            Zs = (Zs -0.5)* animador.escena.ANCHO_RUEDA_DEL; % Ajusto z porque genera dos circulos en z = 0 y otro en z = 1
            
            % Tapas cilindro
            ang = linspace(0, 2*pi, 16+1);
            Xc = animador.escena.DIAMETRO_RUEDA/2 * cos(ang);  
            Yc = animador.escena.DIAMETRO_RUEDA/2 * sin(ang);
            Ztop = animador.escena.ANCHO_RUEDA_DEL/2; 
            Zbot = -animador.escena.ANCHO_RUEDA_DEL/2;

            animador.geometria_rueda.Xs = Xs;
            animador.geometria_rueda.Ys = Ys;
            animador.geometria_rueda.Zs = Zs;

            animador.geometria_rueda.Xc = Xc;
            animador.geometria_rueda.Yc = Yc;
            animador.geometria_rueda.Ztop = Ztop;
            animador.geometria_rueda.Zbot = Zbot;
           
        end

        function cargarAuto(animador)
            
            % Si ya está cargado, no hago nada
            if ~(animador.estado.auto == "no_cargado")
                return;
            end

            caras_y_vertices = stlread('f1_car_sin_rueda.stl');
            vertices = caras_y_vertices.Points / 1000; % lo escalo pq está en mm
            caras = caras_y_vertices.ConnectivityList;

            % Centro los vertices pq el STL viene corrido
            centro  = (min(vertices,[],1) + max(vertices,[],1))/2; 
            centro(3) = 0; 
            vertices= vertices - centro;

            animador.nodo_auto = hgtransform("Parent", animador.ax, "Matrix", animador.escena.T_auto_inicial_global);
            animador.malla_auto = patch('Faces',caras,'Vertices',vertices, ...
                     'FaceColor','#0000dd','EdgeColor','none', ...
                     'FaceAlpha',0.9,'Parent',animador.nodo_auto, ...
                     'FaceLighting','none','SpecularStrength',0,'AmbientStrength',0.8);

            animador.nodo_soporte_rueda = hgtransform("Parent", animador.nodo_auto, "Matrix", animador.escena.T_rueda_auto);

            animador.estado.auto = "cargado";
        end
    end
end
            