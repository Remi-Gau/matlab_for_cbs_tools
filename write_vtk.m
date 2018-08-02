function write_vtk(filename, vertex, face, mapping, layers)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin<5 || isempty(layers)
    layers = 1;
end

fid = fopen(filename, 'w'); 

fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, [strrep(filename(1:end-3),'\','/') '\n']);
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET POLYDATA\n');

fprintf(fid, 'POINTS %i float\n', size(vertex,2));
spec = [repmat('%0.6f ',1, size(vertex,1)),'\n'];
fprintf(fid, spec, vertex);
clear spec

% fprintf(fid, '\n');
fprintf(fid, 'POLYGONS %i %i\n', size(face,2), numel(face));
spec = [repmat('%i ',1, size(face,1)),'\n'];
fprintf(fid, spec, face);

fprintf(fid, 'POINT_DATA %i\n', size(vertex,2));
fprintf(fid, 'SCALARS EmbedVertex float %i\n', layers);
fprintf(fid, 'LOOKUP_TABLE default\n');
if layers==1
    spec = [repmat('%0.8f ',1, 1),'\n'];
    fprintf(fid, spec, mapping);
else
    spec = [repmat('%0.3f ',1, layers),'\n'];
    fprintf(fid, spec, mapping');
end

fclose(fid);

end

