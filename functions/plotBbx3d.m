function plotBbx3d( bbx3d, color, lnwdth )
%Display a 3D cuboid

if nargin<3
    lnwdth = 2;
end

hold on;

if  mod(size(bbx3d,2),6) == 0
    x1 = bbx3d(1);
    y1 = bbx3d(2);
    z1 = bbx3d(3);
    x2 = bbx3d(4);
    y2 = bbx3d(5);
    z2 = bbx3d(6);
    plot3([x1,x1,x1,x1],[y1,y2,y2,y1],[z1,z1,z2,z2],color, 'linewidth', lnwdth);
    plot3([x2,x2,x2,x2],[y1,y2,y2,y1],[z1,z1,z2,z2],color, 'linewidth', lnwdth);
    plot3([x1,x1,x2,x2],[y1,y1,y1,y1],[z1,z2,z2,z1],color, 'linewidth', lnwdth);
    plot3([x1,x1,x2,x2],[y2,y2,y2,y2],[z1,z2,z2,z1],color, 'linewidth', lnwdth);
    plot3([x1,x2,x2,x1],[y1,y1,y2,y2],[z1,z1,z1,z1],color, 'linewidth', lnwdth);
    plot3([x1,x2,x2,x1],[y1,y1,y2,y2],[z2,z2,z2,z2],color, 'linewidth', lnwdth);
else 
    plot3([bbx3d(1,1),bbx3d(1,2),bbx3d(1,3),bbx3d(1,4),bbx3d(1,1),bbx3d(1,5)],...
          [bbx3d(2,1),bbx3d(2,2),bbx3d(2,3),bbx3d(2,4),bbx3d(2,1),bbx3d(2,5)],...
          [bbx3d(3,1),bbx3d(3,2),bbx3d(3,3),bbx3d(3,4),bbx3d(3,1),bbx3d(3,5)],color, 'linewidth', lnwdth); hold on;
    plot3([bbx3d(1,5),bbx3d(1,6),bbx3d(1,7),bbx3d(1,8),bbx3d(1,5)],...
          [bbx3d(2,5),bbx3d(2,6),bbx3d(2,7),bbx3d(2,8),bbx3d(2,5)],...
          [bbx3d(3,5),bbx3d(3,6),bbx3d(3,7),bbx3d(3,8),bbx3d(3,5)],color, 'linewidth', lnwdth);
    plot3([bbx3d(1,4),bbx3d(1,8)],...
          [bbx3d(2,4),bbx3d(2,8)],...
          [bbx3d(3,4),bbx3d(3,8)],color, 'linewidth', lnwdth);
    plot3([bbx3d(1,3),bbx3d(1,7)],...
          [bbx3d(2,3),bbx3d(2,7)],...
          [bbx3d(3,3),bbx3d(3,7)],color, 'linewidth', lnwdth);
    plot3([bbx3d(1,2),bbx3d(1,6)],...
          [bbx3d(2,2),bbx3d(2,6)],...
          [bbx3d(3,2),bbx3d(3,6)],color, 'linewidth', lnwdth);
end

% bbxHnd = findobj(gca,'type','line');


end

