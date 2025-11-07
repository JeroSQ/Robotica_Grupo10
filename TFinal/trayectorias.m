%clear all; clc; close all;
robotA;
robotB;
escena = generarEscena();

%% Trayectorias calculadas %%
% 1: RA Llega a T5
% 2: RB se acomoda con la rueda a la derecha
% 3: RA saca la rueda
% 4: RA sale hacia la izquierda y RB entra para hacer el cambio
% 5: RB coloca la nueva rueda
% 6: RA deja la rueda vieja a un lado y hace homing
% 7: RB hace homing

%Los pasos 1 y 2 y, 6 y 7 se pueden realizar de manera asincrona o sincrona
%El paso 4 es el unico que verdaderamente necesita sincronismo

%% Definicion de los T antes de los pasos %%
qqA=[pi/2,0,0,0,pi/2,0];
qqB=[-pi/2,0,0,0,pi/2,0];

P5 = [1.5 0 0.46];

P1A =[0 2 1.515];
P2A = [0 2  0.3525];
P3A = [0 2  0.1525];
P6A = [1.2 0.8 0.66];
P4A = [1.2 0.8 0.46];

P1B =[0 -2 1.515];
P2B = [0 -2  0.4525];
P3B = [0 -2  0.1525];
P6B = [1.2 -0.8 0.66];
P4B = [1.2 -0.8 0.46];

T5 = eye(4);
T5(1:3,4) = P5;
T5(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];

T0A=RA.fkine(qqA);
T0B=RB.fkine(qqB);

T1A=trotx(pi);
T1A(1:3,4)=P1A;

T2A = T1A;
T2A(1:3,4) = P2A;

T3A = T2A;
T3A(1:3,4) = P3A;

T4A=T5;
T4A(1:3,4) = P4A;

T6A=T4A;
T6A(1:3,4) = P6A;

T1B=trotx(pi);
T1B(1:3,4) = P1B;

T2B = T1B;
T2B(1:3,4) = P2B;

T3B = T2B;
T3B(1:3,4) = P3B;

T4B=T5;
T4B(1:3,4) = P4B;

T6B=T4B;
T6B(1:3,4) = P6B;

T_rueda=escena.T_rueda_detenida_global;
T_FL_40cm = T_rueda;
T_FL_40cm(1:3,4) = T_rueda(1:3,4) - T_rueda(1:3,3) * 0.6;


%% PASO 1 %%
Ts1A={T0A,T4A};
[q1A,qd1A,qdd1A,qqA]=gTrayectoria_a(Ts1A,RA,qqA);

%% PASO 2 %%
Ts2Ba1={T0B,T2B};
Ts2Bc={T2B,T3B};
Ts2Ba2={T3B,T2B};
Ts2Ba3={T2B,T6B,T4B};

[q2aB,qd2aB,qdd2aB,qqB]=gTrayectoria_a(Ts2Ba1,RB,qqB);
[q2cB,qd2cB,qdd2cB,qqB]=gTrayectoria_c(Ts2Bc,RB,qqB);
[q2dB,qd2dB,qdd2dB,qqB]=gTrayectoria_a(Ts2Ba2,RB,qqB);
[q2eB,qd2eB,qdd2eB,qqB]=gTrayectoria_ms(Ts2Ba3,RB,qqB); %mstraj

q2B=[q2aB;q2cB;q2dB;q2eB];
qd2B=[qd2aB;qd2cB;qd2dB;qd2eB];
qdd2B=[qdd2aB;qdd2cB;qdd2dB;qdd2eB];

q2B0 = [q2aB;q2cB];
q2B1 = [q2dB; q2eB];
qd2B0 = [qd2aB;qd2cB];
qd2B1 = [qd2dB; qd2eB];
qdd2B0 = [qdd2aB;qdd2cB];
qdd2B1 = [qdd2dB;qdd2eB];

%% PASO 3 %%
Ts3A00={T4A,T_FL_40cm};
Ts3A01={T_FL_40cm,T_rueda};
Ts3A1={T_rueda, T_FL_40cm};
[q3A00,qd3A00,qdd3A00,qqA]=gTrayectoria_a(Ts3A00,RA,qqA);
[q3A01,qd3A01,qdd3A01,qqA]=gTrayectoria_c(Ts3A01,RA,qqA);
[q3A1,qd3A1,qdd3A1,qqA]=gTrayectoria_c(Ts3A1,RA,qqA);

q3A0=[q3A00;q3A01];
qd3A0=[qd3A00;qd3A01];
qdd3A0=[qdd3A00;qdd3A01];

