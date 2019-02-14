function [ K ] = extractIntrinsic( folder )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

fid     = fopen([folder '/_info.txt'],'r');
intrData = textscan(fid, '%s');
fclose(fid);

idx     = strcmp(intrData{1}, 'm_calibrationColorIntrinsic');
findidx = find(idx);
vectorisedK = str2double(intrData{1}(findidx+2:findidx+17));
K_homo  = reshape(vectorisedK,4,4)';
K       = K_homo(1:3,1:3);

end

