clc; clear;
dh = [
    0.000  0.450  0.075  -pi/2 0.000;
    0.000  0.000  0.300  0.000 0.000;
    0.000  0.000  0.075  -pi/2 0.000;
    0.000  0.320  0.000  pi/2 0.000;
    0.000  0.000  0.000  -pi/2 0.000;
    0.000  0.008  0.000  0.000 0.000];
dh2=dh;
dh3=dh;
dh4=dh;
dh2(:,1)=[pi/4;-pi/2;0;0;0;0];
dh3(:,1)=[pi/5;-2*pi/5;-pi/10;pi/2;3*pi/10;-pi/2];
dh4(:,1)=[-0.61;-0.15;-0.30;1.4;1.9;-1.4];

Matriz=eye(4);
Matriz2=eye(4);
Matriz3=eye(4);
Matriz4=eye(4);
for i=1:size(dh,2)
    Matriz=Matriz*devolverMatriz(dh(i,:));
end
disp("Caso 1: ")
Mostrar(Matriz)

for i=1:size(dh,2)
    Matriz2=Matriz2*devolverMatriz(dh2(i,:));
end
disp("Caso 2: ")
Mostrar(Matriz2)
for i=1:size(dh,2)
    Matriz3=Matriz3*devolverMatriz(dh3(i,:));
end
disp("Caso 3: ")
Mostrar(Matriz3)
for i=1:size(dh,2)
    Matriz4=Matriz4*devolverMatriz(dh4(i,:));
end
disp("Caso 4: ")
Mostrar(Matriz4)



function Matriz=devolverMatriz(elementos)
    m1=trotz(elementos(1));
    m2=transl(0,0,elementos(2));
    m3=transl(elementos(3),0,0);
    m4=trotx(elementos(4));
    Matriz=m1*m2*m3*m4;
end
function Mostrar(Matriz)
    Matriz
    Pitch=atan2(-Matriz(3,1),sqrt(Matriz(1,1)^2+Matriz(2,1)^2));
    Roll=atan2(Matriz(2,1), Matriz(1,1));
    Yaw=atan2(Matriz(3,2), Matriz(3,3));
    disp("Cinematica Directa:")
    disp("X=" + Matriz(1,4));
    disp("Y="+Matriz(2,4));
    disp("Z="+Matriz(3,4));
    disp("R="+Roll);
    disp("P="+Pitch);
    disp("Y="+Yaw);
end

