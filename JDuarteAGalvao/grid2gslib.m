function grid2gslib(var_in,file_out)
% CONVERTS A MATRIX WITH DIMENSION {XMAX,YMAX,ZMAX} INTO A GSLIB ARRAY
%
% var_in [i x j x k] - 3D GRID WITH THE VARIABLE TO BE WRITTEN
% file_out [string] - OUTPUT FILE PATH
%
% FUNCTIONS
% save_var.m
%
% MODIFICATIONS
% 21 JAN 2012 - COMMENTED LINE CHANGED
%
% LA - 21 JAN 2013
%
% SAVE FILE WITH PARAGRAPH DELIMITATOR
save_var(var_in(:), file_out,1,1)

end