function writessp3d(filename, sspStruct, sspVolume)
%% function that writes 3-D sound speed velocity models in bellhop format
% [input]  
%   filename - full filename including extensio (ssp)
%   sspStruct - composed of sspStruct.X (km), sspStruct.Y (km), sspStruct.Depth (m) with 
%       vectors for each dimension
%   sspVolume is a 3D matriz with nx, ny, nz
%
% [modifications]
%
% LA - Mar 2025

%% get number of x and y positions
nx = length( sspStruct.X);
ny = length( sspStruct.Y);
nz = length( sspStruct.Depth);


fid = fopen( filename, 'wt' );

% x locations
fprintf( fid, '%i \n', nx );
fprintf( fid, '%f ', sspStruct.X(1:end));
fprintf( fid, '\n');
% y locations
fprintf( fid, '%i \n', ny );
fprintf( fid, '%f ', sspStruct.Y(1:end));
fprintf( fid, '\n');
% depth loc
fprintf( fid, '%i \n', nz);
fprintf( fid, '%f ', sspStruct.Depth(1:end));
fprintf( fid, '\n');
    
for i = 1:nz
    temp =  sspVolume(:,:,i)';
    for j = 1:size(temp,1)
        fprintf( fid, '%9.3f', temp(j,:,:));
        fprintf( fid, '\n');
    end
end



fclose( fid );

