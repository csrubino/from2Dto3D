% frame_repr(origin, matrix);
%
%   frame_repr plot the frame, given the matrix of the frame and the origin
%   point. This program needs vectarrow.m
% 
% 
%     x axes = yellow
%     y axes = blue
%     z axes = red
% 
% _________________________________________________________________________
% 
%-I/O
%
%   Given:
%
%      origin   the name of the origin point of the frame 3x1
%             
%      matrix   the frame matrix 3x3
%
% _________________________________________________________________________
% 
%   the call:
%
%      frame_repr(origin, matrix)
%
%   returns:
%
%      plot of the frame
%
%-Examples
%
%    frame_repr(P_O, FRAME_MATRIX)


function frame_repr(origin, matrix)

% asse x
vectarrow(origin',(origin' + matrix(1:3,1)'),'g');hold on;
text(origin(1)+matrix(1,1)/2,origin(2)+matrix(2,1)/2,origin(3)+matrix(3,1)/2,'x')

% asse y
vectarrow(origin',(origin' + matrix(1:3,2)'),'b');hold on;
text(origin(1)+matrix(1,2)/2,origin(2)+matrix(2,2)/2,origin(3)+matrix(3,2)/2,'y')

% asse z
vectarrow(origin',(origin' + matrix(1:3,3)'),'r');hold on;
text(origin(1)+matrix(1,3)/2,origin(2)+matrix(2,3)/2,origin(3)+matrix(3,3)/2,'z')

