function [vertex,face,mapping] = read_vtk(filename, nblayer, verbose)

%T1_03_thresh_clone_transform_strip_clone_transform_bound_mems_lcr_gm_avg_inf
% T1_02_thresh_clone_transform_strip_clone_transform_bound_mems_lcr_gm_avg_inf_ROI_L

% read_vtk - read data from VTK file.
%
%   [vertex,face] = read_vtk(filename, verbose);
%
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 3' array specifying the connectivity of the mesh.
%
%   Copyright (c) Mario Richtsfeld

if nargin<2
    verbose = 1; %#ok<*NASGU,*UNRCH>
end

%%
fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return; 
end

str = fgets(fid);   % -1 if eof
if ~strcmp(str(3:5), 'vtk')
    error('The file is not a valid VTK one.');    
end

%%% read header %%%
str = fgets(fid);
str = fgets(fid);
str = fgets(fid);
str = fgets(fid);
nvert = sscanf(str,'%*s %d %*s', 1);

% read vertices
[A,cnt] = fscanf(fid,'%f %f %f', 3*nvert);
if cnt~=3*nvert
    warning('Problem in reading vertices.');
end
A = reshape(A, 3, cnt/3);
vertex = A;

% read polygons
str = fgets(fid);
str = fgets(fid);

info = sscanf(str,'%c %*s %*s', 1);

if((info ~= 'P') && (info ~= 'V'))
    str = fgets(fid);    
    info = sscanf(str,'%c %*s %*s', 1);
end

if(info == 'P')
    
    nface = sscanf(str,'%*s %d %*s', 1);

    [A,cnt] = fscanf(fid,'%d %d %d %d\n', 4*nface);
    if cnt~=4*nface
        warning('Problem in reading faces.');
    end

    face = reshape(A, 4, cnt/4);
end

if(info ~= 'P')
    face = 0;
end

% read vertex ids
if(info == 'V')
    
    nv = sscanf(str,'%*s %d %*s', 1);

    [A,cnt] = fscanf(fid,'%d %d \n', 2*nv);
    if cnt~=2*nv
        warning('Problem in reading faces.');
    end

    A = reshape(A, 2, cnt/2);
    face = repmat(A(2,:)+1, 3, 1);
end

if((info ~= 'P') && (info ~= 'V'))
    face = 0;
end

%% read mapping
str = fgets(fid);
nvert = sscanf(str,'%*s %d %*s', 1);

str = fgets(fid);
str = fgets(fid);

[A,cnt] = fscanf(fid, [repmat('%f ',1,(nblayer+1)) '\n'], (nblayer+1)*nvert);
if cnt~=(nblayer+1)*nvert
    warning('Problem in reading mapping.');
end
A = reshape(A, nblayer+1, cnt/(nblayer+1));
mapping = A;

%%
fclose(fid);

return
