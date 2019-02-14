clear all 
close all
clc

addpath(genpath('./functions'));

%% Load the datasets

objSeq = {'iron','duck','ape','can','driller','benchvise','glue','cat','lamp','phone'};
dtstNm = {'ACCV','TUW','KITTI','KINECT','FORD','SYNTH','TANGO'};
dataset         = 1;      % The number of the referred DATASET
seq             = 2;      % Sequences for the iterations
base_dir = '../datasetsfd';

[M,K,bbx,Imm,GT,frVw,camSz, or] = datasetTUW(base_dir, seq);



%% RUN INTLAB

run './Intlab/startintlab.m'

%% CONSTRAINED GEOMETRY

[ Rec1, ~ ] = attempt3baseline( bbx, P, frVw, traslZ, Transf );
hold on; 

if isfield(GT(1),'mesh')
    pcshow(GT(1).mesh);
end

for i=1:length(Rec1)
    plot3(GT(i).V(:,1),GT(i).V(:,2),GT(i).V(:,3),'.g');
end

%% PLOT dataset

outFrame = finalPlot( Rec1, M, bbx, Imm, GT, frVw, camSz, 0, 1, 0);


%% Interval Analysis

Transf              = eye(4);
[Rec2,bbx3d,C3D]    = computeCubes(bbx, P, frVw, GT, Transf, false);

for i=1:length(GT)
    if ~isempty(GT(i))
        if isfield(GT(i),'V')
           plot3(GT(i).V(:,1),GT(i).V(:,2),GT(i).V(:,3),'.m'); 
           hold on;
        end
        if isfield(GT(i),'bbx3d')
           plotBbx3d( GT(i).bbx3d, 'b' ); hold on;
        end
        C3Dtr = Transf*C3D;
        plotBbx3d( Rectmp(i).bbx3d_IA, 'g' ); hold on;
    end
end


Rec(1).bbx3d_CG = Rec1(1).bbx3d_CG;
Rec(1).bbx3d_IA = Rec2(1).bbx3d_IA;

IoU_1 = cuboidOverlap(GT(1).bbx3d, Rec(1).bbx3d_CG, 100000, true)
IoU_2 = cuboidOverlap(GT(1).bbx3d, Rec(1).bbx3d_IA, 100000, true);
