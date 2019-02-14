function [ GT ] = extractGTpoints( base_dir, ojs, labels, V)
%EXTRACTGTPOINTS 

addpath('jsonlab-1.5');

jsonFile = dir([base_dir '/*.json']);

data1 = loadjson([base_dir '/' jsonFile(1).name]);
data2 = loadjson([base_dir '/' jsonFile(2).name]);
ptclouds = struct;
for i=1:length(ojs)
    segments = data1.segGroups{ojs(i)+1}.segments;
    idx = [];
    for j=1:length(segments)
        idxtmp = find(data2.segIndices==segments(j));
        idx = [idx idxtmp];
    end
    GT(i).V = V(idx,:);
    clearvars segments idx
    GT(i).object  = ojs(i);
    GT(i).labels  = labels{i};
    GT(i).bbx3d   = gtBbx(GT(i).V);
end



end

