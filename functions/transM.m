function [ Mout ] = transM( M, trasl)
%Perform the translation 

Mout = M;

for i=1:size(M,1)/4
    Mout(4*i,:) = (M(4*i,:)'-M(4*i-3:4*i-1,:)'*trasl')';
end


end

