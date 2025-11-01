clear; clc;
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
qqA=[pi/2,0,0,0,0,0];
qqB=[-pi/2,0,0,0,0,0];

P5 = [1.5 0 0.46];

P1A =[0 2 1.515];
P2A = [0 2  0.3525];
P3A = [0 2  0.1525];
P4A = [1.5 0.8 0.46];

P1B =[0 -2 1.515];
P2B = [0 -2  0.3525];
P3B = [0 -2  0.1525];
P4B = [1.-5 0.8 0.46];

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
T4A(2,4) = 0.8;

T1B=trotx(pi);
T1B(1:3,4) = P1B;

T2B = T1B;
T2B(1:3,4) = P2B;

T3B = T2B;
T3B(1:3,4) = P3B;

T4B=T5;
T4B(2,4) = - 0.8;

T_rueda=escena.T_rueda_detenida_global;
T_FL_40cm = T_rueda;
T_FL_40cm(1:3,4) = T_rueda(1:3,4) - T_rueda(1:3,3) * 0.4;


%% PASO 1 %%
Ts1A={T0A,T5};
[q1A,qd1A,qdd1A,qqA]=gTrayectoria_a(Ts1A,RA,qqA);

%% PASO 2 %%
Ts2Ba1={T0B,T1B,T2B};
Ts2Bc={T2B,T3B};
Ts2Ba2={T3B,T2B,T4B};

[q2aB,qd2aB,qdd2aB,qqB]=gTrayectoria_a(Ts2Ba1,RB,qqB);
[q2cB,qd2cB,qdd2cB,qqB]=gTrayectoria_c(Ts2Bc,RB,qqB);
[q2dB,qd2dB,qdd2dB,qqB]=gTrayectoria_a(Ts2Ba2,RB,qqB);

q2B=[q2aB;q2cB;q2dB];
qd2B=[qd2aB;qd2cB;qd2dB];
qdd2B=[qdd2aB;qdd2cB;qdd2dB];

q2B0 = [q2aB;q2cB];
q2B1 = q2dB;
qd2B0 = [qd2aB;qd2cB];
qd2B1 = qd2dB;
qdd2B0 = [qdd2aB;qdd2cB];
qdd2B1 = qdd2dB;

%% PASO 3 %%
Ts3A0={T5,T_FL_40cm,T_rueda};
Ts3A1={T_rueda, T_FL_40cm};
[q3A0,qd3A0,qdd3A0,qqA]=gTrayectoria_c(Ts3A0,RA,qqA);
[q3A1,qd3A1,qdd3A1,qqA]=gTrayectoria_c(Ts3A1,RA,qqA);

%% PASO 4 %%
Ts4A={T_FL_40cm,T4A};
Ts4B={T4B,T_FL_40cm};
[q4A,qd4A,qdd4A,qqA]=gTrayectoria_a(Ts4A,RA,qqA);
[q4B,qd4B,qdd4B,qqA]=gTrayectoria_a(Ts4B,RB,qqA);
%% PASO 5 %%
Ts5B0={T_FL_40cm,T_rueda};
Ts5B1={T_rueda,T_FL_40cm};
[q5B0,qd5B0,qdd5B0,qqA]=gTrayectoria_a(Ts5B0,RB,qqA);
[q5B1,qd5B1,qdd5B1,qqA]=gTrayectoria_a(Ts5B1,RB,qqA);
%% PASO 6 %%
Ts6Aa2={T2A,T1A,T0A};
Ts6Ac={T3A,T2A};
Ts6Aa1={T4A,T2A,T3A};

[q6aA,qd6aA,qdd6aA,qqA]=gTrayectoria_a(Ts6Aa1,RA,qqA);
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