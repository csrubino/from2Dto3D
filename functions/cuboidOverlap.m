function IOU = cuboidOverlap(bbx1, bbx2, niter, plotF)

if nargin<4
    plotF = false;
end

v11     = (bbx1(:,2) - bbx1(:,1))/norm(bbx1(:,2) - bbx1(:,1));
v21     = (bbx1(:,4) - bbx1(:,1))/norm(bbx1(:,4) - bbx1(:,1));
v31     = cross(v11,v21);
R1      = [v11,v21,v31];
bbx1t   = R1'*bbx1;
sz1     = abs([max(bbx1t(1,:))-min(bbx1t(1,:));max(bbx1t(2,:))-min(bbx1t(2,:));max(bbx1t(3,:))-min(bbx1t(3,:))]);
V1      = sz1(1)*sz1(2)*sz1(3);

rndbx   = rand(3,niter);
bxpts   = [sz1(1).*rndbx(1,:);sz1(2).*rndbx(2,:);sz1(3).*rndbx(3,:)]-(0.5*sz1*ones(1,niter));

bxptsReg = R1*bxpts+(mean(bbx1,2))*ones(1,niter);

% Plotting
if plotF
    figure;
    frame_repr(mean(bbx1,2),[v11,v21,v31]);
    plot3(bxptsReg(1,:),bxptsReg(2,:),bxptsReg(3,:),'.b'); hold on;
    plot3(bbx1(1,:),bbx1(2,:),bbx1(3,:),'.r'); % Corners of the BBx
    axis equal;
    plot3(bbx2(1,:),bbx2(2,:),bbx2(3,:),'*g');
end

v12 = (bbx2(:,2) - bbx2(:,1))/norm(bbx2(:,2) - bbx2(:,1));
v22 = (bbx2(:,4) - bbx2(:,1))/norm(bbx2(:,4) - bbx2(:,1));
v32 = cross(v12,v22);
R2 = [v12,v22,v32];

bxptsRegR2 = R2'*bxptsReg;
bbx2t = R2'*bbx2;
sz2     = abs([max(bbx2t(1,:))-min(bbx2t(1,:));max(bbx2t(2,:))-min(bbx2t(2,:));max(bbx2t(3,:))-min(bbx2t(3,:))]);
V2 = sz2(1)*sz2(2)*sz2(3);

% Plotting
if plotF
    figure;
    plot3(bbx2t(1,:),bbx2t(2,:),bbx2t(3,:),'*g');hold on;
    plot3(bxptsRegR2(1,:),bxptsRegR2(2,:),bxptsRegR2(3,:),'.b'); axis equal; % Oriented points inside the GT cube
end

mg = bxptsRegR2 < max(bbx2t,[],2)*ones(1,niter);
mn = bxptsRegR2 > min(bbx2t,[],2)*ones(1,niter);
int1 = mg & mn;
int2 = int1(1,:) & int1(2,:) & int1(3,:);
Vint = sum(int2)/length(int2)*V1;

% Plotting
if plotF
    figure;
    plot3(bbx2t(1,:),bbx2t(2,:),bbx2t(3,:),'*g');hold on;
    plot3(bxptsRegR2(1,int2),bxptsRegR2(2,int2),bxptsRegR2(3,int2),'.m'); 
    plot3(bxptsRegR2(1,~int2),bxptsRegR2(2,~int2),bxptsRegR2(3,~int2),'.b'); 
    axis equal;
end

UNION = V1 + V2 - Vint;
IOU = Vint/UNION;
end
