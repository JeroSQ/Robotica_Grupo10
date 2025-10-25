function [q, qd, qdd] = gTrayectoria_c(listaTs, R,qq)
    q=[];
    qd=[];
    qdd=[];
    qant=R.ikine(listaTs{1}, qq);
    for i = 2:numel(listaTs)
        Tinters=ctraj(listaTs{i-1}, listaTs{i}, 100);
        qaux=R.ikine(Tinters, qq);
        q=[q;qaux];
        qq=qaux;
    end
   qd  = gradient(q);
   qdd = gradient(qd);
end