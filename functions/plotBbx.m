function  p = plotBbx( BBx, clr, lnwdth, label )
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

lines = [3   3   1   1 ;...
         1   3   3   1 ;...
         2   4   4   2 ;...
         2   2   4   4 ];

p = plot( BBx(lines(1:2,:)), BBx(lines(3:4,:)),'-','Color',clr,'linewidth',lnwdth);

if nargin==4
    text(BBx(1),BBx(2),label,'FontSize',12,'backgroundColor',[1 1 1]);
end
end

