function [outputdata] = RT_dataparse(tempid, Filename)

try
    file = textread('BB10_pres.txt', '%s', 'delimiter', '\r','whitespace', '');
catch e
    errordlg('Error opening BB10_mag text file.');
    fclose all;
    clear all;
end
% try
%     fopen('BB10_mag.csv');
% catch e
%     errordlg('Error opening BB10_mag CSV file for plotting.');
%     fclose all;
%     clear all;
% end

opsize = size(file);
hdgcounter = 0;
outputdata = zeros(opsize(1,1), 3);
% finaloutput = zeros(opsize(1,1),9);
for i=1:opsize(1,1)
    tmpstr = char(file(i,1));
    line = strsplit(tmpstr, ' ');
    outputdata(i,1)= str2double(line(1,2));
    outputdata(i,2)= str2double(line(1,4));
    outputdata(i,3) = tempid;
end
dlmwrite(Filename, outputdata, '-append');
end

