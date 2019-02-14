function W = exact_triangulation_3_oriented(PPM, infR, supR)

%N_vies Triangulation: calculation of the exact diamond-shape
%
%INPUT
%PPM: camera matrices, in the format 3x4xn_views
%imagePoints: correspondent points, in the format n_pointsx2xn_views
%error: starting data error
%
%OUTPUT
%W: list of the convex hulls 
%
%
%Michela Farenzena - September 2006

if size(PPM,1)~=3 || size(PPM,2)~=4
    fprintf('Error: PPM must be in 3x4xn_views format');
end


global numberOfViews;
numberOfViews = size(PPM,3);
numberOfPoints = 1;%size(imagePoints,1);

int_point = intval(zeros(1, 2,numberOfViews));


for i=1:numberOfViews
    int_point(:,:,i) = infsup(infR(:,:,i), supR(:,:,i));
end


W = {};


hold on;

for i=1:numberOfPoints
    
%     er = error;
    
    
    fprintf('punto %d..\n ', i)  
    hold on
    vt = calculate_exact_solution(PPM, int_point(i,:,:));
    
%     while (isempty(vt) || size(vt,1) < 4)
%         if size(er,1) > 1
%             ipoint = midrad(mid(int_point(i,:,:)), er(i)+1);
%         else
%              ipoint = midrad(mid(int_point(i,:,:)), er+1);
%         end
%         vt = calculate_exact_solution(PPM, ipoint);
%         er = er+1;
%     end    
    if size(vt,1)>3
    [~, volume] =convhulln(vt);
    else
        volume = [];
    end
%     trisurf(K,vt(:,1),vt(:,2),vt(:,3), 'FaceColor', 'none', 'EdgeColor', 'b', 'Linewidth',3.0);
    
    %fprintf('errore iniziale %d, volume %d \n',er, volume);
    W = [W; {vt, volume}];
end

end

function V = calculate_exact_solution(PPM, correspondences)

    global numberOfViews;
    
    A = [];
    b = [];

    for i = 1:numberOfViews
        
        if any(isnan(correspondences(1,:,i)))
            continue
        else
        
        c = - PPM(:,1:3,i)\PPM(:,4,i);
        
        r1 = [c] +  10*[(PPM(:,1:3,i))\[inf(correspondences(1,1,i)), inf(correspondences(1,2,i)) 1]' ]; % basso sn
        r2 = [c] +  10*[(PPM(:,1:3,i))\[inf(correspondences(1,1,i)), sup(correspondences(1,2,i)) 1]' ]; % alto sn
        
        r3 = [c] +  10*[(PPM(:,1:3,i))\[sup(correspondences(1,1,i)), inf(correspondences(1,2,i)) 1]' ]; % basso dx
        r4 = [c] +  10*[(PPM(:,1:3,i))\[sup(correspondences(1,1,i)), sup(correspondences(1,2,i)) 1]' ]; % alto dx

        n = cross(r1(1:3)-c,r2(1:3)-c); % inserisco piano laterale sn
        A = [A; n']; 
        b = [b; c'*n];
        
        n = cross(r2(1:3)-c,r4(1:3)-c); % inserico piano alto
        A = [A; n'];
        b = [b; c'*n];
       
        n = cross(r4(1:3)-c,r3(1:3)-c); % inserisco piano laterale dx
        A = [A; n'];
        b = [b; c'*n];
        
        n = cross(r3(1:3)-c,r1(1:3)-c); % inserisco piano basso
        A = [A; n'];
        b = [b; c'*n];
        
        end
    end
    

     A = [A; 0 0 1; 0 0 -1];
     b = [b; 1000; 0];

     
     %V = plotregion(A,b);
     
     V = vertex_enumerate(A,b);
  %   fprintf('numero vertici %d \n', size(V,1));
        
end    
   
function  V = vertex_enumerate(A,b)

V = [];
Mat = [b -A];
% [N,D] = rat(Mat, 1e-20);
[N,D] = rat(Mat, 1e-20);
currentdir = pwd;
% cd /home/crubino/Desktop/lrslib-042b
% cd /home/crubino/Desktop/MATLAB/lrslib-041
fid = fopen('data.ine', 'w');
fprintf(fid, 'diamond\n');
fprintf(fid, 'begin\n');
fprintf(fid, '%d 4 rational\n', size(A,1));
for i=1:size(A,1)
    fprintf(fid, '%s/%s %s/%s %s/%s %s/%s\n', num2str(N(i,1)), num2str(D(i,1)), ...
            num2str(N(i,2)), num2str(D(i,2)), num2str(N(i,3)), num2str(D(i,3)), ...
            num2str(N(i,4)), num2str(D(i,4)));
%     fprintf('%s/%s %s/%s %s/%s %s/%s\n', num2str(N(i,1)), num2str(D(i,1)), ...
%             num2str(N(i,2)), num2str(D(i,2)), num2str(N(i,3)), num2str(D(i,3)), ...
%             num2str(N(i,4)), num2str(D(i,4)));
end
fprintf(fid, 'end\n');
fclose(fid);
% tic
% fprintf('./lrs %s > %s','data.ine', 'out.txt')
% system(sprintf('./lrs %s > %s','data.ine', 'out.txt'));
system(sprintf('lrs %s > %s','data.ine', 'out.txt'));
% t2 = toc;
fid = fopen('out.txt', 'r');
for i=1:8, tline = fgets(fid); end
while 1
    tline = fgets(fid);
    if (tline(2)~='1') 
        break; 
    else
        V = [V; str2num(tline(3:end)) ];
    end
end

fclose(fid);

% cd(currentdir);
cd('/media/crubino/OS/Users/CRubino/ICIAP');
end
