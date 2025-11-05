function [q, qd, qdd, qq_F] = gTrayectoria_a(listaTs, R,qq)
    q=[];
    qd=[];
    qdd=[];
    qant=qq;
    for i = 2:numel(listaTs)
        qact=R.ikine(listaTs{i}, qant);
        [qaux,qdaux,qddaux]=jtraj(qant, qact, 100);
        q=[q;qaux];
        qd=[qd;qdaux];
        qdd=[qdd;qddaux];
        qant=qact;
    end
    qq_F=qact;
end

