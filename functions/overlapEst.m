function [ IoU ] = overlapEst( Rec, GT )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

IoU = nan(1,length(Rec));

for i=1:length(Rec)
    IoU(i) = cuboidOverlap(GT(i).bbx3d, Rec(i).bbx3d_CG, 100000, false);
end

end

