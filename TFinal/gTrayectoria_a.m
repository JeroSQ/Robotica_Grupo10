function [q, qd, qdd, qq_F] = gTrayectoria_a(listaTs, R,qq)
    q=[];
    qd=[];
    qdd=[];
    qant=qq;
    for i = 2:numel(listaTs)
        qact=cinv(listaTs{i},R,qant,1);
        [qaux,qdaux,qddaux]=jtraj(qant, qact, 50);
        q=[q;qaux];
        qd=[qd;qdaux];
        qdd=[qdd;qddaux];
        qant=qact;
    end
    qq_F=qact;
end

