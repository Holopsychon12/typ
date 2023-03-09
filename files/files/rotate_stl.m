function [tri] = rotate_stl(tri,ax,theta)
%%%
%Rotate Triangle Data
%tri：Triangle data
%ax：Rotation axis
%theta：Rotation angle
%%%
    if ax == 'x'
        rotmat = [1, 0, 0; 
                  0, cosd(theta),-sind(theta); 
                  0, sind(theta),cosd(theta)];%xShaft rotation coefficient
    elseif ax == 'y'
        rotmat = [cosd(theta), 0 , sind(theta); 
                  0,1,0; 
                  -sind(theta) 0, cosd(theta)];%yShaft rotation coefficient
    elseif ax == 'z'
        rotmat = [cosd(theta), -sind(theta), 0;
                 sind(theta), cosd(theta),0; 
                 0, 0,1];%zShaft rotation coefficient
    else
        error('axis should be x y or z')
    end
    tri(:,1:3) = tri(:,1:3) * rotmat;%XAxis data
    tri(:,4:6) = tri(:,4:6) * rotmat;%yAxis data
    tri(:,7:9) = tri(:,7:9) * rotmat;%zAxis data
    tri(:,1:3:end) = tri(:,1:3:end) - min(min(tri(:,1:3:end)));%SubtractXminimum value
    tri(:,2:3:end) = tri(:,2:3:end) - min(min(tri(:,2:3:end)));%Subtractyminimum value
    tri(:,3:3:end) = tri(:,3:3:end) - min(min(tri(:,3:3:end)));%Subtractzminimum value
end