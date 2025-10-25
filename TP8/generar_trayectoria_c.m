%clc, clear, close all;
%robot;

% === Puntos cartesianos ===
function [q, qd, qdd] = generar_trayectoria_c(T_rueda, R)
%robot;
    P1 = [0 -1.220 1.515];    % inicio (dentro del alcance con base=I)
    P2 = [-0.5 -0.860  0.3525];   % destino
    P5 = [0.75 0 0.46];
    qq = [0,0,0,0,0,0];
    
    T = R.fkine(qq).T;
    orientacion = T(1:3,1:3);
    
    T1 = zeros(4,4);
    T1(1:3, 1:3) = orientacion;
    T1(1:3,4) = P1;
    T1(4,:) = [0,0,0,1];
    
    T2 = T1;
    T2(1:3,4) = P2;
    
    % === Tercera pose: bajar 0.1525 m en Z desde P2 ===
    T3 = T2;
    T3(3,4) = T2(3,4) - 0.2;   % desplazamiento en Z negativo
    
    % === Cuarta pose: subir 0.40 m en Z desde T3 ===
    T4 = T3;
    T4(3,4) = T3(3,4) + 0.208;  % desplazamiento en Z positivo
    
    % === Quinta pose: paralela al eje X en P5 ===
    T5 = eye(4);
    T5(1:3,4) = P5;
    T5(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];
    % Tramo 1: q1 -> q2
    [c12, cd12, cdd12] = ctraj(T1, T2, 100);
    
    % Tramo 2: q2 -> q3
    [c23, cd23, cdd23] = ctraj(T2, T3, 60);
    
    % Tramo 3 (nuevo): q3 -> q4
    [c34, cd34, cdd34] = ctraj(T3, T4, 80);   % podés usar 60/100 también
    
    
    [c45, cd45, cdd45] = ctraj(T4, T5, 80); 
    % (Opcional) pausas con holds entre tramos:


    % Matriz de t. homog. a 40 cm del centro de la rueda perpendicular
    % al F1. 

    T_FL_40cm = T_rueda;
    T_FL_40cm(1:3,4) = T_rueda(1:3,4) - T_rueda(1:3,3) * 0.4;

    q_rueda40 = R.ikine(T_FL_40cm, q5);

    [q5_rueda40, qd5_rueda40, qdd5_rueda40] = jtraj(q5, q_rueda40, 80); 

    q_rueda = R.ikine(T_rueda, q_rueda40);

    [q40_rueda, qd40_rueda, qdd40_rueda] = jtraj(q_rueda40, q_rueda, 80); 
    
    q_rueda2 = R.ikine(T_FL_40cm, q_rueda);
    [q40_rueda2, qd40_rueda2, qdd40_rueda2] = jtraj(q_rueda, q_rueda2, 80);

    q_rueda3 = R.ikine(T1, q_rueda2);
    [q40_rueda3, qd40_rueda3, qdd40_rueda3] = jtraj(q_rueda2, q_rueda3, 80);
    % Trayectoria total
    q   = [q12; q23; q34; q45; q5_rueda40; q40_rueda; q40_rueda2; q40_rueda3 ];
    qd  = [qd12; qd23; qd34; qd45; qd5_rueda40; qd40_rueda; qd40_rueda2; qd40_rueda3];
    qdd = [qdd12; qdd23; qdd34; qdd45; qdd5_rueda40; qdd40_rueda; qdd40_rueda2; qdd40_rueda3];
    

end
