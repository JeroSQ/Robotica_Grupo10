function InterfazDosRobots()
    clc;clear;close all;

    % === Cargar robots ===
    robotA;
    robotB;
    load('trayectorias_robots.mat','q1A','q2B0', 'q2B1','q3A0', 'q3A1','q4A','q4B','q5B0', 'q5B1','q6A0', 'q6A1','q7B');
    load('escena.mat', 'escena');
    ANIMAR_STL = true;

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
    axis(ax,[-0.5,3.5,-2.5,2.5,0,2.2]);         % <<< Ajuste automático
    axis(ax, 'manual');
    axis(ax, 'equal');        % Mantiene proporciones reales
    xlabel(ax, 'X'); ylabel(ax, 'Y'); zlabel(ax, 'Z');
    title(ax, 'Visualización de RA y RB');
    hold(ax, 'on');

    ax.XLim = [-0.5,3.5];
    ax.YLim = [-2.5,2.5];
    ax.ZLim = [0,2.2];
    ax.XLimMode = 'manual';
    ax.YLimMode = 'manual';
    ax.ZLimMode = 'manual';


    % === Dibujar robots ===
    RA.plot([pi/2,0,0,0,0,0], 'workspace', [-1.5 2 -1.5 1.5 0 1.5], ...
        'delay', 0, 'nojaxes', 'noname', 'nowrist');
    hold on
    RB.plot([-pi/2,0,0,0,0,0], 'workspace', [-1.5 2 -1.5 1.5 0 1.5], ...
        'delay', 0, 'nojaxes', 'noname', 'nowrist');

    % === Creo Animador y muestro la rueda nueva en el piso ===
    animador = Animador(gca, escena);
    if ANIMAR_STL
        animador.mostrarInicial();
    end

    % === Botones (dentro del panel lateral) ===
    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 1', ...
        'FontSize',11,'Position',[20 550 200 40], ...
        'Callback', @(~,~) paso1(RA,q1A,animador,ANIMAR_STL));
    
    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 2', ...
        'FontSize',11,'Position',[20 500 200 40], ...
        'Callback', @(~,~) paso2(RB,q2B0, q2B1,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','EntraAuto', ...
        'FontSize',11,'Position',[20 450 200 40], ...
        'Callback', @(~,~) entraAuto(animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 3', ...
        'FontSize',11,'Position',[20 400 200 40], ...
        'Callback', @(~,~) paso3(RA,q3A0,q3A1,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 4', ...
        'FontSize',11,'Position',[20 350 200 40], ...
        'Callback', @(~,~) paso4(RA,RB,q4A,q4B,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 5', ...
        'FontSize',11,'Position',[20 300 200 40], ...
        'Callback', @(~,~) paso5(RB,q5B0, q5B1,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','SaleAuto', ...
        'FontSize',11,'Position',[20 250 200 40], ...
        'Callback', @(~,~) saleAuto(animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 6', ...
        'FontSize',11,'Position',[20 200 200 40], ...
        'Callback', @(~,~) paso6(RA,q6A0,q6A1,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','PASO 7', ...
        'FontSize',11,'Position',[20 150 200 40], ...
        'Callback', @(~,~) paso7(RB,q7B,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','SecuenciaCompleta', ...
        'FontSize',11,'Position',[20 100 200 40], ...
        'Callback', @(~,~) secuenciaCompleta(RA,RB,q1A,q2B0,q2B1,q3A0,q3A1,q4A,q4B,q5B0, q5B1,q6A0,q6A1,q7B,animador,ANIMAR_STL));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','Reiniciar Robots', ...
        'FontSize',11,'Position',[20 50 200 40], ...
        'Callback', @(~,~) resetRobots(RA, RB,animador,ANIMAR_STL));
end

% Defino paso1 para que haya consistencia
% En realidad no hay que hacer nada con los STL en PASO 1
function paso1(R,q,animador,ANIMAR_STL)
    animarUnRobot(R,q);
end

% Este es el paso donde RB toma la rueda del piso
function paso2(R,q2B0,q2B1,animador,ANIMAR_STL)
    
    animarUnRobot(R,q2B0);

    if ANIMAR_STL
        animarUnRobot(R,q2B1, "rueda_nueva_tomada", animador);
    else
        animarUnRobot(R,q2B1);
    end

end

function entraAuto(animador,ANIMAR_STL)
    if ANIMAR_STL
        animador.entraAuto();
    end
end

% Este es el paso donde se retira la rueda gastada
function paso3(R,q3A0,q3A1,animador,ANIMAR_STL)
    
    animarUnRobot(R,q3A0);

    if ANIMAR_STL
        animarUnRobot(R,q3A1, "rueda_gastada_retirada", animador);
    else
        animarUnRobot(R,q3A1);
    end

end

function paso4(RA, RB, q4A, q4B, animador,ANIMAR_STL)

    if ANIMAR_STL  
        animarDosRobots(RA, RB, q4A, q4B, "ruedas_tomadas", animador);
    else
        animarDosRobots(RA, RB, q4A, q4B);
    end

end

function paso5(R,q5B0,q5B1,animador,ANIMAR_STL)

    if ANIMAR_STL
        animarUnRobot(R,q5B0, "rueda_nueva_tomada", animador);
        animarUnRobot(R,q5B1, "rueda_nueva_colocada", animador);
    else
        animarUnRobot(R,q5B0);
        animarUnRobot(R,q5B1);
    end

end

function saleAuto(animador,ANIMAR_STL)
    if ANIMAR_STL
        animador.saleAuto();
    end
end

function paso6(R,q6A0,q6A1,animador,ANIMAR_STL)
   
    if ANIMAR_STL
        animarUnRobot(R,q6A0, "rueda_gastada_retirada", animador);
    else
        animarUnRobot(R,q6A0);
    end

    animarUnRobot(R,q6A1);

end

function paso7(R,q,animador,ANIMAR_STL)
    animarUnRobot(R,q);
end

% === FUNCIONES DE trayectoria ===
function animarUnRobot(R,q,fase,animador)
    for i=1:size(q,1)
        R.animate(q(i,:));

        % Si tengo que decirle a animador que actualice algo
        if nargin > 2
            T = R.fkine(q(i,:)).T;
            animador.actualizarRuedas(T, T, fase);
        end

        drawnow limitrate
    end
end

function animarDosRobots(RA,RB,qA,qB,fase,animador)
    for i=1:size(qA,1)
        RA.animate(qA(i,:));
        RB.animate(qB(i,:));

        % Si tengo que decirle a animador que actualice algo
        if nargin > 4
            TA = RA.fkine(qA(i,:)).T;
            TB = RB.fkine(qB(i,:)).T;
            animador.actualizarRuedas(TA, TB, fase);
        end

        drawnow limitrate
    end
end

function secuenciaCompleta(RA,RB,q1A,q2B0,q2B1,q3A0,q3A1,q4A,q4B,q5B0, q5B1,q6A0,q6A1,q7B,animador,ANIMAR_STL)
    if ANIMAR_STL
        animador.reset();
    end
    paso1(RA,q1A,animador,ANIMAR_STL);
    paso2(RB,q2B0, q2B1,animador,ANIMAR_STL);
    entraAuto(animador,ANIMAR_STL);
    paso3(RA,q3A0,q3A1,animador,ANIMAR_STL);
    paso4(RA,RB,q4A,q4B,animador,ANIMAR_STL);
    paso5(RB,q5B0, q5B1,animador,ANIMAR_STL);
    saleAuto(animador,ANIMAR_STL);
    paso6(RA,q6A0,q6A1,animador,ANIMAR_STL);
    paso7(RB,q7B,animador,ANIMAR_STL);
end

function resetRobots(RA,RB,animador,ANIMAR_STL)
    disp('Reiniciando robots...');
    RA.animate([pi/2,0,0,0,0,0]);
    RB.animate([-pi/2,0,0,0,0,0]);

    if ANIMAR_STL
        animador.reset();
    end

    drawnow limitrate
end
