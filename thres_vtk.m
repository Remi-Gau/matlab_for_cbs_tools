function thres_vtk(filename, nblayer, min, max, verbose)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% T1_02_thresh_clone_transform_strip_clone_transform_bound_mems_lcr_gm_avg_inf_qT1_2000.vtk


[vertex,face,mapping] = read_vtk(filename, nblayer, verbose);

mapping(mapping<min) = 0;
mapping(mapping>max) = 0;

write_vtk(filename, vertex, face, mapping)


end

