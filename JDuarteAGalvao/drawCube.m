function h = drawCube(origin, dx, dy, dz)

x = origin(1);
y = origin(2);
z = origin(3);

vertices = [
    x y z;
    x+dx y z;
    x+dx y+dy z;
    x y+dy z;
    x y z+dz;
    x+dx y z+dz;
    x+dx y+dy z+dz;
    x y+dy z+dz];

faces = [
    1 2 3 4;
    5 6 7 8;
    1 2 6 5;
    2 3 7 6;
    3 4 8 7;
    4 1 5 8];

h = patch('Vertices', vertices, 'Faces', faces);
end
