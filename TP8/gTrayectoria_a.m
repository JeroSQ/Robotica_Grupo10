function [q, qd, qdd] = gTrayectoria_a(listaTs, R,qq, n)
    q=[];
    qd=[];
    qdd=[];
    qant=R.ikine(listaTs{1}, qq);
    for i = 2:numel(listaTs)
        qact=R.ikine(listaTs{i}, qq);
        [qaux,qdaux,qddaux]=jtraj(qant, qact, n);
        q=[q;qaux];
        qd=[qd;qdaux];
        qdd=[qdd;qddaux];
        qant=qact;
        qq=qact;
    end
end

