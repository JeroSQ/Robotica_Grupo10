function InterfazDosRobots()
    % === Cargar robots ===
    robotA;
    robotB;
    load('trayectorias_robots.mat','q1A','q2B','q3A','q4A','q4B','q5B','q6A','q7B');

    % === Crear ventana principal ===
    fig = figure('Name','Control Interactivo de Dos Robots', ...
                 'NumberTitle','off', 'Position',[100 100 1200 650]);

    % === Panel lateral de control ===
    panel = uipanel('Parent', fig, 'Units', 'normalized', ...
                    'Position', [0.02 0.05 0.25 0.9], ...
                    'Title', 'Panel de Control', ...
                    'FontSize', 12, 'FontWeight', 'bold');

    % === Área de visualización ===
    ax = axes('Parent', fig, 'Position', [0.32 0.1 0.65 0.8]);
    view(ax, 3);
    grid(ax, 'on');
    axis(ax, 'auto');         % <<< Ajuste automático
    axis(ax, 'equal');        % Mantiene proporciones reales
    xlabel(ax, 'X'); ylabel(ax, 'Y'); zlabel(ax, 'Z');
    title(ax, 'Visualización de RA y RB');
    hold(ax, 'on');


    % === Dibujar robots ===
    RA.plot([pi/2,0,0,0,0,0], 'workspace', [-1.5 2 -1.5 1.5 0 1.5], ...
        'delay', 0, 'nojaxes', 'noname', 'nowrist');
    hold on
    RB.plot([-pi/2,0,0,0,0,0], 'workspace', [-1.5 2 -1.5 1.5 0 1.5], ...
        'delay', 0, 'nojaxes', 'noname', 'nowrist');

    % === Botones (dentro del panel lateral) ===
    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 1', ...
        'FontSize',11,'Position',[20 550 200 40], ...
        'Callback', @(~,~) animarUnRobot(RA,q1A));
    
    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 2', ...
        'FontSize',11,'Position',[20 500 200 40], ...
        'Callback', @(~,~) animarUnRobot(RB,q2B));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','EntraAuto', ...
        'FontSize',11,'Position',[20 450 200 40], ...
        'Callback', @(~,~) entraAuto());

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 3', ...
        'FontSize',11,'Position',[20 400 200 40], ...
        'Callback', @(~,~) animarUnRobot(RA,q3A));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 4', ...
        'FontSize',11,'Position',[20 350 200 40], ...
        'Callback', @(~,~) animarDosRobots(RA,RB,q4A,q4B));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 5', ...
        'FontSize',11,'Position',[20 300 200 40], ...
        'Callback', @(~,~) animarUnRobot(RB,q5B));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','SaleAuto', ...
        'FontSize',11,'Position',[20 250 200 40], ...
        'Callback', @(~,~) saleAuto());

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 6', ...
        'FontSize',11,'Position',[20 200 200 40], ...
        'Callback', @(~,~) animarUnRobot(RA,q6A));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 7', ...
        'FontSize',11,'Position',[20 150 200 40], ...
        'Callback', @(~,~) animarUnRobot(RB,q7B));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','SecuenciaCompleta', ...
        'FontSize',11,'Position',[20 100 200 40], ...
        'Callback', @(~,~) secuenciaCompleta(RA,RB,q1A,q2B,q3A,q4A,q4B,q5B,q6A,q7B));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','Reiniciar Robots', ...
        'FontSize',11,'Position',[20 50 200 40], ...
        'Callback', @(~,~) resetRobots(RA, RB));
end

% === FUNCIONES DE TAREAS ===
function animarUnRobot(R,q)
    for i=1:size(q,1)
        R.animate(q(i,:));
        drawnow
    end
end

function animarDosRobots(RA,RB,qA,qB)
    for i=1:size(qA,1)
        RA.animate(qA(i,:));
        RB.animate(qB(i,:));
        drawnow
    end
end

function entraAuto()
    %Poner la funcion de graficar del jero actualizada
end

function saleAuto()
    %Poner la funcion de graficar del jero actualizada
end

function secuenciaCompleta(RA,RB,q1A,q2B,q3A,q4A,q4B,q5B,q6A,q7B)
    animarUnRobot(RA,q1A);
    animarUnRobot(RB,q2B);
    entraAuto();
    animarUnRobot(RA,q3A);
    animarDosRobots(RA,RB,q4A,q4B);
    animarUnRobot(RB,q5B);
    saleAuto();
    animarUnRobot(RA,q6A);
    animarUnRobot(RB,q7B);

end

function resetRobots(RA,RB)
    disp('Reiniciando robots...');
    RA.animate([pi/2,0,0,0,0,0]);
    RB.animate([-pi/2,0,0,0,0,0]);
    drawnow
end
