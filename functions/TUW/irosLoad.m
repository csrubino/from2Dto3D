function [ BBx, M, obj, objReg, W] = irosLoad( base_dir, n_set, K, ppt )
%IROSLOAD Find all the bounding boxes, motion matrices and reprojected 
% features given the PCD and the calibration matrix
% 
%   INPUT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% base_dir : the directory of the TUW dataset
% n_set : number of the set inside the dataset
% K     : Calibration Matrix
% ppt   : passepartout around the Bounding Box generated 
%         from the features
% 
% 
%   OUTPUT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% BBx   : The matrix of all the bounding boxes [F x 4O]
% M     : The motion matrix [4F x 4O]
% obj   : The unregistered clouds of homogeneus 3D features
% objReg: The clouds of homogeneus 3D feature registered 
%         with the poses [4 x nP]
% W     : Matrix of of homogeneus reprojected 
%         features [3 x nP]
% or    : Orientation of the mask inside the window by using segmentation
% 

% Number of frames associated to that SET

dir_cmpl = sprintf('/TUWdata/iros_dataset/test_set/set_%05d',n_set);
n_fr = length(dir([base_dir dir_cmpl '/*.pcd']));

% Number of objects

% Load Pose Matrix M inside Annotations Folder ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% M is the Pose matrix with dimensions [4F x 4O]
% The pose matrix is the transposed of the homogeneous form 
%  [  R   t ]
%  [0 0 0 1 ]

dirSet_tmp1 = sprintf('/TUWdata/iros_dataset/annotations/set_%05d',n_set);
dirSetFrst = dir([base_dir dirSet_tmp1 sprintf('/%05d*.txt',1)]);
n_o = size(dirSetFrst,1);
M = NaN(n_fr*4,n_o*4);

for f=0:n_fr-1
%     accV = [];
%     dirSet(accV) = [];
    dirSet = dir([base_dir dirSet_tmp1 sprintf('/%05d*.txt',f)]);
    for o=1:n_o
        fileIDt = fopen([base_dir dirSet_tmp1 '/' dirSet(o).name]);
        inputt  = textscan(fileIDt,'%f');
        M_oxi   = reshape(inputt{1,1},4,4);
        M(4*f+1:4*f+4,4*o-3:4*o)  = M_oxi;
        fclose('all');
    end
end

% Registered objects ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

warning ('off','all');
% 
% for f =0:n_fr-1
% %     figure;
%     for o=1:n_o
%         obj{o} = loadpcd(['./iros_dataset/models/' dirSet(o).name(7:end-6) '.pcd']);
%         objReg{o} = M(4*f+1:4*f+4,4*o-3:4*o)'*[obj{o}(1:3,:); ones(1,size(obj{o},2))];
% %         plot3(objReg{o}(1,:),objReg{o}(2,:),objReg{o}(3,:),'.'); hold on;
%     end
% %     axis equal;
% end

% Reprojected objects ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Calibration Matrix K

% BBx = [F x 4*O]
BBx = zeros(n_fr,n_o);

% if plotflag ==1
%     figure;
% end

for f=0:n_fr-1
%     if plotflag ==1
%         h = findall(gca);
%         delete(h);
%         imshow([sprintf('../IROSdataset/iros_dataset/annotated_images/scenes/set_%05d',n_set) sprintf('/%05d.jpg',f)]);
%         hold on;
%     end
    for o=1:n_o
        obj{o} = loadpcd([base_dir '/TUWdata/iros_dataset/models/' dirSet(o).name(7:end-6) '.pcd']);
        objReg{f+1,o} = M(4*f+1:4*f+4,4*o-3:4*o)'*[obj{o}(1:3,:); ones(1,size(obj{o},2))];
        Mf = (M(4*f+1:4*f+4,4*o-3:4*o))';
        P = K*Mf(1:3,:);
        W{f+1,o} = normHomo(P*[obj{o}(1:3,:); ones(1,size(obj{o},2))],3);
        BBx(f+1,4*o-3:4*o) = w2BBx(W{f+1,o},ppt);
    end
end

end

