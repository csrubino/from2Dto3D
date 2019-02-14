function [M,K,bbx,Imm,GT,frVw,camSz, or] = datasetTUW( base_dir, n_set )
%DATASETTUW takes all the data from the specified dataset (in this case
%TUW).
% 
%   The website from which you can download this dataset is:
%   https://repo.acin.tuwien.ac.at/tmp/permanent/show_dataset.php?dir_gt=iros2014/automatic_images/gt&dir_scenes=iros2014/automatic_images/scenes&model_dir=iros2014/training_data/models&dataset=0&frame=0&occlusion_dir=iros2014/automatic_ground_truth&num_shown_dataset_letters=9
%
%SYNTAX
% 
% [M,K,bbx,Imm,GT,frVw,camSz] = datasetTUW( n_set )
% 
%INPUT
% 
% base_dir[STRING]: Base directory to get all the data.
% n_set  [1 x  1 ]: The set number which indicates a particular sequence
% 
%OUTPUTS
% 
% M     [4F x 3O]:  motion matrix, which gives the poses of the camera with  
%                   respect to the world frame; the single pose matrix is 
%                   [4 x 3];
% K     [3 x  3 ]:  Camera Calibration Matrix;
% bbx   [F x  3O]:  Ellipses Matrix;
% frVw  [F x  O ]:  Matrix of the views which are considered for a given 
%                   object;
% camSz :  Dimension of the stylized camera;
% 
% See also DATASETKITTI, DATASETACCV, DATASETKINECT.
% 

% Internal Parameters 
fx  = 528;
fy  = 528; 
px  = 319.5;
py  = 239.5;
dx  = 640;
dy  = 480;

% Calibration matrix for Internal Parameters 
K = [fx 0 px; 0 fy py; 0 0 1];
camSz = 0.1;

[bbx, MallObj, obj, objReg, W] = irosLoad(base_dir, n_set,K,6);
n_f     = size(bbx,1);
n_o     = size(bbx,2)/4;

% Referment object
refObj  = 2;

% Load all the Images
for f=1:n_f
    Imm{f}.I = imread([base_dir '/TUWdata/' sprintf('/iros_dataset/annotated_images/scenes/set_%05d',n_set) sprintf('/%05d.jpg',f-1)]);
end

cntMx = zeros(3,n_o);

