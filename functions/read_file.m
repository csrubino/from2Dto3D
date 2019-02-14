function [labels,fns,fnames,bbx,ojs] = read_file(filename)
% parse input file
fid = fopen(filename);
%1004 frame-001004 office_chair 4 0.0 510.26663799 588.488333087 846.272237645 935.554077731
try
  C = textscan(fid, '%d %s %s %s %d %f %f %f %f %f');
catch
  keyboard;
  error('This file is not in KITTI tracking format or the file does not exist.');
end
fclose(fid);
fns=unique(C{1});
nimages = length(fns);
ojs=unique(C{5});
n_o = length(ojs);
bbx = nan(nimages,n_o*4);
for i=1:length(C{1})% for each line
    f=find(fns==C{1}(i)); % get frame number
    o=find(ojs==C{5}(i)); % get object number
    bbx(f,(4*o-3):4*o)=[ C{7}(i) C{8}(i) C{9}(i) C{10}(i)];
    labels{o}=C{4}(i);
    fnames{f}=C{2}(i);
end


