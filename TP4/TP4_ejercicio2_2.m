clc, clear, close all
%Matriz dh del Paint Mate 200iA (FANUC)
DH = [
    0.000  0.450  0.075  -pi/2 0.000;
    0.000  0.000  0.300  0.000 0.000;
    0.000  0.000  0.075  -pi/2 0.000;
    0.000  0.320  0.000  pi/2 0.000;
    0.000  0.000  0.000  -pi/2 0.000;
    0.000  0.008  0.000  0.000 0.000];

Q = {
    [0, 0, 0, 0, 0, 0]
    [pi/4, -pi/2, 0, 0, 0, 0]
    [pi/5, -2*pi/5, -pi/10, pi/2, 3*pi/10, -pi/2]
    [-0.61, -0.15, -0.30, 1.4, 1.9, -1.4]
};
R = SerialLink(DH,'name','Paint Mate 200iA (FANUC)');
for i=1:numel(Q)
    fprintf('\n==========Caso %d ==========\n', i);
    q=Q{i};
  %Genero la matriz mediante el toolbox y la guardo en forma de matriz en caso de que no la tenga  
    T_toolbox = toT(R.fkine(q));

%
    T_manual=eye(numel(Q));
    for j =1:size(DH,1)
        A_toolbox = toT(R.links(j).A(q(j)));

        fila = [q(j),DH(j,2),DH(j,3),DH(j,4)];

        A_manual = devolverMatriz(fila);
        T_manual = T_manual * A_manual;
       % fprintf('  Articulación %d: ||A_toolbox - A_manual|| = %.0e\n', j, norm(A_toolbox - A_manual));
    end
    T_manual = T_manual
   % T_toolbox = T_toolbox
end


%Como el toolbox no devuelve siempre una matriz...
function T = toT(X)
    if isa(X,'SE3')
        T = X.T;        % si es un objeto SE3 → saco la matriz homogénea 4x4
    elseif isa(X,'SO3')
        T = rt2tr(double(X)); % si es SO3 (rotación 3x3) → lo paso a 4x4 con traslación nula
    elseif isa(X,'double')
        T = X;          % si ya es double (matriz), no hago nada
    else
        T = double(X);  % intento conversión genérica (por si es otro tipo)
    end
end


function A = devolverMatriz(fila)
    theta = fila(1); d = fila(2); a = fila(3); alpha = fila(4);
    A = trotz(theta) * transl(0,0,d) * transl(a,0,0) * trotx(alpha);
end

