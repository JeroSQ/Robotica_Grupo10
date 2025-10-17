
robot;

syms q1 q2 q3 q4 q5 q6 real
q = [q1 q2 q3 q4 q5 q6];

DHq = sym(dh);                      
DHq(:,1) = dh(:,1) + q';   % matriz denavit hartenberg simbólica (en robot.m la primer columa es 
                           % un vector de ceros)     

A = @(th,d,a,al) trotz(th) * transl(0,0,d) * transl(a,0,0) * trotx(al);

T = sym(eye(4));               
o = sym(zeros(3,7));         
z = sym(zeros(3,7));        
o(:,1) = [0;0;0];              
z(:,1) = [0;0;1];             

disp('Calculando Jacobiano (~5 segundos)...');
for i = 1:6
    T = T * A(DHq(i,1), DHq(i,2), DHq(i,3), DHq(i,4));
    o(:,i+1) = T(1:3,4);      
    z(:,i+1) = T(1:3,3);       
end
on = o(:,end);                 

Jv = sym(zeros(3,6));
Jw = sym(zeros(3,6));
for i = 1:6
    Jv(:,i) = cross(z(:,i), on - o(:,i));  % z_{i-1} × (o_n - o_{i-1})
    Jw(:,i) = z(:,i);                      % z_{i-1}
end
J0_sym = [Jv; Jw];

J0_sym = simplify(J0_sym);

disp('J=');disp(J0_sym)

disp('Calculando Determinante (~50 segundos)...');
disp('Ver de 1 a 3 reels mientras se calcula o no funciona');
D = simplify(det(J0_sym));                        
factores = factor(D);               
terms = arrayfun(@char, factores, 'UniformOutput', false);
terms{3} = ['(' terms{3} ')'];
producto_txt = strjoin(terms, ' * ');

disp('det(J)=');
disp(producto_txt);
% El primer factor es una constante, el segundo es sin(q5), por lo que hay 
% una singularidad cuando q5 = 0. Por los límites articulares, q5 no puede
% ser pi ni -pi
% El tercer factor sólo depende de q2 y q3.

Dfun = matlabFunction(D, 'Vars', {[q1 q2 q3 q4 q5 q6]});
qnom = zeros(1,6);
qnom(5) = pi/2; % para que no se me anule sin(q5)

step = 300;
q2_vec = linspace(R.qlim(2,1), R.qlim(2,2), step);
q3_vec = linspace(R.qlim(3,1), R.qlim(3,2), step);

umbral = 1e-5;
singularidades = false(step, step);       
parejas = [];                      % lista de (q2,q3) que hacen det=0

for i = 1:step
    for j = 1:step
        qnom(2) = q2_vec(i);
        qnom(3) = q3_vec(j);
        Dj = abs(Dfun(qnom));
        if Dj < umbral
            singularidades(i,j) = true;
            parejas(end+1, :) = [q2_vec(i), q3_vec(j)]; 
        end
    end
end

fprintf('Puntos encontrados: %d\n', size(parejas,1));
if ~isempty(parejas)
    disp(parejas(1:min(10,size(parejas,1)), :));
end

disp('Calculo el det para el primer punto para chequear:');
j = R.jacob0([0 parejas(1, 1) parejas(1,2) 0 pi/2 0])
d = det(j)
