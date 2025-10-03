clc,clear
% Ejemplo rápido (ajustá tu DH real)
dh = [0 0 0    0    0;    % theta d a alpha sigma
      0 0 0.3  0    0;
      0 0 0.2 -pi/2 0;
      0 0.15 0  pi/2 0;   % solo por si L3 = d4
      0 0 0 -pi/2 0;
      0 0.1 0  0    0];

R = SerialLink(dh,'name','MiRobot');

% Elegí una postura y obtené el centro de muñeca:
q_true = [0.6; 0.4; -0.2; 0; 0; 0];
T06 = R.fkine(q_true);
pc = T06.t - dh(6,2) * T06.n;   % p_c = p_6 - d6*z6 (si aplica)

[Q123, T03_list] = Ejercicio1_5(R, pc)

% Verificación: todas las T03 deben terminar en el mismo punto pc (respecto a {0})
for i = 1:4
    T03 = T03_list{i};
    p3  = T03(1:3,4);
    fprintf('err %d = %.3e\n', i, norm(p3 - pc));
end
