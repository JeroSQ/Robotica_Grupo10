function [q, qd, qdd, qq_F] = gTrayectoria_c(listaTs, R,qq)
    q=[];
    qd=[];
    qdd=[];
    %Primera parte
    for i = 2:numel(listaTs)
        Tinters=ctraj(listaTs{i-1}, listaTs{i}, 100);
        for j = 1:size(Tinters,3)
            qaux=cinv(Tinters(:,:,j),R,qq,1);
            q=[q;qaux];
            qq=qaux;
        end
    end
   qd  = diff(q)*100;
   qdd = diff(qd)*100;
   qd=[zeros(1,6);qd];
   qdd=[zeros(1,6);zeros(1,6);qdd];
   qq_F=qq;
end