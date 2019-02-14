%WPLOT3
%   WPLOT3(COLUMN_VECTOR, SYMBOL)
% 
% returns plot of a 3D column vector
%
%  INPUT:
% 
% column_vector   = the vector which we want to represent
% 
% symbol          = the symbol and color associated to each point


function wplot3(column_vector,color)

plot3(column_vector(:,1),column_vector(:,2),column_vector(:,3),'.','Color',color);
axis equal; xlabel('X');ylabel('Y');zlabel('Z');
