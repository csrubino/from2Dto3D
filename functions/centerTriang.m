function [ cnt , C3D, VisSel ] = centerTriang( bbx, P, frVw )
%CENTERTRIANG computes all the centres of bounding boxes in the 3D space 
% given the 2D bounding boxes in the 2D space and the projection matrices

n_o     = size(bbx,2)/4;
cntx    = .5*(bbx(:,1:4:end) + bbx(:,3:4:end));
cnty    = .5*(bbx(:,2:4:end) + bbx(:,4:4:end));
Mx      = eye(2*n_o); Mx(2:2:end,:) = [];
My      = eye(2*n_o); My(1:2:end,:) = [];
cnt     = cntx*Mx+cnty*My;

%Select the poses with the highest baseline
visObj  = find(sum(frVw,1)>=3);
C3D     = zeros(4,n_o); C3D(4,:) = C3D(4,:) + 1;

for o=visObj
    visFr   = find(frVw(:,o)~=0);
    tdTmp   = P(4:4:end,:)';
    td      = tdTmp(:,visFr);
    distMx  = zeros(size(visFr,1),size(visFr,1));

    for f = visFr'
        dTmp        = td - tdTmp(:,f)*ones(1,size(visFr,1));
        distMx(find(visFr==f),:) = sqrt(sum(dTmp.*dTmp,1));
    end

    tTr     = tril(distMx);
    vtTr    = tTr(:);
    [www, ix] = sort(vtTr,'descend');
    [i,j]   = ind2sub(size(tTr),ix);

    % Camera poses
    distCam = unique([j(1:2),i(1:2)]);
    Pp      = cell(1,3);
    Pp{1}   = P(4*visFr(distCam(1))-3:4*visFr(distCam(1)),:)';
    Pp{2}   = P(4*visFr(distCam(2))-3:4*visFr(distCam(2)),:)';
    Pp{3}   = P(4*visFr(distCam(3))-3:4*visFr(distCam(3)),:)';
    VisSel{o} = visFr(distCam([1,2,3]));
    
    x = cell(1,3);
    x{1} = cnt(visFr(distCam(1)),2*o-1:2*o)';
    x{2} = cnt(visFr(distCam(2)),2*o-1:2*o)';
    x{3} = cnt(visFr(distCam(3)),2*o-1:2*o)';
    
    [X, min_err] = tvt_solve_qr(Pp,x);
    C3D(1:3,o) = X;
    clearvars x X Pp
end

end

