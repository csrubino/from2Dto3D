function [ bbx3d ] = gtBbx( V )
% GTBBX generates a 3D bounding box from a point cloud
% with dimensions [nP x 3]

if size(V,1)>3
    Ktmp            = convhulln(double(V));
    Ktmp            = unique(Ktmp(:));  
    Qtmp            = double(V(Ktmp,:));

    [coeff, ~, ~]   = pca(Qtmp(:,[1,2]));
    pntCnt          = (max(Qtmp)+min(Qtmp))*.5;

    % Plotting part (for check)
    % plot3(V(:,1),V(:,2),V(:,3),'g'); hold on;
    % plot3(pntCnt(1),pntCnt(2),pntCnt(3),'*r');
    % plot3(Qtmp(:,1),Qtmp(:,2),Qtmp(:,3),'.'); hold on;
    %

    T       = [coeff,[0;0],pntCnt([1,2])';0 0 1 pntCnt(3); 0 0 0 1];
    Qal     = eye(3,4)*T^(-1)*[Qtmp,ones(size(Qtmp,1),1)]';
    bbx3d_tmp   = bbx3d2pts([min(Qal'), max(Qal')]);
    bbx3d = eye(3,4)*T*[bbx3d_tmp;ones(1,size(bbx3d_tmp,2))];

    % Plotting part (for check)
    % plot3(Qal(1,:),Qal(2,:),Qal(3,:),'.'); hold on;
    % plotBbx3d(bbx3d,'r');
else
    bbx3d= zeros(3,8);
end

end
