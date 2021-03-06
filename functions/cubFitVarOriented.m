function [ PPM, pointsInlab, infR, supR ] = cubFitVarOriented( P, bbx )
%CUBFITVAR generates the variables for cuboids fitting

PPM = reshape(P',3,4,[]);
% [xmin ymin xmax ymin, xmax, ymax, xmin, ymax] becames:
% [xmin ymin, xmax, ymax];
nO = size(bbx,2)/4;
for o=1:nO
%     pntsTmp(:,8*o-7:8*o) = [bbx(:,4*o-3),bbx(:,4*o-2), ...
%                             bbx(:,4*o-1),bbx(:,4*o-2), ...
%                             bbx(:,4*o-1),bbx(:,4*o), ...
%                             bbx(:,4*o-1),bbx(:,4*o-3)];
    pntsTmp(:,8*o-7:8*o) = [bbx(1:2:end,4*o-3),bbx(2:2:end,4*o-3),...
                            bbx(1:2:end,4*o-2),bbx(2:2:end,4*o-2),...
                            bbx(1:2:end,4*o-1),bbx(2:2:end,4*o-1),...
                            bbx(1:2:end,4*o  ),bbx(2:2:end,4*o  ),...
                            ];
%     infR(:,2*o-1:2*o) = [bbx(:,4*o-3),bbx(:,4*o-2)];
%     supR(:,2*o-1:2*o) = [bbx(:,4*o-1),bbx(:,4*o)];
    infR(:,2*o-1:2*o) = [min(bbx(1:2:end,4*o-3:4*o),[],2),min(bbx(2:2:end,4*o-3:4*o),[],2)];
    supR(:,2*o-1:2*o) = [max(bbx(1:2:end,4*o-3:4*o),[],2),max(bbx(2:2:end,4*o-3:4*o),[],2)];
end

npts        = size(pntsTmp,2)/2;

pointsInlab = reshape(pntsTmp',2,npts,[]);    
pointsInlab = permute(pointsInlab,[2,1,3]);
infR = reshape(infR',2,nO,[]);
infR = permute(infR,[2 1 3]);
supR = reshape(supR',2,nO,[]);
supR = permute(supR,[2 1 3]);

end

