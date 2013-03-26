function [] = FileInit(Filename)
try
    fopen(Filename);
catch e
    errordlg('Error creating ' + Filename);
    fclose all;
    clear all;
end
dlmwrite(Filename ,[0,0,0,0], ',');
