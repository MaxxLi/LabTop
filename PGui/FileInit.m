function [] = FileInit(Filename)
standby = Filename;
try
    fopen(standby);
catch e
    errordlg('Error creating ' + Filename);
    fclose all;
    clear all;
end
dlmwrite(Filename ,[0,0,0,0], ',');
