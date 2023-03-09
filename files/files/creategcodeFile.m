function [] = creategcodeFile(fileName,movelist,z_slices)
%%%
%establishgcodefile
%fileName:gcodefile name
%movelist：xyCoordinates of layers
%z_slices：zcoordinate
%%%
gcodefileName = strcat(fileName(1:length(fileName)-4),"new.gcode");%gcodefile name
fid=fopen(gcodefileName,'wt'); %Create a file as a write
%initialization
gcodeStart = {';Start Gcode',...
'M109 S208.000000',...
';M190 S70 ;Uncomment to add your own bed temperature line',...
';M109 S208 ;Uncomment to add your own temperature line',...
'G21        ;metric values',...
'G90        ;absolute positioning',...
'M82        ;set extruder to absolute mode',...
'M107       ;start with the fan off',...
'G28 X0 Y0  ;move X/Y to min endstops',...
'G28 Z0     ;move Z to min endstops',...
'G29        ;Run the auto bed leveling',...
'G1 Z0.0 F4200 ;move the platform down 15mm',...
'G92 E0                  ;zero the extruded length',...
'G1 F200 E3              ;extrude 3mm of feed stock',...
'G92 E0                  ;zero the extruded length again',...
'G1 F4200',...
strcat(';Layer count: ',num2str(length(movelist)))};

%Write hierarchical content
layerList = {};
G0F = '4200';G1F = '1200';%Extrusion speed
x = 0;y = 0;%Start point
rin = 17.5;rout = 0.4;%Diameter of extrusion material，Extruded wire diameter
for curlayerIndex = 1:length(movelist)
    curMoveInfo = {strcat(';LAYER:',num2str(curlayerIndex)),'M107'};%Layer information
    mlst_all = movelist{curlayerIndex};%Point list of current layer
    z = z_slices(curlayerIndex);%Current layerzcoordinate
    gindex = 2;
    if ~isempty(mlst_all) %All left and right sides of the current layer are not empty
        for j = 1:size(mlst_all,1)-1 %From the first point to the penultimate point
            gindex = gindex + 1;%Next point serial number
            x0 = x; y0 = y;%Current coordinate point
            x = mlst_all(j,1); y = mlst_all(j,2); %Next coordinate point
            if ~isnan(x) && ~isnan(y) && ~isnan(x0) && ~isnan(y0) %The values of coordinate points are notnan
            if j == 1 %First point
                curMoveInfo{gindex} = {strcat('G0 F',G0F,32, 'X',num2str(x), ...
                    32, 'Y',num2str(y), 32, 'Z',num2str(z))};%Information isx,y,z，No speed
                gindex = gindex + 1;
            end
            Evalue = sqrt((x-x0)^2+(y-y0)^2)*rout^2/rin^2*10000;%Wire length of incoming material
            curMoveInfo{gindex} = {strcat('G1 F',G1F,32, 'X',num2str(x), ...
                    32, 'Y',num2str(y),32,'E',num2str(Evalue))};%Information isx,y，With speed
            end
            
        end
    end 
    layerList{curlayerIndex} = curMoveInfo;%Print content of current layer
end
%Contents at the end of the file
endgcode = {...
';End GCode',...
'M104 S0                     ;extruder heater off',...
'M140 S0                     ;heated bed heater off (if you have it)',...
'G91                                    ;relative positioning',...
'G1 E-1 F300                            ;retract the filament a bit before lifting the nozzle, to release some of the pressure',...
'G1 Z+0.5 E-5 X-20 Y-20 F4200 ;move Z up a bit and retract filament even more',...
'G28 X0 Y0                              ;move X/Y to min endstops, so the head is out of the way',...
'M84                         ;steppers off',...
'G90                         ;absolute positioning'
};
%Write content to file

lineFormatSingle ="%s\r\n";
for i = 1:length(gcodeStart) %gcodeDocument preparation
    fprintf(fid,lineFormatSingle,string(gcodeStart(i)));
end
%
for i = 1:length(layerList) %gcodeDocument print content section
    mlst_all = layerList{i};
    for j = 1:length(mlst_all)
        try
        fprintf(fid,lineFormatSingle,string(mlst_all(j)));
        catch
            
        end
    end
end

for i = 1:length(endgcode)%gcodeEnd of file
    fprintf(fid,lineFormatSingle,string(endgcode(i)));
end
fclose(fid);%Close File