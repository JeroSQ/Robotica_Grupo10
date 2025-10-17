
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
D = simplify(det(J0_sym));                        
factores = factor(D);               
terms = arrayfun(@char, factores, 'UniformOutput', false);
terms{3} = ['(' terms{3} ')'];
producto_txt = strjoin(terms, ' * ');

disp('det(J)=');
disp(producto_txt);