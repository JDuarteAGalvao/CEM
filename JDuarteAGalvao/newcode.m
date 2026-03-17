filename = 'projectR.ray';
lines = readlines(filename);
infolinenr = 9;
rays = cell(21);
for i=1:21
line = lines(infolinenr);
line = str2double(split(line));
line = line(~isnan(line));
rays{i} = zeros(line(1),3);
for j=1:line(1)
linee = lines(infolinenr+j);
linee = str2double(split(linee));
linee = linee(~isnan(linee));
rays{i}(j,:) = linee;
end
infolinenr=infolinenr+line(1)+2;
end

% Domain dimensions
x_lim = [-400, 400];
y_lim = [-400, 400];
z_lim = [0, 30];
% Grid resolution
nx = 530; ny = 305; nz = 64;

allLinearInd = [];

for i = 1:length(rays)
    pts = rays{i};

    ix = floor((pts(:,1) - x_lim(1)) / (x_lim(2) - x_lim(1)) * (nx-1)) + 1;
    iy = floor((pts(:,2) - y_lim(1)) / (y_lim(2) - y_lim(1)) * (ny-1)) + 1;
    iz = floor((pts(:,3) - z_lim(1)) / (z_lim(2) - z_lim(1)) * (nz-1)) + 1;

    ix = min(max(ix, 1), nx);
    iy = min(max(iy, 1), ny);
    iz = min(max(iz, 1), nz);

    allLinearInd = [allLinearInd; sub2ind([nx, ny, nz], ix, iy, iz)];
end
grid3D = false(nx, ny, nz);
grid3D(unique(allLinearInd)) = true;
numGrid = double(grid3D);
[idx_x, idx_y, idx_z] = ind2sub(size(numGrid), find(numGrid)); %extract occupied voxel indices

figure('Color','white');
hold on;
% voxel sizes
dx = (x_lim(2)-x_lim(1))/(nx-1);
dy = (y_lim(2)-y_lim(1))/(ny-1);
dz = (z_lim(2)-z_lim(1))/(nz-1);

% draw cubes
for k = 1:length(idx_x)

    x0 = x_lim(1) + (idx_x(k)-1)*dx;
    y0 = y_lim(1) + (idx_y(k)-1)*dy;
    z0 = z_lim(1) + (idx_z(k)-1)*dz;

    h = drawCube([x0 y0 z0], dx, dy, dz);

    set(h, ...
        'FaceColor', [0.85 0.2 0.2], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.85);
end

% ----- AXIS & VIEW SETTINGS -----
daspect([1 1 1])
axis tight
box on
grid on
view(35,25)

xlabel('X (m)','FontSize',12)
ylabel('Y (m)','FontSize',12)
zlabel('Z (m)','FontSize',12)
title('Voxelized Grid Points (All Rays)','FontSize',14,'FontWeight','bold')

% ----- LIGHTING -----
camlight('headlight')
camlight('right')
lighting gouraud
material dull

%just ray 1
% Normalize and scale points to grid indices
ix = floor((rays{1}(:,1) - x_lim(1)) / (x_lim(2) - x_lim(1)) * (nx-1)) + 1;
iy = floor((rays{1}(:,2) - y_lim(1)) / (y_lim(2) - y_lim(1)) * (ny-1)) + 1;
iz = floor((rays{1}(:,3) - z_lim(1)) / (z_lim(2) - z_lim(1)) * (nz-1)) + 1;
% Keep indices within bounds (handles points exactly on the upper boundary)
ix = min(max(ix, 1), nx);
iy = min(max(iy, 1), ny);
iz = min(max(iz, 1), nz);
% Create an empty 3D grid
grid3D = false(nx, ny, nz);
% Use linear indexing for speed to "color" the cells
linearInd = sub2ind([nx, ny, nz], ix, iy, iz);
grid3D(unique(linearInd)) = true;
[idx_x, idx_y, idx_z] = ind2sub(size(grid3D), find(grid3D));
figure('Color','white'); 
hold on;

dx = (x_lim(2)-x_lim(1))/(nx-1);
dy = (y_lim(2)-y_lim(1))/(ny-1);
dz = (z_lim(2)-z_lim(1))/(nz-1);

for k = 1:length(idx_x)

    x0 = x_lim(1) + (idx_x(k)-1)*dx;
    y0 = y_lim(1) + (idx_y(k)-1)*dy;
    z0 = z_lim(1) + (idx_z(k)-1)*dz;

    h = drawCube([x0 y0 z0], dx, dy, dz);

    % Improve cube appearance
    set(h, ...
        'FaceColor', [0.85 0.2 0.2], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.85);
end

% ----- AXIS & VIEW SETTINGS -----
daspect([1 1 1])          % Correct 3D proportions
axis tight
box on
grid on
view(35,25)               % Better viewing angle

xlabel('X (m)','FontSize',12)
ylabel('Y (m)','FontSize',12)
zlabel('Z (m)','FontSize',12)
title('Voxelized Grid Points (single ray)','FontSize',14,'FontWeight','bold')

% ----- LIGHTING -----
camlight('headlight')
camlight('right')
lighting gouraud
material dull

D = bwdist(grid3D); % distance in voxels
dx = (x_lim(2)-x_lim(1))/(nx-1);
dy = (y_lim(2)-y_lim(1))/(ny-1);
dz = (z_lim(2)-z_lim(1))/(nz-1);
voxelSize = mean([dx dy dz]); % approximate isotropic scaling
D_phys = D * voxelSize;
R = 10; % meters (cylinder radius)
field = max(0, 1 - D_phys / R);


%plotting ray 1's cut
pts = rays{1};

% Direction vector (start → end)
dirVec = pts(end,:) - pts(1,:);
dirVec = dirVec / norm(dirVec);

% Create arbitrary vector not parallel to dirVec
if abs(dot(dirVec,[0 0 1])) < 0.9
    tmp = [0 0 1];
else
    tmp = [0 1 0];
end

v1 = cross(dirVec, tmp);
v1 = v1 / norm(v1);

v2 = cross(dirVec, v1);
v2 = v2 / norm(v2);

midPoint = pts(round(end/2), :);

sliceSize = 40;   % meters (width of slice)
res = 100;        % grid resolution

[u,v] = meshgrid(linspace(-sliceSize/2, sliceSize/2, res));

X = midPoint(1) + u*v1(1) + v*v2(1);
Y = midPoint(2) + u*v1(2) + v*v2(2);
Z = midPoint(3) + u*v1(3) + v*v2(3);

% Create coordinate vectors for interpolation
xv = linspace(x_lim(1), x_lim(2), nx);
yv = linspace(y_lim(1), y_lim(2), ny);
zv = linspace(z_lim(1), z_lim(2), nz);

Fslice = interpn(xv, yv, zv, field, X, Y, Z, 'linear', 0);

figure
imagesc(linspace(-sliceSize/2, sliceSize/2, res), ...
        linspace(-sliceSize/2, sliceSize/2, res), ...
        Fslice)

axis equal
axis tight
set(gca,'YDir','normal')

colormap(jet)
colorbar
title('Perpendicular Slice Through Ray')
xlabel('v1 direction (m)')
ylabel('v2 direction (m)')