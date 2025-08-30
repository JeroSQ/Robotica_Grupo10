clc, clear, close all;
robot;

% b. Definición de un vector de posiciones articulares
q = [0, -pi/4, 0, pi/4, pi/3, 0]; 

% c. Definición de un vector de booleanos para sistemas de referencia
% [sistema{0}, sistema{1}, sistema{2}, sistema{3}, sistema{4}, sistema{5}, sistema{6}]
sistemas = [1, 1, 1, 1, 1, 1, 1];  % 1 = visualizar, 0 = ocultar

% d. Ploteo del robot
figure('Name', 'Sistemas de Referencia DH', 'NumberTitle', 'off');
R.plot(q, 'scale', 0.5, 'jointdiam', 0.8, 'notiles', 'workspace', workspace);
hold on;

% e. Bucle para graficar sistemas de referencia
[T,all]=R.fkine(q);
for i = 1:R.n
    if sistemas(i+1) == 1
        if i==1
            trplot(R.base,'length',0.5,'frame',num2str(i-1),'color','k');
        else
            trplot(all(i-1),'length',0.5,'frame',num2str(i-1),'color','k');
        end
    end
end

title('KUKA KR 50 2100 - Sistemas de Referencia');
grid on;
hold off;