function [q, qd, qdd] = gTrayectoria_a(listaTs, R,qq)
    q=[];
    qd=[];
    qdd=[];
    qant=R.ikine(listaTs{1}, qq);
    for i = 2:numel(listaTs)
        qact=R.ikine(listaTs{i}, qq);
        [qaux,qdaux,qddaux]=jtraj(qant, qact, 100);
        q=[q;qaux];
        qd=[qd;qdaux];
        qdd=[qdd;qddaux];
        qant=qact;
    end
    qq=qact;
end

