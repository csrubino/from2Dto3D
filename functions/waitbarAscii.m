function waitbarAscii( step, total, sz )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin<3
    sz = 10;
end

if step~=1 
   fprintf(repmat('\b',1,sz+6));
end


WbFlag = 1;
bbar = round(sz*step/total);

if ispc
    for b=1:bbar
        fprintf('D');
    end

else
    for b=1:bbar
        fprintf('█');
    end
end
for b=bbar+1:sz
    fprintf('_');
end

fprintf(' %3.0f%% ',step/total*100);

if step == total
    fprintf('\n');
end
