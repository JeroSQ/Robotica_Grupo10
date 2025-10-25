% --- Caso 1: trayectoria articular (jtraj) ---
[x_art, y_art, z_art] = deal(zeros(length(q),1));
for i = 1:length(q)
    T = R.fkine(q(i,:));
    x_art(i) = T.t(1);
    y_art(i) = T.t(2);
    z_art(i) = T.t(3);
end

% --- Caso 2: trayectoria cartesiana (ctraj + ikine) ---
[x_cart, y_cart, z_cart] = deal(zeros(length(q_trayectoria),1));
for i = 1:length(q_trayectoria)
    T = R.fkine(q_trayectoria(i,:));
    x_cart(i) = T.t(1);
    y_cart(i) = T.t(2);
    z_cart(i) = T.t(3);
end

t = linspace(0,2,length(q));

%%GRAFICOS COMPARATIVOD
figure;
subplot(3,1,1);
plot(t, x_art, 'b', t, x_cart, '--r', 'LineWidth',1.2);
title('Componente X del efector');
xlabel('Tiempo [s]'); ylabel('X [m]');
legend('Espacio articular (jtraj)','Espacio cartesiano (ctraj)');
grid on;

subplot(3,1,2);
plot(t, y_art, 'b', t, y_cart, '--r', 'LineWidth',1.2);
title('Componente Y del efector');
xlabel('Tiempo [s]'); ylabel('Y [m]');
legend('Espacio articular','Espacio cartesiano');
grid on;

subplot(3,1,3);
plot(t, z_art, 'b', t, z_cart, '--r', 'LineWidth',1.2);
title('Componente Z del efector');
xlabel('Tiempo [s]'); ylabel('Z [m]');
legend('Espacio articular','Espacio cartesiano');
grid on;

%%EJERCICIO 4.4
figure;
plot(x_art, z_art, 'b', 'LineWidth', 1.5); hold on;
plot(x_cart, z_cart, '--r', 'LineWidth', 1.5);
xlabel('X [m]');
ylabel('Z [m]');
title('Trayectoria del efector en el plano X–Z');
legend('Espacio articular (jtraj)', 'Espacio cartesiano (ctraj)', 'Location', 'best');
grid on;
axis equal;                     % escala 1:1 para apreciar la forma real
xlim([0 0.4]);
ylim([0.94 1.0]);               % ajustá según tus datos reales

