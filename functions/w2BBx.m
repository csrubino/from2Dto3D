function [ bbx ] = w2BBx( W, ppt )
%W2BX enerates Bounding Boxes given a set of 2D features W, adding a
%padding value set as a percentage of the total size

if nargin<2
    ppt = 6;
end

ppt = ppt/100;

mx = min(W(1,:));
my = min(W(2,:));
Mx = max(W(1,:));
My = max(W(2,:));

wx = Mx - mx;
wy = My - my;

bbx = [mx-(wx*ppt) my-(wy*ppt) Mx+(wx*ppt) My+(wy*ppt)];

end