%% PASO 4 %%
Ts4A={T_FL_40cm,T4A};
Ts4B={T4B,T_FL_40cm};
[q4A,qd4A,qdd4A,qqA]=gTrayectoria_a(Ts4A,RA,qqA);
[q4B,qd4B,qdd4B,qqB]=gTrayectoria_a(Ts4B,RB,qqB);
%% PASO 5 %%
Ts5B0={T_FL_40cm,T_rueda};
Ts5B1={T_rueda,T_FL_40cm};

[q5B0,qd5B0,qdd5B0,qqB]=gTrayectoria_c(Ts5B0,RB,qqB);
[q5B1,qd5B1,qdd5B1,qqB]=gTrayectoria_c(Ts5B1,RB,qqB);

%% PASO 6 %%
Ts6Aa2={T2A,T0A};
Ts6Ac={T3A,T2A};
Ts6Aa1={T4A,T6A,T2A,T3A};

[q6aA,qd6aA,qdd6aA,qqA]=gTrayectoria_ms(Ts6Aa1,RA,qqA);
[q6cA,qd6cA,qdd6cA,qqA]=gTrayectoria_c(Ts6Ac,RA,qqA);
[q6dA,qd6dA,qdd6dA,qqA]=gTrayectoria_a(Ts6Aa2,RA,qqA);

q6A0=q6aA;
q6A1=[q6cA;q6dA];
qd6A0=qd6aA;
qd6A1=[qd6cA;qd6dA];
qdd6A0=qdd6aA;
qdd6A1=[qdd6cA;qdd6dA];
%% PASO 7 %%
Ts7B={T_FL_40cm,T0B};
[q7B,qd7B,qdd7B,qqB]=gTrayectoria_a(Ts7B,RB,qqB);


save('trayectorias_robots.mat','q1A','q2B0', 'q2B1','q3A0', 'q3A1','q4A','q4B','q5B0', 'q5B1','q6A0', 'q6A1','q7B');
save('escena.mat', 'escena');


qfA=[q1A;q3A0;q3A1;q4A;q6A0;q6A1];
qdfA=[qd1A;qd3A0;qd3A1;qd4A;qd6A0;qd6A1];
qddfA=[qdd1A;qdd3A0;qdd3A1;qdd4A;qdd6A0;qdd6A1];

qfB=[q2B0;q2B1;q4B;q5B0;q5B1;q7B];
qdfB=[qd2B0;qd2B1;qd4B;qd5B0;qd5B1;qd7B];
qddfB=[qdd2B0;qdd2B1;qdd4B;qdd5B0;qdd5B1;qdd7B];
%%
% === CALCULAR INDICES PARA LAS LINEAS VERTICALES ===
idxA = cumsum([0;
               size(q1A,1);
               size(q3A0,1) + size(q3A1,1);
               size(q4A,1);
               size(q6A0,1) + size(q6A1, 1)]); 

idxB = cumsum([0;
               size(q2B0,1) + size(q2B1,1);
               size(q4B,1);
               size(q5B0,1) + size(q5B1,1)]); 

figure;

subplot(3,1,1);
qplot(qfA);

xline(idxA, 'k--', 'HandleVisibility','off');

labelsA = ["Paso 1","Paso 3","Paso 4","Paso 6"];
labelsB = ["Paso 2","Paso 4","Paso 7"];

yl = ylim;
yText = 1.9;  

