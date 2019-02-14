function [ Rec, bbx3d ] = attempt3baseline( bbx, P, frVw, traslZ, Transf )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


visObj  = find(sum(frVw,1)>0);
nO      = length(visObj);

% With bounding boxes without orientation
%[ PPM, pointsInlab, infR, supR ] = cubFitVar( P, bbx );

% With bounding boxes with orientation
[ PPM, pointsInlab, infR, supR ] = cubFitVarOriented( P, bbx );

Rec     = struct();
clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1;.5 0 .5; 1 0 .5; .5 1 0;1 .5 0; 1 1 .5; .5 .5 0; 1 .5 1; .5 .5 1; .5 1 .5; 1 .3 .3; .3 .7 .3; .5 .3 .3; .7 .7 0];

for o=visObj
    o
    fwoid       = frVw(:,o);
    PPMwieved   = PPM(:,:,fwoid);
    nF          = sum(fwoid);
    infRobj     = infR(o,:,fwoid);
    supRobj     = supR(o,:,fwoid);
    pointsInt   = pointsInlab(4*o-3:4*o,:,fwoid);
    imagePoints = (infRobj + supRobj)./2;
    errorXY     = 0.5*abs(supRobj-infRobj);
    shuffle     = randperm(nF);
    error       = errorXY;
    tic
    
    W = exact_triangulation_3_oriented(PPMwieved(:,:,shuffle), infRobj(:,:,shuffle), supRobj(:,:,shuffle));
    t2 = toc;
    fprintf('Time of computation exact triangulation: %f s\n',t2);
    V = W{1}'- traslZ'*ones(1,size(W{1},1));
    Rec(o).bbx3d_CG = gtBbx(V');
    bbx3d(o,:)  = [min(V(1,:)),min(V(2,:)),min(V(3,:)),...
                         max(V(1,:)),max(V(2,:)),max(V(3,:))];
    Rec(o).Q    = eye(4);
    vt          = V';
    vt          = (eye(3,4)*Transf*[vt';ones(1,size(vt,1))])';
    if size(vt,1)>3
        [K, ~]      = convhulln(vt);
        Rec(o).K    = K;
        Rec(o).vt   = vt;
    else
        Rec(o).K = [];
        Rec(o).vt   = vt;
    end
end

end

