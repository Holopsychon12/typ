function [movelistNew] = removeNaNData(movelist)
    %%%
    %Delete moving points containingNaNValue of
    %movelist:Point data to be processed
    %movelistNew：removeNANPoint collection after value
    %%%
    movelistNew = {};

    for i =1: length(movelist)
        if length(movelist{1,i}) >0 
            
            points = [];
            m = 1;
            for k = 1:length(movelist{1,i}(:,1))
                if ~any(isnan(movelist{1,i}(k,:))) %xyCoordinates containNan
                    points(m,:) = movelist{1,i}(k,:);
                    m = m + 1;
                end
            end
            
            movelistNew(i) = {points};  
        end
    end
    
end