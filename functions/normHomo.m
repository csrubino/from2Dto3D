%NORMHOMO normalizes a matrix, to convert it in homogeneous coordinates
% _________________________________________________________________________
% 
% -Inputs:
% 
%      I         [m x n double] Matrix to normalize      
%             
%      sz        [1 x 1 double] Row size of the matrix
% 
% _________________________________________________________________________
% Created by Cosimo Rubino
% Last Modified: 03/10/2013


function O = normHomo(I,sz)

A       = eye(size(I,1)/sz,size(I,1)/sz);
Bz      = zeros(1,sz);
Bz(end) = 1;
B       = ones(sz,1)*Bz;
M       = kron(A,B);
temp1   = (M*(I));
O       = I./(M*(I));
end

