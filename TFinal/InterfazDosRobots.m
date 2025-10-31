function InterfazDosRobots()
    % === Cargar robots ===
    robotA;
    robotB;

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
        'String','TareaRAenEspera (RA)', ...
        'FontSize',11,'Position',[20 350 200 40], ...
        'Callback', @(~,~) tareaRAenEspera(RA));
    
    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','TareaRBenEspera (RB)', ...
        'FontSize',11,'Position',[20 300 200 40], ...
        'Callback', @(~,~) tareaRBenEspera(RB));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','EntraAuto', ...
        'FontSize',11,'Position',[20 250 200 40], ...
        'Callback', @(~,~) entraAuto());

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','cambiodeRueda (RA,RB)', ...
        'FontSize',11,'Position',[20 200 200 40], ...
        'Callback', @(~,~) cambioDeRueda(RA,RB));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','Tarea Simultánea', ...
        'FontSize',11,'Position',[20 150 200 40], ...
        'Callback', @(~,~) tareaSimultanea(RA, RB));

    uicontrol('Parent', panel, 'Style','pushbutton', ...
        'String','Reiniciar Robots', ...
        'FontSize',11,'Position',[20 100 200 40], ...
        'Callback', @(~,~) resetRobots(RA, RB));
end

% === FUNCIONES DE TAREAS ===
function tareaRAenEspera(RA)
    qq=[pi/2,0,0,0,0,0];
    T0A=RA.fkine(qq);
    P5 = [1.2 0 0.46];
    T5 = eye(4);
    T5(1:3,4) = P5;
    T5(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];

    Ts={T0A,T5};

    [q1,qd1,qdd1]=gTrayectoria_a(Ts,RA,qq);

    for i=1:size(q1,1)
        RA.animate(q1(i,:));
        drawnow
    end
end

function tareaRBenEspera(RB)
    qq=[-pi/2,0,0,0,0,0];
    T0=RB.fkine(qq);    
    P1 = [0 -2 1.515];
    P2 = [0 -2  0.3525];
    P3= [0 -2  0.1525];
    T1=trotx(pi);
    T1(1:3,4)=P1;

    T2 = T1;
    T2(1:3,4) = P2;

    T3=T2;
    T3(1:3,4)=P3;

    Ts={T0,T1,T2};
    Tsc={T2,T3};

    [q1,qd1,qdd1]=gTrayectoria_a(Ts,RB,qq);
    [q1c,qd1c,qdd1c]=gTrayectoria_c(Tsc,RB,qq);
    
    q1t=[q1;q1c];

    for i=1:size(q1t,1)
        RB.animate(q1t(i,:));
        drawnow
    end
end

function entraAuto()
    %Poner la funcion de graficar del jero actualizada
end

function cambioDeRueda(RA,RB)
    qq=[-pi/2,0,0,0,0,0];
    T0=RB.fkine(qq);    
    P1 = [0 -2 1.515];
    P2 = [0 -2  0.3525];
    P3= [0 -2  0.1525];
    P5 = [0.75 0 0.46];
    T1=trotx(pi);
    T1(1:3,4)=P1;

    T2 = T1;
    T2(1:3,4) = P2;

    T3=T2;
    T3(1:3,4)=P3;

    T5 = eye(4);
    T5(1:3,4) = P5;
    T5(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];
    T_rueda=Graficar(0);
    T_FL_40cm = T_rueda;
    T_FL_40cm(1:3,4) = T_rueda(1:3,4) - T_rueda(1:3,3) * 0.4;

    T_BEspera_40cm=T_FL_40cm;
    T_BEspera_40cm(2,4) = T_FL_40cm(1:3,4) - 0.5;


    Ts={T5,T_FL_40cm,T_rueda,T_FL_40cm};
    Ts2={T3,T_BEspera_40cm,T_BEspera_40cm,T_BEspera_40cm};

    [q1,qd1,qdd1]=gTrayectoria_c(Ts,RA,qq);
    [q1a,qd1a,qdd1a]=gTrayectoria_a(Ts2,RB,qq);
    
    for i=1:size(q1,1)
        RA.animate(q1(i,:));
        RB.animate(q1a(i,:));
        drawnow
    end
end
function tareaC(RA,RB)
    P1 = [0 -1.5 1.515];    % inicio (dentro del alcance con base=I)
    P1A= [0 1.5 1.515];
    P2 = [0 -1.610  0.3525];   % destino
    P2A= [0 1.610  0.3525];
    P5 = [0.75 0 0.46];
    P5A= [0.75 0 0.46];
    qq = [0,0,0,0,0,0];
    T = RA.fkine(qq).T;
    orientacion = T(1:3,1:3);
    
    T1 = zeros(4,4);
    T1(1:3, 1:3) = orientacion;
    T1(1:3,4) = P1;
    T1(4,:) = [0,0,0,1];

    T1A = zeros(4,4);
    T1A(1:3, 1:3) = orientacion;
    T1A(1:3,4) = P1A;
    T1A(4,:) = [0,0,0,1];
    
    T2 = T1;
    T2(1:3,4) = P2;

    T2A = T1A;
    T2A(1:3,4) = P2A;
    
    % === Tercera pose: bajar 0.1525 m en Z desde P2 ===
    T3 = T2;
    T3(3,4) = T2(3,4) - 0.2;   % desplazamiento en Z negativo

    T3A = T2A;
    T3A(3,4) = T2A(3,4) - 0.2;   % desplazamiento en Z negativo
    
    % === Cuarta pose: subir 0.40 m en Z desde T3 ===
    T4 = T3;
    T4(3,4) = T3(3,4) + 0.208;  % desplazamiento en Z positivo

    T4A = T3A;
    T4A(3,4) = T3A(3,4) + 0.208;  % desplazamiento en Z positivo
    
    % === Quinta pose: paralela al eje X en P5 ===
    T5 = eye(4);
    T5(1:3,4) = P5;
    T5(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];

    T5A = eye(4);
    T5A(1:3,4) = P5A;
    T5A(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];
    
    Ts={T1,T2,T3,T4,T5};
    Ts2={T1A,T2A,T3A,T4A,T5A};
    
    [q1,qd1,qdd1]=gTrayectoria_a(Ts2,RA,qq);
    [q1a,qd1a,qdd1a]=gTrayectoria_a(Ts,RB,qq);

    for i=1:size(q1,1)
        RA.animate(q1(i,:));
        RB.animate(q1a(i,:));
        drawnow
    end

end

function tareaSimultanea(RA,RB)
    disp('Ejecutando tarea simultánea...');
    q1 = jtraj(zeros(1,6), [pi/3 -pi/4 pi/6 0 pi/6 0], 30);
    q2 = jtraj(zeros(1,6), [-pi/3 pi/4 -pi/6 0 pi/4 0], 30);
    for i=1:size(q1,1)
        RA.animate(q1(i,:));
        RB.animate(q2(i,:));
        drawnow
    end
end

function resetRobots(RA,RB)
    disp('Reiniciando robots...');
    RA.animate([pi/2,0,0,0,0,0]);
    RB.animate([-pi/2,0,0,0,0,0]);
    drawnow
end
