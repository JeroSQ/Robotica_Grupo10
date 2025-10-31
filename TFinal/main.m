clc; clear; close all;
robotUno;
robotDos
disp("Articular=0")
disp("Cartesiana=1")
opcion=input("Ingrese opcion: ");
%%Trayectoria1%%
qq=[0,-pi/2,0,0,pi/2,0];
P1 = [0 -1.220 1.515];    % inicio (dentro del alcance con base=I)
P2 = [-0.5 -0.860  0.3525];   % destino
P5 = [0.75 0 0.46];
qq = [0,0,0,0,0,0];
T = R1.fkine(qq).T;
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

Ts={T1,T2,T3,T4,T5};
Ts2={T5,T4,T3,T2,T1};
if opcion==0
    [q1,qd1,qdd1]=gTrayectoria_a(Ts,R1,qq);
    [q1a,qd1a,qdd1a]=gTrayectoria_a(Ts2,R2,qq);
else
    [q1,qd1,qdd1]=gTrayectoria_c(Ts,R1,qq);
    [q1a,qd1a,qdd1a]=gTrayectoria_c(Ts2,R2,qq);
end

figure(1);
ts=1:100;
R1.plot(q1(1,:), 'delay', 0, 'noname', 'nojaxes', 'nowrist');
hold on;
R2.plot(q1a(1,:), 'delay', 0, 'noname', 'nojaxes', 'nowrist');
for i=2:length(q1)
    R1.animate(q1(i,:));
    R2.animate(q1a(i,:));
    drawnow limitrate
end

T_rueda=Graficar(1);


T_FL_40cm = T_rueda;
T_FL_40cm(1:3,4) = T_rueda(1:3,4) - T_rueda(1:3,3) * 0.4;

Ts2={T5,T_FL_40cm,T_rueda,T_FL_40cm,T1};

if opcion==1
    [q2,qd2,qdd2]=gTrayectoria_a(Ts2,R1,qq);
else
    [q2,qd2,qdd2]=gTrayectoria_c(Ts2,R1,qq);
end

qf=[q1; q2];
qdf=[qd1; qd2];
qddf=[qdd1; qdd2];
%%

figure(2);
qplot(qf);
grid on;
title('Posición articular');
xlabel('Muestras');
ylabel('Ángulo articular [rad]');
rotate3d off; pan off; zoom off;
figure(3);
qplot(qdf);
grid on;
title('Velocidad articular');
xlabel('Muestras');
ylabel('Velocidad [rad/s]');
rotate3d off; pan off; zoom off;
figure(4);
qplot(qddf);
grid on;
title('Aceleración articular');
xlabel('Muestras');
ylabel('Aceleración [rad/s^2]');
rotate3d off; pan off; zoom off;

% === Calcular coordenadas cartesianas del efector final ===
N = size(qf,1);
p = zeros(N,3);    % posición (x, y, z)
rpy = zeros(N,3);  % orientación (roll, pitch, yaw)

for i = 1:N
    Tf = R1.fkine(qf(i,:));
    p(i,:) = Tf.t';                    % posición cartesiana
    rpy(i,:) = tr2rpy(Tf.R, 'xyz');    % orientación en RPY
end

% Concatenar en una sola matriz de 6 columnas [x y z roll pitch yaw]
xyzrpy = [p rpy];

% === Derivar numéricamente ===
dt = 1;   % o tu paso real de muestreo (p. ej. 0.01)
v_cart = gradient(xyzrpy, dt);   % velocidades cartesianas
a_cart = gradient(v_cart, dt);   % aceleraciones cartesianas

% === Graficar ===
t=1:N;
figure(5);
plot(t,xyzrpy);
grid on;
title('Posición y orientación cartesianas del efector final');
xlabel('Muestras');
ylabel('Coordenadas [m / rad]');
legend('x','y','z','roll','pitch','yaw');
rotate3d off; pan off; zoom off;

figure(6);
plot(t,v_cart);
grid on;
title('Velocidad cartesiana del efector final');
xlabel('Muestras');
ylabel('Velocidad [m/s / rad/s]');
legend('v_x','v_y','v_z','\omega_x','\omega_y','\omega_z');
rotate3d off; pan off; zoom off;

figure(7);
plot(t,a_cart);
grid on;
title('Aceleración cartesiana del efector final');
xlabel('Muestras');
ylabel('Aceleración [m/s^2 / rad/s^2]');
legend('a_x','a_y','a_z','\alpha_x','\alpha_y','\alpha_z');
rotate3d off; pan off; zoom off;




%%






    






