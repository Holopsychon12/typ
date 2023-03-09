function [movelist_all,z_slices] = slice_stl_create_path(triangles,slice_height)
%%%
%yesstl3D data slicing
%triangles：Triangle data
%ax：Rotation axis
%slice_height：Storey height

%movelist_all：Of each layerxycoordinate
%z_slices：Floor height list
%%%
min_z = min([triangles(:,3); triangles(:,6);triangles(:,9)])-1e-5;
max_z = max([triangles(:,3); triangles(:,6);triangles(:,9)])+1e-5;

z_slices = min_z: slice_height :max_z;%Floor height data

if length(z_slices) < 10 %The number of floors is less than10Layer making10layer
    slice_height = (max_z - min_z)/10;%Storey height
    z_slices = min_z: slice_height :max_z;%Floor height data
end
movelist_all = {};%Initialize layer data
triangles_new = [triangles(:,1:12),...
                 min(triangles(:,[3 6 9]),[],2), ...
                 max(triangles(:,[3 6 9]),[],2)];

%find intersecting triangles%

slices = z_slices;
z_triangles = zeros(size(z_slices,2),4000);%Each layer4000Elements
z_triangles_size=zeros(size(z_slices,2),1);%Layer data
for i = 1:size(triangles_new,1) %Process each line      
    node = triangles_new(i,13);%xdata
    high= size(slices,2);%Number of layers
    low = 1;%first floor
    not_match = true;
    include1 = true;
    include2 = true;
    %Find the layer near the normal vector of the current layer in the middle
    while not_match
        mid = low + floor((high - low)/2);%Middle layer serial number
        if mid == 1 && slices(mid) >= node %The layer height of the first layer and the middle layer is greater than or equal to the normal vector
            check = 2;
        elseif slices(mid) <= node && mid == size(slices,2) %The height of the last layer and the middle layer is less than or equal to the normal vector
            check = 2;
        elseif slices(mid)>node && slices(mid-1)<node %The floor height of the near middle layer is less than the normal vector and the floor height of the middle layer is greater than the normal vector
            check = 0;
        elseif slices(mid)>node%The height of the middle layer is greater than the normal vector
            check = -1;
        elseif slices(mid) < node%The height of the middle layer is less than the normal vector
            check = 1;
        end
        %check
      if check == -1
          high = mid - 1;
      elseif check == 1
          low = mid + 1;
      elseif check == 0 %In the middle，matching
          node = mid;
          not_match = false;
      elseif high > low || check == 2 %First or last layer，matching
          include1 = false;
          not_match = false;
      end
    end
    z_low_index = mid;%zLow sequence number of

    %binary check high
    node = triangles_new(i,14);%yNormal vector
    
    high= size(slices,2);%Number of layers
    low = 1;%first floor
    
    %start_point = floor((max+min)/2);
    not_match = true;
    while not_match
        mid = low + floor((high - low)/2);%Middle layer serial number
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
        if mid == 1 && slices(1) <= node%The first layer and the layer height of the first layer is less than or equal to the normal vector
            check = 2;
        elseif mid == size(slices,2) && slices(mid) <=node%The height of the last layer and the middle layer is less than or equal to the normal vector
            check = 2;
        elseif slices(mid)>node && slices(mid-1)<node%The floor height of the near middle layer is less than the normal vector and the floor height of the middle layer is greater than the normal vector
            check = 0;
        elseif slices(mid)>node%The height of the middle layer is greater than the normal vector
            check = -1;
        elseif slices(mid) < node%The height of the middle layer is less than the normal vector
            check = 1;
        end

      if check == -1
          high = mid - 1;
      elseif check == 1
          low = mid + 1;
      elseif check == 0%In the middle，matching
          node = mid;
          not_match = false;
      elseif high > low || check == 2%First or last layer，matching
          include2 = false;
          not_match = false;
      end

    end
    z_high_index = mid;%zHigh sequence number of
    if z_high_index > z_low_index %xSerial number is normal
        for j = z_low_index:z_high_index-1 %fromzMinimum layer to maximum layer
            z_triangles_size(j) = z_triangles_size(j) + 1;%zSN layer data of
            z_triangles(j,z_triangles_size(j)) = i;%zData row number of the layer
        end
    end
end

%list formed
'list formed'
triangle_checklist2 = z_triangles;
for  k = 1:size(z_slices,2) %Treat each layer
    
    triangle_checklist = triangle_checklist2(k,1:z_triangles_size(k));%For the current layer，Form a checklist from the first layer to the current layer
    
    %Get line information
    [lines,linesize] = triangle_plane_intersection(triangles_new(triangle_checklist,:), z_slices(k));

    if linesize ~= 0 %wired
        %find all the points assign nodes and remove duplicates
        start_nodes = lines(1:linesize,1:2);%Start point coordinates
        end_nodes = lines(1:linesize,4:5);%End point coordinates
        nodes = [start_nodes; end_nodes];
        connectivity = [];
        tol_uniquetol = 1e-8;
        tol = 1e-8;

        nodes = uniquetol(nodes,tol_uniquetol,'ByRows',true);
        nodes = sortrows(nodes,[1 2]);

        [~, n1] = ismembertol(start_nodes, nodes, tol, 'ByRows',true);
        [~, n2] = ismembertol(end_nodes, nodes,tol,  'ByRows',true);
        conn1 = [n1 n2];
        %check for bad stl files. repeated edges, too thin surfaces, unclosed loops
        %enable if error encountered
        conn2 = [n2 n1];
        check = ismember(conn2,conn1,'rows');
        conn1(check == 1,:)=[];
        %end check

        G = graph(conn1(:,1),conn1(:,2));

        %create subgraph for connected components
        bins = conncomp(G);
            
        movelist =[];
        for i = 1: max(bins)
            startNode = find(bins==i, 1, 'first');
            %path =[];
            path = dfsearch(G, startNode);
            path = [path; path(1)];
            %list of x and y axes
            movelist1 = [nodes(path,1) nodes(path,2)];
            if ~isempty(path)
                if movelist1(1,1)>movelist1(2,1) || movelist1(1,2)>movelist1(2,2)
                    movelist1 = movelist1(end:-1:1,:);
                end
            end                    
            %connect to the first point
            movelist = [movelist;movelist1; [NaN NaN]];
            movelist_size = size(movelist,1);
            
        end
        movelist_all(k) = {movelist};
    end
end




