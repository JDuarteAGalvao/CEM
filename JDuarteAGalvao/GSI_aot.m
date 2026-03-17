function GSI_aot   
%% DEFINE FOLDER PATH
ProjectPath         = 'C:\Users\joao.galvao\Desktop\FilesThatMatter\';
InputPath           = 'input\';
OutputPath          = 'output/';

noSim           = 32;
noIt            = 6;
MinLayerSize    = 10;
MaxLayerSize    = 20;
xMax            = 530;
yMax            = 305;
zMax            = 64;

%% LOAD HARD DATA
 % LOAD ORIGINAL SEISMC GATHER
load([ProjectPath, InputPath, 'seisreal.mat']);

%% CREATE STRUCTURE FOR SGEMS FILE
SimType             = 'SGEMS'; % SGEMS or GEOEAS
NullDataValues      = -99999.25;    
LvmFile             = 'no file';
% ZONE INFORMATION
ZoneFile            = 'zones.sgems';
NbrZones            = 1;

% [~, hd] = import_gslib([ProjectPath, InputPath,'Ip_rev_jurassic1.gslib']);

% hd(1:32,3) = hd(1:32,3)*10000;
% hd(65:96,3) = hd(65:96,3)*10000;
% hd(33:64,3) = hd(33:64,3)*10000;
% hd(97:128,3) = hd(97:128,3)*10000;
% write_well_data(hd,'P-impedance',[ProjectPath, InputPath,'miniIp_rev_jurassic1_1.gslib']);
% write_well_data(hd,'P-impedance',[ProjectPath, InputPath,'miniIp_rev_jurassic1_2.gslib']);

% LOAD HARD-DATA TO CHECK IF EXISTS
for i =1: NbrZones
    HardData(i,:)   = [ProjectPath, InputPath,'well10data_',num2str(i),'.gslib'];
end
% GRID PARAMETERS - NO. CELLS; ORIGIN; SPACING
XX                  = [xMax 1 1];
YY                  = [yMax 1 1];
ZZ                  = [zMax 1 1];

% SEARCHING ELLIPSOID
krig_RANGE          = [15000 15000 150];
krig_ANG            = [0 0 0];

% VARIOGRAM PARAMETERS
var_ANG             = [0 0 0];
% var_RANGE           = [2000/25 2000/25 8 .60 30000/25 30000/25 100 0.40; 2000/25 2000/25 8 .60 30000/25 30000/25 100 0.40];
var_RANGE           = [300/12.5 300/12.5 2.5 0.8 2600/12.5 2600/12.5 10 0.2];

VariogramType       = [2];
VarNugget           = [0];

execute_GSI_aot(ProjectPath, InputPath, OutputPath, XX, YY, ZZ,...
    MinLayerSize, MaxLayerSize, noIt, noSim, HardData, krig_ANG, krig_RANGE,...
    var_ANG, var_RANGE, ZoneFile, NbrZones, VariogramType, VarNugget, ...
    SimType, LvmFile, SeisReal, NullDataValues)

end    
