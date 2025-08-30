clc, clear, close all;
robot;

% b. Definición de un vector de posiciones articulares a analizar
q = [0, 0, 0, 0, 0, 0];  % Configuración home (todas las articulaciones en cero)

% c. Definición de un vector de booleanos para sistemas de referencia
% [sistema{0}, sistema{1}, sistema{2}, sistema{3}, sistema{4}, sistema{5}, sistema{6}]
sistemas = [1, 1, 1, 1, 1, 1, 1];  % 1 = visualizar, 0 = ocultar

% d. Ploteo del robot con las propiedades recomendadas
figure('Name', 'Sistemas de Referencia DH', 'NumberTitle', 'off');
R.plot(q, 'scale', 0.5, 'jointdiam', 0.8, 'notiles', 'workspace', workspace);
%jointdiam', 0.8,  Reduce el diámetro de las articulaciones
%'notiles',  Elimina el suelo de la visualización
hold on;

% e. Bucle para graficar sistemas de referencia según el vector de booleanos
for i = 0:R.n
    if sistemas(i+1) == 1
        if i == 0
            T = eye(4);   % Sistema base {0}
        else
            T = R.A(1, q);   % inicializamos con el primero
            for j = 2:i
                T = T * R.A(j, q);
            end
        end
        trplot(T, 'frame', num2str(i), 'color', 'r', 'length', 0.2, 'thick', 2);
    end
end

title('KUKA KR 50 2100 - Sistemas de Referencia');
grid on;
hold off;