function triangles = read_binary_stl_file(filename)

%%%
%Read Binarystlfile
%filename：file location

%triangles：Triangle data
%%%    
    f = fopen(filename,'r');%Open File
    rd = fread(f,inf,'uint8=>uint8');%read file
    numTriangles = typecast(rd(81:84),'uint32');%obtainTrianglesnumber
    triangles = zeros(numTriangles,12);%StatementTrianglesdata 
    sh = reshape(rd(85:end),50,numTriangles);%holdTrianglesdata85:end，become50*Number of triangles
    tt = reshape(typecast(reshape(sh(1:48,1:numTriangles),1,48*numTriangles),'single'),...
        12,numTriangles)';%Extract triangle data。1-48Is raw data，By format(each4Column as one data)Merge into1-12column
    triangles(:,1:9) = tt(:,4:12);%Triangle data
    triangles(:,10:12) = tt(:,1:3);%Other data
    fclose(f);
end