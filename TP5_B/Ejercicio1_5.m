function [Q123, T03_list] = Ejercicio1_5(R, pc)
% Calcula las 4 posibles combinaciones (q1, q2, q3) que ubican
% el centro de la muñeca en el punto pc = [xc; yc; zc].

xc = pc(1);
yc = pc(2);
zc = pc(3); % zc no influye en q1, q2 y q3 para este robot

% --- Dos posibles valores para q1 (frente y opuesto)
q1A = atan2(yc, xc);
if q1A > 0
    q1B = q1A - pi;
else
    q1B = q1A + pi;
end
q1_todos = [q1A, q1B];

% --- Longitudes de los eslabones
L2 = R.links(2).a;
L3 = R.links(3).a;
if abs(L3) < eps
    L3 = R.links(4).d; % algunos robots tienen L3=0 y usan d4
end

Q123 = zeros(3,4);
if nargout >= 2
    T03_list = cell(1,4);
end

c = 1;
for k = 1:2
    q1 = q1_todos(k);
    T1 = R.links(1).A(q1).double;
    p1 = invHomog(T1) * [pc;1];
    p1 = p1(1:3);
    x1 = p1(1);
    y1 = p1(2);

    % Distancia desde el eje del segundo eslabón
    r = hypot(x1, y1);
    B = atan2(y1, x1);

    % --- Cálculo de q2 con ley de cosenos
    arg = (L2^2 + r^2 - L3^2) / (2*r*L2);
    arg = max(-1, min(1, arg)); % evita errores numéricos
    G = acos(arg);
    q2_posibles = [B - G, B + G]; % codo arriba y codo abajo

    % --- Para cada q2 se calcula q3
    for i = 1:2
        q2 = q2_posibles(i);
        T2 = T1 * R.links(2).A(q2).double;
        p2 = invHomog(T2) * [pc;1];
        p2 = p2(1:3);

        q3 = atan2(p2(2), p2(1)) - pi/2;

        Q123(:,c) = [q1; q2; q3];

        if nargout >= 2
            T03_list{c} = T2 * R.links(3).A(q3).double;
        end
        c = c + 1;
    end
end
end

% Inversa de una matriz homogénea
function iT = invHomog(T)
iT = eye(4);
iT(1:3,1:3) = T(1:3,1:3)';
iT(1:3,4) = -iT(1:3,1:3) * T(1:3,4);
end
