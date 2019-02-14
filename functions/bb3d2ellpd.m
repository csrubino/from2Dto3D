function [ Q ] = bb3d2ellpd( bbx3dcent, P)
%BBX3D2ELLIPSOID Converts a 3D bounding box into an ellipsoid represented
%by a quadric
%   
%   bbx3d : [4 x 8] array of homogeneous 3D points
% 
if nargin<2
    P = eye(4);
end

x0          = mean(bbx3dcent,2);
absBbx      = abs(bbx3dcent);
ax          = mean(absBbx,2);
Q           = -eye(4);
Q(1:3,1:3)  = diag(ax.^(-2));
T           = P*[eye(3), x0; [0 0 0 1]];
Qadj        = T*Q^(-1)*T';
Qadj        = Qadj./abs(Qadj(4,4));
Q           = Qadj^(-1);

end

