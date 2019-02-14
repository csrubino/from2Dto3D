function [ output ] = p2bbx4pts( P )

bbxArea = double(max(P(1:2,:),[],2)) - min(P(1:2,:),[],2);
C       = 0.5*(max(P(1:2,:),[],2) + min(P(1:2,:),[],2));

Pt      = P(1:2,:) - [min(P(1:2,:),[],2)]*ones(1,size(P,2));
Ct      = C - min(P(1:2,:),[],2);
BW      = zeros(round(bbxArea(2)),round(bbxArea(1)));
px      = round(Pt);
px(px<1) = 1; 
px(1,px(1,:)>round(bbxArea(1))) = round(bbxArea(1));
px(2,px(2,:)>round(bbxArea(2))) = round(bbxArea(2));
BW(sub2ind([round(bbxArea(2)),round(bbxArea(1))], px(2,:), px(1,:))) = 1;
degAng  = regionprops(BW,'orientation');
ang     = pi/180*degAng.Orientation;
RotMx   = [cos(ang),-sin(ang);sin(ang),cos(ang)];
Prot    = RotMx*Pt(1:2,:);
Crot      = RotMx*Ct;


bbxArea2= max(Prot,[],2) - min(Prot,[],2);
C2      = .5*(max(Prot,[],2) + min(Prot,[],2));
trC     = RotMx'*(C2-Crot);
ProtT   = Prot - C2*ones(1,length(Prot));
bbx = .5*[ -bbxArea2(1),-bbxArea2(1),bbxArea2(1),bbxArea2(1);...
            bbxArea2(2),-bbxArea2(2),-bbxArea2(2),bbxArea2(2)];

Pnew = [RotMx',C; 0 0 1]*[ProtT;ones(1,length(ProtT))];

bbxRot  = [RotMx',C+trC; 0 0 1]*[bbx;ones(1,4)];
output = bbxRot(1:2,:);



end

