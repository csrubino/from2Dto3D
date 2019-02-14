function [Rec,bbx3d,C3D] = computeCubes(bbx, P, frVw, GT, Transf, plotF)

visObj = sum(frVw,1)~=0;

% Find the centers
[ ~ , C3D ] = centerTriang( bbx, P, frVw );

if plotF
    for i=1:length(GT)
        if ~isempty(GT(i))
            if isfield(GT(i),'V')
            plot3(GT(i).V(:,1),GT(i).V(:,2),GT(i).V(:,3),'.m'); hold on;
            elseif isfield(GT(i),'bbx3d')
                plotBbx3d( GT(i).bbx3d, 'b' ); hold on;
            end
            C3Dtr = Transf*C3D;
            plot3(C3Dtr(1,i),C3Dtr(2,i),C3Dtr(3,i),'*');
        end
    end
end

[ PPM, ~, infR, supR ] = cubFitVar( P, bbx );

[Rec, bbx3d] = ibtriangulation(PPM(:,:,:), GT, C3D, infR(:,:,:), supR(:,:,:), bbx, frVw, true);

for i=1:length(Rec)
    Rec(i).bbx3d_IA = eye(3,4)*Transf^(-1)*[Rec(i).bbx3d_IA;ones(1,8)];
end


% for o=visObj
%     visF = find(frVw(:,o));
%     shuffle = randperm(length(visF));
%     framesShuffled = visF(shuffle);
    % [Rec, bbx3d] = ibtriangulation(PPM(:,:,:), GT, C3D, infR(:,:,:), supR(:,:,:), bbx, frVw);
%     [Rec{o}, bbx3d] = ibtriangulation(PPM(:,:,framesShuffled), GT, C3D, infR(o,:,framesShuffled), supR(o,:,framesShuffled), bbx(framesShuffled,4*o-3:4*o), frVw(framesShuffled,4*o-3:4*o));
%     [Rec{o}, bbx3d] = ibtriangulation(PPM(:,:,framesShuffled), GT, C3D, infR(o,:,framesShuffled), supR(o,:,framesShuffled), bbx(framesShuffled,4*o-3:4*o), frVw(framesShuffled,4*o-3:4*o));
% end

%     for i=1:length(Rec)
%         if isempty(GT{i})
%             Rec{i} = [];
%         end
%     end
