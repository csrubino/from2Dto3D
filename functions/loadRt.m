function Rt = loadRt(obj_name)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
filePtR = [obj_name];

fileIDR = fopen([filePtR '/transform.dat']);
inputR  = textscan(fileIDR,'%f');
Rt      = reshape(inputR{1,1}(3:2:end),4,3);

end

