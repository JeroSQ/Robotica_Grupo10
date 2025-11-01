function [q, qd, qdd, qq_F] = gTrayectoria_c(listaTs, R,qq)
    q=[];
    qd=[];
    qdd=[];
    for i = 2:numel(listaTs)
        Tinters=ctraj(listaTs{i-1}, listaTs{i}, 100);
        qaux=R.ikine(Tinters, qq);
        q=[q;qaux];
        qq=qaux(end,:);
    end
   qd  = gradient(q);
   qdd = gradient(qd);
   qq_F=qq;
end