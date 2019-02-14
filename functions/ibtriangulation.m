function [Rec, bbx3D] = ibtriangulation(PPM, GT, C3D, infR, supR, bbx, frVw, plot)

%N_vies Interval-based Triangulation
%
%INPUT
%PPM: camera matrices, in the format 3x4xn_views
%imagePoints: correspondent points, in the format n_pointsx2xn_views
%error: starting data error
%
%OUTPUT
%w: 3D cuboids 
%
%Remember to install INTLAB Matlab toolbox before running this script
%
%Michela Farenzena - June 2006

if size(PPM,1)~=3 || size(PPM,2)~=4
    fprintf('Error: PPM must be in 3x4xn_views format');
end

nO = size(infR,1);
% global numberOfViews;
bbx3D = nan(nO,6);
% bbx3Dv = nan(nO,8);

for j = 1:size(infR,1)
%     clearvars int_point w in su x1 y2 z1 x2 y2 z2
	numberOfViews = sum(frVw(:,j));
%     int_point = midrad(imagePoints,error);
    int_point = intval(zeros(size(infR,1), 2,numberOfViews));
    int_point = infsup(infR(j,:,frVw(:,j)),supR(j,:,frVw(:,j)));
    
%     figure;
%     plot3(GT{j}.V(:,1),GT{j}.V(:,2),GT{j}.V(:,3),'.m'); hold on;

    w = intersect_rays(PPM(:,:,frVw(:,j)),C3D(1:3,j),int_point,false)';

    %Display the result
    in = inf(w(1,:));
    su = sup(w(1,:));
    x1 = in(1);
    y1 = in(2);
    z1 = in(3);
    x2 = su(1);
    y2 = su(2);
    z2 = su(3);
    bbx3D(j,:) = [x1,y1,z1,x2,y2,z2];
    tmpbbx3Dv = [x1,y1,z1; x2,y1,z1; x2,y1,z2;x1,y1,z2;...
            x1,y2,z1; x2,y2,z1; x2,y2,z2;x1,y2,z2];
    if tmpbbx3Dv(1,1) == inf || tmpbbx3Dv(1,1) == -inf
        Rec(j).Q = [zeros(3,4);zeros(1,3),-1];
        Rec(j).bbx3d_IA =  zeros(3,8);
    else
        Rec(j).Q = bb3d2ellpd( tmpbbx3Dv');
        Rec(j).bbx3d_IA =  tmpbbx3Dv';
    end
end

end

% for j = 1:size(w,1)
%     hold on
%     cube(inf(w(j,:)), sup(w(j,:)), 'k')
% end
% 
% xlabel('x axis');
% ylabel('y axis');
% zlabel('z axis');
% grid on
% axis equal



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function W = intersect_rays(PPM, Cnt3, imagePoints,plotF)

shuffle = randperm(size(PPM,3));
PPM = PPM(:,:,shuffle);
imagePoints = imagePoints(:,:,shuffle);

vec_ni=[];
vec_mu=[];

% global numberOfViews;
numberOfViews = size(PPM,3);

W = ones(3,size(imagePoints,1))*infsup(-Inf,Inf);

for i = 1:numberOfViews
    waitbarAscii(i,numberOfViews,20);
    for j = i+1:numberOfViews 
        cl = - inv(PPM(:,1:3,i))*PPM(:,4,i);
        P1 = PPM(:,:,i);
        P2 = PPM(:,:,j);
        er = P2 * [cl' 1]';
        m1 = imagePoints(:,:,i);
        m2 = imagePoints(:,:,j);
        Wij = [];
        for m = 1:size(m1,1)
        % Closed-form triangulation from 2 views
            pr = [m1(m,:) 1]';
            pl = [m2(m,:) 1]';
            pp = P2(:,1:3)*inv(P1(:,1:3))* pr;
            d = cross(er,pp);
            mu = (cross(pl,pp)'* d) / norm(d)^2;
            d = cross(pp,er);
            ni = (cross(pl,er)'* d) / norm(d)^2;
            w1 = [cl; 1]+ ni/mu*[inv(P1(:,1:3))*pr; 0];
            if isnan(w1(1))
                w1 = infsup([-Inf,-Inf,-Inf],[Inf,Inf,Inf])';
            end
            Wij = [Wij w1(1:3)]; 
        end
        % Then, intersect the results
        inssp = sup(Wij);
        ininf = inf(Wij);
        if inssp(1) ~= inf
            [~, imin] = min([abs(norm(inssp)),abs(norm(ininf))]);
            intTot = [inssp,ininf];
            side1 = intTot(:,imin);
            side2 = - side1 + 2*Cnt3;
            Wij = infsup(min(side1,side2),max(side1,side2));
%             if plotF    
%                 plot3(side1(1),side1(2),side1(3),'*r'); hold on;
%                 plot3(side2(1),side2(2),side2(3),'*b'); hold on;
%                 hold on;
%                 % plotBbx3d([nnf(1),nnf(2),nnf(3),ssp(1),ssp(2),ssp(3)],'r'); 
%                 pause(.00025);
%                 %hn = findobj(gca,'color','red');
%                 % delete(hn);
%             end
            W = intersect(W,Wij);
        end
         if(~isempty(find(isnan(W))))
             fprintf('Empty intersection: correspondence %d \n',find(isnan(W(1,:))))
             return
         end
    end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function cube(in, su, color)

%Display a 3D cuboid

x1 = in(1);
y1 = in(2);
z1 = in(3);
x2 = su(1);
y2 = su(2);
z2 = su(3);

hold on;


plot3([x1,x1,x1,x1],[y1,y2,y2,y1],[z1,z1,z2,z2],color, 'linewidth', 1.0);
plot3([x2,x2,x2,x2],[y1,y2,y2,y1],[z1,z1,z2,z2],color, 'linewidth', 1.0);
plot3([x1,x1,x2,x2],[y1,y1,y1,y1],[z1,z2,z2,z1],color, 'linewidth', 1.0);
plot3([x1,x1,x2,x2],[y2,y2,y2,y2],[z1,z2,z2,z1],color, 'linewidth', 1.0);
plot3([x1,x2,x2,x1],[y1,y1,y2,y2],[z1,z1,z1,z1],color, 'linewidth', 1.0);
plot3([x1,x2,x2,x1],[y1,y1,y2,y2],[z2,z2,z2,z2],color, 'linewidth', 1.0);


end