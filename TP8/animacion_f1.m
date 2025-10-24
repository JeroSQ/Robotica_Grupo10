clc; clear;

robot;

R.teach([0 -pi/2 0 0 0 0], 'workspace', workspace);

fv = stlread('f1_car.stl'); 

V = fv.Points * 0.001;
F = fv.ConnectivityList;

randoms = (rand(3) - 0.5)*2;
x_desp = randoms(1) * 0.1;
y_desp = randoms(2) * 0.1;
ang_rot = randoms(1) * 5 * pi/180;

M = makehgtform('translate',[2+x_desp 0.1+y_desp 0.1],'zrotate',-pi/2+ang_rot);
tform = hgtransform('Matrix',M);

% Dibujar
h = patch('Faces', F, 'Vertices', V, ...
      'FaceColor', '#0000dd', ...
      'EdgeColor', 'none', ...
      'FaceAlpha', 0.9);
set(h, 'Parent', tform);

axis equal
camlight; lighting gouraud
rotate3d off; pan off; zoom off;

% === Callback de teclado ===
set(gcf, 'WindowKeyPressFcn', @(src,event) moverModelo(src,event,tform));

% --- Función auxiliar ---
function moverModelo(~, event, tform)
    if strcmp(event.Key,'m')   % generar nueva posición
        randoms = (rand(3)-0.5)*2;
        x_desp = randoms(1)*0.1;
        y_desp = randoms(2)*0.1;
        ang_rot = randoms(1)*5*pi/180;

        pose_final = struct('x',2+x_desp, ...
                            'y',0.1+y_desp, ...
                            'theta',-pi/2+ang_rot);

        % Guardar en la FIGURA (no en el tform)
        setappdata(gcf,'pose_final',pose_final);

        M = makehgtform('translate',[pose_final.x pose_final.y 0], ...
                        'zrotate', pose_final.theta);
        set(tform,'Matrix',M);
    end

    if strcmp(event.Key,'a')   % animar hacia la última posición
        if isappdata(gcf,'pose_final')
            pose = getappdata(gcf,'pose_final');

            % Posición inicial detrás del auto en su heading
            d_back = 6; % distancia hacia atrás
            x_ini = pose.x + d_back*cos(pose.theta);
            y_ini = pose.y + d_back*sin(pose.theta);

            % Interpolación
            N = 25;
            xs = linspace(x_ini, pose.x, N);
            ys = linspace(y_ini, pose.y, N);

            for k = 1:N
                M = makehgtform('translate',[xs(k) ys(k) 0], ...
                                'zrotate', pose.theta);
                set(tform,'Matrix',M);
                drawnow;
            end
        else
            disp('Primero pulsa "m" para generar una posición.');
        end
    end
end