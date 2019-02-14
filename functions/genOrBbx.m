function [ bbxRot ] = genOrBbx(K,M,GT,Imm, plotF)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

F = size(M,1)/4;
O = length(GT);
bbxRot = zeros(2*F,4*O);

for f=1:F
    if plotF
        imshow(Imm{f}.I); hold on;
    end
    for o=1:O
        P = K*M(4*f-3:4*f,:)'*[GT(o).V';ones(1,length(GT(o).V))] ;
        P = normHomo(P,3);
        bbxRot(2*f-1:2*f,4*o-3:4*o) = p2bbx4pts( P );
        if plotF
            plot(P(1,:),P(2,:),'.');
            plotBbxRot(bbxRot(2*f-1:2*f,4*o-3:4*o),[1 0 0]);
        end
    end
    if plotF
        pause;
        cla;
    end
end

end

