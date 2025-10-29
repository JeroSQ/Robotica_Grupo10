robot;

function bake_stl_transform(infile, outfile, xyz, rpy_deg, scale)
% Aplica T = transl(xyz) * rpy2tr(rpy_deg) a cada vértice del STL ASCII.
% Opcional: 'scale' (1 por defecto). Usá 0.001 si tu STL está en mm y tu DH en m.

    if nargin < 5, scale = 1; end
    T = transl(xyz) * rpy2tr(deg2rad(rpy_deg));  % usa RTB (Peter Corke)
    
    fi = fopen(infile,'r');  assert(fi>0, "No pude abrir: " + infile);
    fo = fopen(outfile,'w'); assert(fo>0, "No pude escribir: " + outfile);

    while true
        line = fgetl(fi);
        if ~ischar(line), break; end
        if startsWith(strtrim(line),'vertex')
            % línea tipo: 'vertex x y z'
            vals = sscanf(line,'vertex %f %f %f');
            p = [vals(:); 1];
            p2 = T * p;
            p2 = p2(1:3) * scale;
            fprintf(fo,'  vertex %.9g %.9g %.9g\n', p2(1), p2(2), p2(3));
        else
            fprintf(fo,'%s\n', line);
        end
    end

    fclose(fi); fclose(fo);
end

function T = rpy2tr(rpy_rad)
% rpy en rad -> matriz homogénea (XYZ roll-pitch-yaw)
    R = rpy2r(rpy_rad);   % de RTB (Peter Corke)
    T = [R [0;0;0]; 0 0 0 1];
end

robot;

R.plot3d(q, 'path', fullfile(pwd,'stl_0'));
axis equal
%R.teach()
%plotworkspace()