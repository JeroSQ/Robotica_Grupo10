function [q, qd, qdd, qq_F] = gTrayectoria_ms(listaTs, R, qq)
    
    qant = qq; 
    
    q_waypoints = [qant]; 
    
    for i = 2:numel(listaTs)
        qact = R.ikine(listaTs{i}, qant); 
        q_waypoints = [q_waypoints; qact];
        qant = qact; 
    end
    
    % Velocidades máximas obtenidas de la datasheet
    qdmax_deg = [180, 158, 160, 230, 230, 320];
    qdmax_rad = qdmax_deg * (pi/180);
    
    
    tsegment = [];
    dt = 0.01;     
    t_acc = 0.5; 
    
    q = mstraj(q_waypoints(2:end,:), qdmax_rad, tsegment, q_waypoints(1,:), dt, t_acc);
    qd  = diff(q)*100;
    qdd = diff(qd)*100;
    qd=[zeros(1,6);qd];
    qdd=[zeros(1,6);zeros(1,6);qdd];

    qq_F = qant;
end