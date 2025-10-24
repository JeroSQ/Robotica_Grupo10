
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
% El primer factor es una constante, el segundo es sin(q5), por lo que hay 
% una singularidad cuando q5 = 0. Por los límites articulares, q5 no puede
% ser pi ni -pi
% El tercer factor sólo depende de q2 y q3.

Dfun = matlabFunction(D, 'Vars', {[q1 q2 q3 q4 q5 q6]});
qnom = zeros(1,6);
xyz=[0,0,0;
    0,0,0;
    0,0,0];
%%Primera singularidad
disp("=======Primera Singularidad=======")
qnom(5) = 0; % para que se me anule sin(q5)
disp("Parametros articulares: ")
qnom
disp("Determinante Jacobiano: ")
Dfun(qnom)
Taux=R.fkine(qnom).double;
xyz(1,:)=Taux(1:3,4)';


%%Segunda singularidad
disp("=======Segunda Singularidad=======")
qnom = zeros(1,6);
qnom(5)=pi/2;
qnom(3)=-atan2(R.links(4).d,R.links(3).a);
disp("Parametros articulares: ")
qnom
disp("Determinante Jacobiano: ")
Dfun(qnom)
Taux=R.fkine(qnom).double;
xyz(2,:)=Taux(1:3,4)';

%%Tercera singularidad
disp("=======Tercera Singularidad=======")
valorq2=-2*pi/3;
syms q23 q33 real
a1=R.links(1).a;
a2=R.links(2).a;
a3=R.links(3).a;
d4=R.links(4).d;
x = a1 + a2*cos(q2) + sqrt(a3^2 + d4^2)*cos(q3 + q2 + atan(d4/a3));
eq = simplify(x == 0);
sol_eval=subs(eq,q2,valorq2);
sol_q3 = solve(sol_eval, q3, 'Real', true);
sol_q3=double(sol_q3);
valorq3=sol_q3(1);

qnom = zeros(1,6);
qnom(5)=pi/2;
qnom(3)=valorq3;
qnom(2)=valorq2;
disp("Parametros articulares: ")
qnom
disp("Determinante Jacobiano: ")
Dfun(qnom)
Taux=R.fkine(qnom).double;
xyz(3,:)=Taux(1:3,4)';

figure;
R.teach([0,0,0,0,0,0],'view',[pi/2,0])
hold on;
plot3(xyz(:,1), xyz(:,2), xyz(:,3), '*r');
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
grid on; axis equal;
