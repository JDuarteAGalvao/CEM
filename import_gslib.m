function [header,data]=import_gslib(file_id)
%% LOADS A GSLIB FORMAT FILE INTO A SINGLE ARRAY
%
% file_id - INPUT FILE IN THE GSLIB STANDARD FORMAT.
%             FILE SHOULD BE A SINGLE ARRAY WITH A 3 LINES TEXT HEADER;
% header - TEXT HEADER FROM THE INPUT ('FILE_ID') FILE;
% data - THE NUMERIC DATA IN IN A SINGLE ARRAY 
%
% v1.0 - LA - FEB 2012
%%
% OPEN FILE_ID
file=fopen(file_id);

% GETS HOW MANY COLLUMNS 
line1=fgets(file);
ncol=str2num(fgets(file));

for i=1:ncol
    header{i}=fgets(file);
end

% READS THE DATA INTO A CELL & CONVERT TO LIST
datacell=textscan(file,'%f','Delimiter', '\n','CollectOutput', true);
data=cell2mat(datacell);

nrow=length(data)/ncol;
data=reshape(data,ncol,nrow).';

%CLOSES FILE_ID
fclose(file);
end
