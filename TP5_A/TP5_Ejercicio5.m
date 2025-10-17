function TP5_Ejercicio5
clc, close all
%Aca se deben configurar los valores de posicion y orientacion del robot
%Se debe configurar desde el mismo código
    % Posición deseada (x,y) y orientación gamma
    x = 0.156;
    y = 0.5;
    g = 0*(pi/180); %Completar el número en grados

    % Parámetros del robot
    a1 = 0.5;
    a2 = 0.4;
    a3 = 0.3;

    dh = [
    0.000  0.000  a1  0.000 0.000;
    0.000  0.000  a2  0.000 0.000;
    0.000  0.000  a3  0.000 0.000];

R = SerialLink(dh,'name','Spong 2005_1');

% Límites de cada articulación
R.qlim(1,1:2) = [-180,  180]*pi/180;
R.qlim(2,1:2) = [-180,  180]*pi/180;
R.qlim(3,1:2) = [-180, 180]*pi/180;



    % Calcular soluciones de cinemática inversa
    qsol = Cinem_inv(a1,a2,a3,dh,x,y,g);

    % Filtrar soluciones fuera de los límites
    for i = 1:size(qsol,1)
        if any(qsol(i,:) < R.qlim(:,1)') || any(qsol(i,:) > R.qlim(:,2)')
            qsol(i,:) = NaN; % marcar como inválida
        end
    end

% Muestro los resultados
    fprintf('Soluciones de cinemática inversa (en radianes):\n');
    disp(qsol);

    fprintf('Soluciones en grados:\n');
    disp(qsol*(180/pi));

    validas = sum(~isnan(qsol(:,1)));
    fprintf('Número de soluciones válidas dentro de los límites: %d\n',validas);
end

function qsol = Cinem_inv(a1,a2,a3,dh,x,y,g)
    qsol=zeros(2,3); 

    % Posición del sistema 2 respecto de la base
    x2 = x - a3*cos(g);
    y2 = y - a3*sin(g);

    % Cálculo de q1
    r = sqrt(x2^2+y2^2);
    beta = atan2(y2,x2);
    alfa = acos((a2^2 - a1^2 - r^2)/(-2*a1*r));

    qsol(1,1) = beta + alfa; % Solución 1
    qsol(2,1) = beta - alfa; % Solución 2

    % Cálculo de q2
    for i=1:2
        T1 = Transf_Sistemas(dh(1,:),qsol(i,1));
        P2_1 = T1 \ [x2;y2;0;1];
        qsol(i,2) = atan2(P2_1(2),P2_1(1));
    end

    % Cálculo de q3
    for i=1:2
        T1 = Transf_Sistemas(dh(1,:),qsol(i,1));
        T2 = T1 * Transf_Sistemas(dh(2,:),qsol(i,2));
        P3_2 = T2 \ [x;y;0;1];
        qsol(i,3) = atan2(P3_2(2),P3_2(1));
    end
end

function T = Transf_Sistemas(fila_dh, q)
    T = trotz(q)*transl(0,0,fila_dh(2))*transl(fila_dh(3),0,0)*trotx(fila_dh(4));
end
