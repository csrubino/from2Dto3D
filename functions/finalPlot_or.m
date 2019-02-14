function [ outFrame ] = finalPlot_or(  Rec, M, bbx, Imm, GT, frVw, camSz, F1, F2, F3)
%FINALPLOT generates all the plots of the ellipses on the frames and of the
% 3D environment
% 
% PLOTTING LEGEND:
% 
% 2D :
% red   = ellipses from the bounding boxes (aligned or not wr the masks)
% blue  = ellipses reprojected from the ground truth
% green = ellipses reprojected from the reconstructed ellipsoid
% 
% 3D :
% 
% blue  = ground truth ellipsoids
% green = reconstructed ellipsoids
% 
% F1 : flag of the ellipse plotting
% F2 : flag of the ellipsoid plotting
% F3 : flag of the motion

n_f      = size(frVw,1);
n_o      = size(frVw,2);
panelClr = [.8 .8 .8];%[.2 .8 1];

% % ~~~~~~~~~~ DA mettere nella gestione dei dati ~~~~~~~~
% frVw     = logical(frVw);
% doubFrVw = double(frVw);
% numFrVw  = doubFrVw;
% 
% for o=1:n_o
%     numFrVw(frVw(:,o),o) = 1:sum(doubFrVw(:,o));
% end
% 
% % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scrsz = get(0,'ScreenSize');
if F1==1
s1  = figure;
end
if F2==1
    s2  = figure; 
end
if F3==1
    s3  = figure('Color',[1 1 1]);
end

seqF= find(sum(frVw,2)~=0);
 
clr = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1;.5 0 .5; 1 0 .5; .5 1 0;1 .5 0; 1 1 .5; .5 .5 0; 1 .5 1; .5 .5 1; .5 1 .5; 1 .3 .3; .3 .7 .3; .5 .3 .3; .7 .7 0];

for f=seqF'
    if F1==1
        figure(s1);
        cla;
        set(s1,'Name',num2str(f));
        if iscell(Imm)
            imshow(Imm{f}.I); title(['frame ' num2str(f)]); hold on;
        end
        for o=1:n_o
            o
            if frVw(f,o)~=0                
                figure(s1);
                if isfield(GT,'labels')
                    plotBbxRot(bbx(2*f-1:2*f,4*o-3:4*o),[1 1 0],3,GT(o).labels);
                else
                    plotBbxRot(bbx(2*f-1:2*f,4*o-3:4*o),[1 1 0],3);
                end
                set(gca,'position',[0 0 1 1],'units','normalized');
            end
        end
        hold off;
    end

    
    if F2==1 && f==min(seqF)
        for o=1:n_o
            figure(s2)
            %cla;
            if o==1
                if isfield(GT(1),'scans')
                    plot3(GT(1).scans(:,1),GT(1).scans(:,2),GT(1).scans(:,3),'.','color',panelClr); hold on;
                end
                if isfield(GT(1),'mesh')
                    pcshow(GT(1).mesh); hold on;
                end
            end
            if ~isempty(Rec)
                if isfield(Rec(o),'bbx3d_CG') 
                    plotBbx3d(Rec(o).bbx3d_CG,'g'); hold on;
                end
                if isfield(GT(o),'bbx3d') 
                    plotBbx3d(GT(o).bbx3d,'b'); hold on;
                end
                if isfield(Rec(o),'K') 
                    trisurf(Rec(o).K,Rec(o).vt(:,1),Rec(o).vt(:,2),Rec(o).vt(:,3), 'FaceColor', 'none', 'EdgeColor', clr(o,:), 'Linewidth',1.0);
                end
            end
%             frame_repr(zeros(3,1),eye(3)*camSz);
            if isfield(GT(o),'V')
                %hold on; wplot3(GT(o).V,clr(o,:));
            end
        end
        %hold off; grid off; axis off;
    end
    
    if F3==1 
        if f==min(seqF)          
            for o=1:n_o
                figure(s3)
                if o==1
                    if isfield(GT(1),'scans')
                        plot3(GT(1).scans(:,1),GT(1).scans(:,2),GT(1).scans(:,3),'.','color',panelClr);hold on;
                    end
                end
%                 frame_repr(zeros(3,1),eye(3)*camSz);
                if isfield(GT(o),'V')
                    hold on;
                    if isfield(GT(o),'pc')
                        pcshow(GT(o).pc,'MarkerSize',15);
                    else
                        wplot3(GT(o).V,[1 0 0]);
                    end
                end
            end
        end
        figure(s2);
        hold on;
        camera3D((-M(4*f-3:4*f-1,1:3)*M(4*f,1:3)')',M(4*f-3:4*f-1,1:3),camSz);
        hold off;
    end
    grid off; axis off;
    pause(0.05);
end

outFrame = gcf;
