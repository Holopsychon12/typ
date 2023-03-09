function [movelistNew] = removeNaNData(movelist,dataType)
    %%%
    %Delete moving points containingNaNPoint of value of
    %movelist:Point data to be processed
    %dataType：Processing type，1：Remove theNandata 0：If a layer of data containsNanRemove the layer
    %movelistNew：removeNANPoint collection after value
    %%%

    if dataType == 1
        movelistNew = {};
    
        for i =1: length(movelist)
            if length(movelist{1,i}) >0 
                
                points = [];
                m = 1;
                for k = 1:length(movelist{1,i}(:,1))
                    if ~any(isnan(movelist{1,i}(k,:))) %xyCoordinates containNan
                        points(m,:) = movelist{1,i}(k,:);%Current pointxyData assignment
                        m = m + 1;
                    end
                end
                
                movelistNew(i) = {points};  %Of the current layerxydata
            end
        end
    else
        movelistNew = [];
        m = 1;
        for i =1: size(movelist,1)
            if ~any(isnan(movelist(i,:)))%The point coordinates of the current layer containNan
                movelistNew(m,:) = movelist(i,:);%Current layerxyData assignment
                m = m + 1; 
            end
        end 
    end
end