for k = 1:numel(labelsA)
    
    xm = (idxA(k) + idxA(k+1)) / 2;

    text(xm, yText, labelsA(k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment',   'bottom', ... 
        'Clipping', 'off');               
end

hold off;

grid on;
t1 = title('Posición articular Robot A');
t1.Units = 'normalized';
t1.Position(2) = 1.2;
xlabel('Muestras');
ylabel('Ángulo articular [rad]');
rotate3d off; pan off; zoom off;
subplot(3,1,2);
qplot(qdfA);
xline(idxA, 'k--', 'HandleVisibility','off')
grid on;
title('Velocidad articular Robot A');
xlabel('Muestras');
ylabel('Velocidad [rad/s]');
rotate3d off; pan off; zoom off;

subplot(3,1,3);
qplot(qddfA);
xline(idxA, 'k--', 'HandleVisibility','off')
grid on;
title('Aceleración articular Robot A');
xlabel('Muestras');
ylabel('Aceleración [rad/s^2]');
rotate3d off; pan off; zoom off;

figure;

subplot(3,1,1);
qplot(qfB);

for k = 1:numel(labelsB)
    
    xm = (idxB(k) + idxB(k+1)) / 2;

    text(xm, yText, labelsB(k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment',   'bottom', ... 
        'Clipping', 'off');               
end


xline(idxB, 'k--', 'HandleVisibility','off')
grid on;
t2 = title('Posición articular Robot B');
t2.Units = 'normalized';
t2.Position(2) = 1.2;
xlabel('Muestras');
ylabel('Ángulo articular [rad]');
rotate3d off; pan off; zoom off;

subplot(3,1,2);
qplot(qdfB);
xline(idxB, 'k--', 'HandleVisibility','off')
grid on;
title('Velocidad articular Robot B');
xlabel('Muestras');
ylabel('Velocidad [rad/s]');
rotate3d off; pan off; zoom off;

subplot(3,1,3);
qplot(qddfB);
xline(idxB, 'k--', 'HandleVisibility','off')
grid on;
title('Aceleración articular Robot B');
xlabel('Muestras');
ylabel('Aceleración [rad/s^2]');
rotate3d off; pan off; zoom off;


% === Calcular coordenadas cartesianas del efector final ===
NA = size(qfA,1);
pA = zeros(NA,3);    % posición (x, y, z)
rpyA = zeros(NA,3);  % orientación (roll, pitch, yaw)

NB = size(qfB,1);
pB=zeros(NB,3);
rpyB = zeros(NB,3);

for i = 1:NA
    TfA = RA.fkine(qfA(i,:));
    pA(i,:) = TfA.t';                    % posición cartesiana
    rpyA(i,:) = tr2rpy(TfA.R, 'xyz');    % orientación en RPY
end

for i = 1:NB
    TfB = RB.fkine(qfB(i,:));
    pB(i,:) = TfB.t';                    % posición cartesiana
    rpyB(i,:) = tr2rpy(TfB.R, 'xyz');    % orientación en RPY
end

%Corrijo cambios bruscos de fase
rpyA = unwrap(rpyA);
rpyB = unwrap(rpyB);

% Concatenar en una sola matriz de 6 columnas [x y z roll pitch yaw]
xyzrpyA = [pA rpyA];
xyzrpyB = [pB rpyB];

% === Derivar numéricamente ===
dt = 1;   % o tu paso real de muestreo (p. ej. 0.01)

v_cartA = diff(pA);   % velocidades cartesianas
a_cartA = diff(v_cartA);   % aceleraciones cartesianas

v_cartB = diff(pB);   % velocidades cartesianas
a_cartB = diff(v_cartB);   % aceleraciones cartesianas

% === Graficar ===
tA=1:NA;

tB=1:NB;

figure;
subplot(3,1,1);
plot(pA);
for k = 1:numel(labelsA)
    
    xm = (idxA(k) + idxA(k+1)) / 2;

    text(xm, yText, labelsA(k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment',   'bottom', ... 
        'Clipping', 'off');               
end
xline(idxA, 'k--')
grid on;
t3 = title('Posición cartesiana del efector final Robot A');
t3.Units = 'normalized';
t3.Position(2) = 1.2;
xlabel('Muestras');
ylabel('Coordenadas [m]');
legend('x','y','z');
rotate3d off; pan off; zoom off;

subplot(3,1,2);
plot(v_cartA);
xline(idxA, 'k--')
grid on;
title('Velocidad cartesiana del efector final Robot A');
xlabel('Muestras');
ylabel('Velocidad [m/s]');
legend('v_x','v_y','v_z');
rotate3d off; pan off; zoom off;

subplot(3,1,3);
plot(a_cartA);
xline(idxA, 'k--')
grid on;
title('Aceleración cartesiana del efector final Robot A');
xlabel('Muestras');
ylabel('Aceleración [m/s^2]');
legend('a_x','a_y','a_z');
rotate3d off; pan off; zoom off;

figure;
subplot(3,1,1);
plot(pB);
xline(idxB, 'k--')
for k = 1:numel(labelsB)
    
    xm = (idxB(k) + idxB(k+1)) / 2;

    text(xm, yText, labelsB(k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment',   'bottom', ... 
        'Clipping', 'off');               
end
grid on;
t4 = title('Posición cartesiana del efector final Robot B');
t4.Units = 'normalized';
t4.Position(2) = 1.2;
xlabel('Muestras');
ylabel('Coordenadas [m]');
legend('x','y','z');
rotate3d off; pan off; zoom off;

subplot(3,1,2);
plot(v_cartB);
xline(idxB, 'k--')
grid on;
title('Velocidad cartesiana del efector final Robot B');
xlabel('Muestras');
ylabel('Velocidad [m/s]');
legend('v_x','v_y','v_z');
rotate3d off; pan off; zoom off;

subplot(3,1,3);
plot(a_cartB);
xline(idxB, 'k--')
grid on;
title('Aceleración cartesiana del efector final Robot B');
xlabel('Muestras');
ylabel('Aceleración [m/s^2]');
legend('a_x','a_y','a_z');
rotate3d off; pan off; zoom off;

