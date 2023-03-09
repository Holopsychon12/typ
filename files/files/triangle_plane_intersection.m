function [pts_out,size_pts_out] = triangle_plane_intersection(triangle_checklist,z_slices)
%%%
%this function calculates the intersection of triangles and a given plane.
%needed by slice_stl_create_path function
%triangle_checklist：Layer data checklist
%z_slices：Layer height data list

%pts_out：Point list
%size_pts_out：
%%%


triangle_checklist = triangle_checklist';%Transpose matrix

p1 = triangle_checklist(1:3,:);%xdata
p2 = triangle_checklist(4:6,:);%ydata
p3 = triangle_checklist(7:9,:);%zdata

c = ones(1,size(p1,2))*z_slices;%AllXthat 's okZLayer data multiplication
P = [zeros(1,size(p1,2));zeros(1, size(p1,2));ones(1,size(p1,2))];%point。xNumber of rows of*3
t1 = (c-sum(P.*p1))./sum(P.*(p1-p2));%x
t2 = (c-sum(P.*p2))./sum(P.*(p2-p3));%y
t3 = (c-sum(P.*p3))./sum(P.*(p3-p1));%z
intersect1 = p1+bsxfun(@times,p1-p2,t1);%xAndyInteractive data
intersect2 = p2+bsxfun(@times,p2-p3,t2);%yAndzInteractive data
intersect3 = p3+bsxfun(@times,p3-p1,t3);%zAndxInteractive data
%Select the value that meets the conditions
i1 = intersect1(3,:)<max(p1(3,:),p2(3,:))&intersect1(3,:)>min(p1(3,:),p2(3,:));
i2 = intersect2(3,:)<max(p2(3,:),p3(3,:))&intersect2(3,:)>min(p2(3,:),p3(3,:));
i3 = intersect3(3,:)<max(p3(3,:),p1(3,:))&intersect3(3,:)>min(p3(3,:),p1(3,:));


imain = i1+i2+i3 == 2;%Filter data by criteria

pts_out = [[intersect1(:,i1&i2&imain);intersect2(:,i1&i2&imain)],[intersect2(:,i2&i3&imain);intersect3(:,i2&i3&imain)], [intersect3(:,i3&i1&imain);intersect1(:,i3&i1&imain)]];
        
pts_out = pts_out';
size_pts_out = size(pts_out,1);
end






