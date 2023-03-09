function [movelist,z_slices] = dataScale(movelist,z_slices,range)
%%%
%Scale data
%movelist：xyCoordinates of layers
%z_slices：zcoordinate
%range：Printable range
%%%
    %xyzMaximum and minimum value of
    maxx = 0;
    maxy = 0;
    maxz = 0;
    minx = 0;
    miny = 0;
    minz = 0;
    
    for i =1: length(movelist) %Data per layer
        if length(movelist{1,i}) >0 %LayerXYMaximum and minimum
            maxx = max(maxx,max(movelist{1,i}(:,1)));
            maxy = max(maxy,max(movelist{1,i}(:,2)));
            minx = min(minx,min(movelist{1,i}(:,1)));
            miny = min(miny,min(movelist{1,i}(:,2)));    
        end
    end
    %ZMaximum and minimum
    maxz = max(z_slices);
    minz = min(z_slices);
    %xyzDifference between the maximum and minimum values of
    rangex = abs(maxx-minx);
    rangey = abs(maxy-miny);
    rangez = abs(maxz-minz);

    rangemax = max(max(rangex,rangey),rangez);%xyzThe larger of the range values of
    if rangemax/range>1 %The range length is greater than the given range length，Need to zoom
        scale = range/rangemax;%Scale
        for i =1: length(movelist)
            movelist{1,i}(:,:) = scale.*movelist{1,i}(:,:);%yesxyZoom
        end
        
    end
    if z_slices(length(z_slices()))>range/2 %zOut of print range(zThe scope ofxyHalf the range)
        z_scale = range/2/z_slices(length(z_slices()));%zScale of
        z_slices = z_slices * z_scale;%yesZZoom
    end
end