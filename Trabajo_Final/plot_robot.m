% plot_robot_frames.m
robot;

% Configuración
q = [0, 0, 0, 0, 0, 0];
sistemas = [1, 1, 1, 1, 1, 1, 1];  % Todos los sistemas

% Plot
figure('Name', 'Sistemas de Referencia DH', 'NumberTitle', 'off');
R.plot(q, 'scale', 1, 'jointdiam', 0.8, 'notiles', 'workspace', workspace);
hold on;

% Sistemas de referencia
for i = 0:R.n
    if sistemas(i+1) == 1
        T = R.fkine(q, 'frame', i);
        trplot(T, 'frame', num2str(i), 'color', 'r', 'length', 0.2, 'thick', 2);
    end
end

title('KUKA KR 30 - Sistemas de Referencia');
grid on;
hold off;