for o=1:n_o
    trMx      = (MallObj(1:4,4*refObj-3:4*refObj)')\MallObj(1:4,4*o-3:4*o)';
    cntMx(:,o)= trMx(1:3,4);
end

mnCnt = mean(cntMx,2); 

pointcloud = [];

% Load the ground truth of the Objects
for o=1:n_o
    Ktmp        = convhulln(double(obj{o}(1:3,:))');  
    Ktmp        = unique(Ktmp(:));  
    Vtmp        = double(obj{o}(1:3,Ktmp));
%     [A, x0]     = MinVolEllipse(Vtmp, .01);
    tmpBbx3D    = bbx3d2pts([min(Vtmp(1,:)),min(Vtmp(2,:)),min(Vtmp(3,:)),...
                              max(Vtmp(1,:)),max(Vtmp(2,:)),max(Vtmp(3,:))]);
%     GT{o}.Q     = [[A,-A*x0];[(-A*x0)',(x0'*A*x0-1)]];
%     GT{o}.Q     = GT{o}.Q/GT{o}.Q(4,4);
    trMx        = (MallObj(1:4,4*refObj-3:4*refObj)')\MallObj(1:4,4*o-3:4*o)';
    trMx        = [trMx(:,1:3),[trMx(1:3,4)-mnCnt;1]];
    tmp2bbx3d   = trMx*[tmpBbx3D;ones(1,size(tmpBbx3D,2))];
    GT{o}.bbx3d = tmp2bbx3d(1:3,:);
%     GT{o}.Q     = invAdj(trMx*adjA(GT{o}.Q,4)*trMx');
    GT{o}.V     = objReg{1,o}'/([eye(3),mnCnt;0 0 0 1]'*MallObj(1:4,4*refObj-3:4*refObj));%*[M(1:4,:),[0 0 0 1]'];
%     tmppc       = pointCloud(GT{o}.V(:,1:3));
%     if o == 1
%         pcmrg = tmppc;
%     else
%         pcmrg  = pcmerge(pcmrg,tmppc,1);
%     end
end

% % % pcSam = pcread(sprintf('%s/ACCVdata/%s_1/data/Export/SamPointCloud.ply',base_dir,objSeq{seq}));
% % % cmap1 = ones(size(M11al(1:3,4:4:end),2),1)*[1 0 0];%colormap(winter(size(M11almesh,2)));
% % % pc1 = pointCloud(M11al(1:3,4:4:end)','Color',uint8(cmap1*255));
% % % pctot1 = pcmerge(pcSam,pc1,1);
% pcwrite(pcmrg,[base_dir '/TUWdata/' sprintf('/iros_dataset/annotated_images/scenes/set_%05d/mesh.ply',n_set) ]);

for f=1:n_f
    Mtmp        = MallObj(4*f-3:4*f,4*refObj-3:4*refObj)'*[eye(3),mnCnt;0 0 0 1];
    M(4*f-3:4*f,:) = Mtmp(1:3,:)';
end

% Verify when the object is visible in a given frame

frVw = nan(n_f,n_o);
or  = nan(n_f,n_o);

for f=1:n_f
    for o=1:n_o
        if exist([ base_dir '/TUWdata/irosSequences/seq' num2str(n_set) '/obj' num2str(o) '/frm' num2str(f) '.png'], 'file') == 2
%            wndOr = imread([base_dir '/TUWdata/irosSequences/seq' num2str(n_set) '/obj' num2str(o) '/frm' num2str(f) '.png']);
           frVw(f,o) = 1;
%            mask     = imread([ base_dir '/TUWdata/irosSequences/seq' num2str(n_set) '/obj' num2str(o) '/segmentations/Segmentation_image' num2str(f) '.jpg']);
%            mask     = mask(:,:,1);
%            mask     = round(mask./max(max(mask)));
%            maskSzOr = size(wndOr);
%            maskOr   = imresize(logical(mask(:,:)),maskSzOr(1:2));
%            AA       = regionprops(maskOr,'area');
%            areaSz   = nan(1,length(AA));
%            for i = 1:length(AA)
%                areaSz(i) = AA(i).Area;
%            end
%            [wwww, IaMx] = max(areaSz);
%            degAng   = regionprops(maskOr,'orientation');
%            tmpCnt   = mean(abs(bbx(f,1:2)-bbx(f,3:4))./2);
%            or.mu(2*f-1:2*f,o)      = tmpCnt'+[bbx(f,1);bbx(f,2)];
%            tmp1                    = regionprops(maskOr,'MajorAxisLength');
%            tmp2                    = regionprops(maskOr,'MinorAxisLength');
%            or.axDim(2*f-1:2*f,o)   = [tmp1(IaMx).MajorAxisLength/2;...
%                                      tmp2(IaMx).MinorAxisLength/2];
%            ng      = degAng(IaMx).Orientation;
%            angTmp  = degAng(IaMx).Orientation;
%            [wwwwww,maxAxisIdx] = max([abs(bbx(f,4*o-1)-bbx(f,4*o-3));abs(bbx(f,4*o)-bbx(f,4*o-2))]);
%            if maxAxisIdx==2
%               ng  = angTmp-90;
%            else
%               ng  = angTmp;
%            end
% 
%            or.or(f,o)  = ng;
%            or.or_(f,o) = -angTmp;
%            clear maskSzOr tmp1 tmp2
        else
           frVw(f,o) = 0;
        end
    end
end

frVw = logical(frVw);

% % Condition for number of views less than 3
% nOfWvTot = sum(frVw,1);
% frVw(:,nOfWvTot<3) = frVw(:,nOfWvTot<3)*0;

end

