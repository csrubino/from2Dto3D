function  p = plotBbxRot( BBx, clr, lnwdth, label )
%PLOTBBX plot bounding boxes 
% 
%SYNTAX
% 
% p = plotBbx( BBx, clr, lnwdth )
% 
if nargin==1
    clr    = [1 0 0];
    lnwdth = 3;
elseif nargin==2
    lnwdth = 3;
end

lines = [ ];

p = plot( BBx(1,[1,2,3,4,1]), BBx(2,[1,2,3,4,1]),'-','Color',clr,'linewidth',lnwdth);

if nargin==4
    text(BBx(1),BBx(2),label,'FontSize',12,'backgroundColor',[1 1 1]);
end
end

