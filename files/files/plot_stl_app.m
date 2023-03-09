function [] = plot_stl_app(ui,triangles)
%%%
%displaystl3D data graphics
%ui：Pictures displayed
%triangles：Triangle data
%%%
v = triangles(:,1:9);%obtainxyzTotal rows of data*9column
vr = reshape(v',3,size(v,1)*3)';%9Column data becomes(Number of data rows*3)*3column
vrn = zeros(size(vr,1)+size(triangles,1),3);%Initialize display data as0((Number of data rows*4)*3)
%Initial quantity:increment:final value
vrn(1:4:end) = vr(1:3:end);%X:data。1,4,7--1,5,9
vrn(2:4:end) = vr(2:3:end);%Y:data。2,5,8--2,6,10
vrn(3:4:end) = vr(3:3:end);%Z:data。3,9,9--3,7,11

vrn(4:4:end) = ones(size(triangles,1),3).*[NaN, NaN, NaN];%NaN, NaN, NaN--4,10,12
%h = figure(1);
%set(fig, 'renderer','opengl')
%view(3)
%plot3(vr(:,1),vr(:,2),vr(:,3))

plot3(ui,vrn(:,1)',vrn(:,2)',vrn(:,3)','Color','b');%displaystl3D data

%display graphicsxyzCoordinate range
mx = max(max(v));
mn = min(min(v));
axis(ui,[mn mx mn mx mn mx]);

end
