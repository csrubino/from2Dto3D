function [pts3dbbx] = bbx3d2pts(bbx3d)

x1 = bbx3d(1);
y1 = bbx3d(2);
z1 = bbx3d(3);
x2 = bbx3d(4);
y2 = bbx3d(5);
z2 = bbx3d(6);

pts3dbbx = [x1,y1,z1; x2,y1,z1; x2,y1,z2;x1,y1,z2;...
            x1,y2,z1; x2,y2,z1; x2,y2,z2;x1,y2,z2]';

end