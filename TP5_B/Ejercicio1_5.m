function [Q123, T03_list] = Ejercicio1_5(R, pc)
% EJ5_Q123_PC  Calcula las 4 soluciones (theta1, theta2, theta3) que
% posicionan el centro de muñeca en pc = [xc; yc; zc].
% R: SerialLink con DH correcto (al menos eslabones 1..3 bien definidos).
% Devuelve:
%   Q123     -> 3x4, cada columna es [q1; q2; q3]
%   T03_list -> 1x4 celdas con T^0_3 para verificación (opcional)

xc = pc(1); yc = pc(2); zc = pc(3);  % zc no afecta a q1-q2-q3 en este esquema

% --- 1) q1: dos valores (atan2 y el opuesto a 180°)
q1A = atan2(yc, xc);
q1B = (q1A > 0) * (q1A - pi) + (q1A <= 0) * (q1A + pi);
q1_all = [q1A, q1B];

% --- 2) Longitudes del 2° y 3° “lazo” según tu DH
L2 = R.links(2).a;                     % típico: a2
L3 = R.links(3).a;                     % si a3=0 en tu robot, usar d4
if abs(L3) < eps
    L3 = R.links(4).d;                 % común en robots tipo ABB
end

Q123 = zeros(3,4);
if nargout >= 2, T03_list = cell(1,4); end

c = 1;
for k = 1:2                       % por cada q1 (A y B)
    q1 = q1_all(k);
    T1 = R.links(1).A(q1).double;         % A1(q1)
    p1 = invHomog(T1) * [pc;1];  p1 = p1(1:3);
    x1 = p1(1);  y1 = p1(2);

    r = hypot(x1, y1);
    B = atan2(y1, x1);

    % --- 3) q2: dos ramas (codo arriba/abajo) por ley de cosenos
    arg = (L2^2 + r^2 - L3^2) / (2*r*L2);
    arg = max(-1, min(1, arg));          % robustez numérica
    G = acos(arg);

    q2_candidates = [B - G,  B + G];

    % --- 4) Para cada q2 -> q3
    for i = 1:2
        q2 = q2_candidates(i);
        T2 = T1 * R.links(2).A(q2).double;     % A1(q1)*A2(q2)
        p2 = invHomog(T2) * [pc;1];  p2 = p2(1:3);

        % DH típico: x3 sale 90° del radio => -pi/2
        q3 = atan2(p2(2), p2(1)) - pi/2;

        Q123(:,c) = [q1; q2; q3];

        if nargout >= 2
            T03_list{c} = T2 * R.links(3).A(q3).double;
        end
        c = c + 1;
    end
end
end

% --- helper: inversa homogénea eficiente
function iT = invHomog(T)
iT = eye(4);
iT(1:3,1:3) = T(1:3,1:3)';
iT(1:3,4)   = -iT(1:3,1:3) * T(1:3,4);
end
