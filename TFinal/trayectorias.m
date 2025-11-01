clear; clc;
robotA;
robotB;

%robotAenEspera
qqA=[pi/2,0,0,0,0,0];
T0A=RA.fkine(qqA);
P5 = [1.5 0 0.46];
T5 = eye(4);
T5(1:3,4) = P5;
T5(1:3, 1:3) = [0 0 1; 0 -1 0; 1 0 0];

Ts1A={T0A,T5};

[q1A,qd1A,qdd1A,qqA]=gTrayectoria_a(Ts1A,RA,qqA);

%robotBenEspera

qqB=[-pi/2,0,0,0,0,0];
T0B=RB.fkine(qqB);    
P1B = [0 -2 1.515];
P2B = [0 -2  0.3525];
P3B= [0 -2  0.1525];
T1B=trotx(pi);
T1B(1:3,4)=P1B;

T2B = T1B;
T2B(1:3,4) = P2B;

T3B=T2B;
T3B(1:3,4)=P3B;

Ts1B={T0B,T1B,T2B};
Tsc1B={T2B,T3B};

[q1aB,qd1aB,qdd1aB,qqB]=gTrayectoria_a(Ts1B,RB,qqB);
[q1cB,qd1cB,qdd1cB,qqB]=gTrayectoria_c(Tsc1B,RB,qqB);

q1B=[q1aB;q1cB];

%Llega el auto y comienza el cambio

P1A =[0 2 1.515];
P2A = [0 2  0.3525];
P3A= [0 2  0.1525];

%PUNTO AUXILIAR HASTA TENER EL REAL
Paux=[2 0 0.46];

T1A=trotx(pi);
T1A(1:3,4)=P1A;

T2A = T1A;
T2A(1:3,4) = P2A;

T3A=T2A;
T3A(1:3,4)=P3A;

%T_rueda=graficar
T_rueda=T5;
T_rueda(1:3,4)=Paux;
T_FL_40cm = T_rueda;
T_FL_40cm(1:3,4) = T_rueda(1:3,4) - T_rueda(1:3,3) * 0.4;

T_BEspera_40cm=T_FL_40cm;
T_BEspera_40cm(2,4) = T_FL_40cm(2,4) - 0.8;

T_AEspera_40cm=T_FL_40cm;
T_AEspera_40cm(2,4) = T_FL_40cm(2,4) + 0.8;

Ts2A={T5,T_FL_40cm,T_rueda,T_FL_40cm};
Ts2B={T3B,T2B,T_BEspera_40cm,T_BEspera_40cm};

Ts3A={T_FL_40cm,T_AEspera_40cm,T3A,T2A};
Ts3B={T_BEspera_40cm,T_FL_40cm,T_rueda,T_FL_40cm};

[qR1A,qdR1A,qddR1A,qqA]=gTrayectoria_c(Ts2A,RA,qqA);
[qR1B,qdR1B,qddR1B,qqB]=gTrayectoria_a(Ts2B,RB,qqB);

[qR2A,qdR2A,qddR2A,qqA]=gTrayectoria_a(Ts3A,RA,qqA);
[qR2B,qdR2B,qddR2B,qqB]=gTrayectoria_c(Ts3B,RB,qqB);

q2A=[qR1A;qR2A];
q2B=[qR1B;qR2B];

%Homming Final

Ts3A={T2A,T0A};
Ts3B={T_FL_40cm,T0B};

[q3A,qd3A,qdd3A,qqA]=gTrayectoria_a(Ts3A,RA,qqA);
[q3B,qd3B,qdd3B,qqB]=gTrayectoria_a(Ts3B,RB,qqB);

save('trayectorias_robots.mat','q1A','q1B','q2A','q2B','q3A','q3B');