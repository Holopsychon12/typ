
function triangles = read_ascii_stl(filename, header_lines_num)
%%%
%read ascii stl Format file
%filename：file location
%header_lines_num：Number of file header lines

%triangles：Triangle data
%%%

    fid = fopen(filename);%Open File
    for i = 1: header_lines_num %Read all rows
    tline = fgetl(fid);%Get the current line of the file
    end
    i = 1;
    tline = fgetl(fid);%Get the current line of the file
    z1 = {'proceed'};
    %facet normal -5.000000e-01 -2.775558e-15 8.660254e-01
    %outer loop
    %  vertex   1.665335e-14 -1.847521e+01 3.695042e+01
    %  vertex   -1.600000e+01 -1.847521e+01 2.771281e+01
    %  vertex   1.776357e-14 -1.867521e+01 3.695042e+01
    %endloop
    %endfacet
    while ~strcmp(z1{1}, 'endsolid') %Read until the end of the file：endsolid
        normals = strsplit(tline,' ');%Space split data items
        triangles(i,10:12) = str2double(normals(end-2:end));%Normal vector
        tline = fgetl(fid);%outer loop Do not handle
        tline = fgetl(fid);%vertexhandle
        vertex1 = strsplit(tline, ' ');
        triangles(i,1:3) = str2double(vertex1(end-2:end));
        tline = fgetl(fid);
        vertex2 = strsplit(tline, ' ');
        triangles(i,4:6) = str2double(vertex2(end-2:end));
        tline = fgetl(fid);
        vertex3 = strsplit(tline, ' ');
        triangles(i,7:9) = str2double(vertex3(end-2:end));
        tline = fgetl(fid);%endloop Do not handle
        tline = fgetl(fid);%endfacet Do not handle
        i = i + 1;%Next data
        tline = fgetl(fid);
        z1 = strsplit(tline, ' ');        
    end
    fclose(fid);
end
%fclose(fid)