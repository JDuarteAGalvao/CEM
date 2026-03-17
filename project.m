%create ssp from gslib
s.X = linspace(-0.8,0.8,530)
s.Y = linspace(-0.8,0.8,305)
s.Depth = linspace(0,30,64)
gslib2ssp('project.ssp','teste.gslib',s)
plotssp3d('project')    %add gca thing for plots

%rays
fileroot = 'projectR'
copyfile('project.bty', [fileroot '.bty'])
copyfile('project.ssp', [fileroot '.ssp'])
bellhop3d(fileroot)
%figure
%plotbdry3d([fileroot '.bty'])
%hold on
%scatter3(0,0,10,60,'MarkerEdgeColor','k','MarkerFaceColor','g')
%[Arr,Pos] = read_arrivals_asc('projectA.arr');
%M = zeros(147,3);
%var=0;
%for i=1:7
%for j = 1:3
%    for k = 1:7
%        var=var+1;
%        [M(var,1),M(var,2),M(var,3)] = pol2cart(Pos.r.theta(i,1),Pos.r.r(j,1),Pos.r.z(k,1));
%    end
%end
%end
%scatter3(M(:,1),M(:,2),M(:,3),48,'MarkerEdgeColor','k','MarkerFaceColor',[.7 .7 .7])
%hold off
figure
plotbdry3d([fileroot '.bty'])
hold on
plotray3d([fileroot '.ray'])
delete([fileroot '.bty'])
delete([fileroot '.ssp'])
%delete([fileroot '.prt'])

%arrivals
fileroot = 'projectA'
copyfile('project.bty', [fileroot '.bty'])
copyfile('project.ssp', [fileroot '.ssp'])
bellhop3d(fileroot)
plotarr3d([fileroot '.arr'],1,1,1,1)       %what's the amplitude's unit?
rts = delayandsum3D(fileroot, 1600, 2*pi*1000)
%for i=1:6
%figure
%for j = 1:5
%  subplot(3,2,j)
%  seisplot(squeeze(rts{1,i}(:,:,j))) %plotting all vertical arrays of hydrophones, 1 fig per azimuth
%end
%end
%for i=1:5
%figure
%for j = 1:6
%subplot(3,2,j)
%  seisplot(squeeze(rts{1,j}(:,:,i))) %plotting all vertical arrays of hydrophones, 1 fig per range
%end
%end
%for i = 1:3
  figure
  seisplot(squeeze(rts{1,1}(:,1,:))) %plotting all horizontal lines of hydrophones, 1 fig per azimuth
%end
delete([fileroot '.bty'])
delete([fileroot '.ssp'])
delete([fileroot '.prt'])

%TL
fileroot = 'projectTL'
copyfile('project.bty', [fileroot '.bty'])
copyfile('project.ssp', [fileroot '.ssp'])
bellhop3d(fileroot)
figure
plotshdpol([fileroot '.shd'],0,0,10) %xsrc,ysrc,rd
axis equal
%figure
%plotshd([fileroot '.shd'])
delete([fileroot '.bty'])
delete([fileroot '.ssp'])
delete([fileroot '.prt'])

%%%%%

crts = cell(147);
var=0;
for i=1:7
for j = 1:3
    for k = 1:7
        var=var+1;
        crts{var}=rts{1,i}(:,k,j);
    end
end
end

[Nx, Ny, Nz, Segx, Segy, Segz, cmat] = readssp3d('project.ssp');