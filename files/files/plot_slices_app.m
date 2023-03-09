function []= plot_slices_app(fig,movelist_all, z_slices,delay)
%%%
%Show sliced data
%fig：Pictures displayed
%movelist_all：xyCoordinates of layers
%z_slices：zcoordinate
%delay：Show pictures every
%%%
for i = 1: size(movelist_all,2) %All layers
    disp("layer")
    disp(i)
    mlst_all = movelist_all{i};%Current layer data
    if delay >0
        if ~isempty(mlst_all) %No empty data
            for j = 1:size(mlst_all,1)-1 %From the first point to the penultimate point
                %3D display of the current layerxyz
                plot3(fig,mlst_all(j:j+1,1),mlst_all(j:j+1,2),ones(2,1)*z_slices(i),'r')
                hold(fig,'on');%Keep the previous figure
                pause(delay) %Pause time
            end
        end
        
    else
        if ~isempty(mlst_all)
            plot3(fig,mlst_all(:,1),mlst_all(:,2),ones(size(mlst_all,1),1)*z_slices(i),'r')
            hold(fig,'on');
        end
    end
end
end