function [outputdata] = RT_dataparse(tempid,presid, Filename)

try
    file = textread('BB10_pres.txt', '%s', 'delimiter', '\r','whitespace', '');
catch e
    errordlg('Error opening BB10_mag text file.');
    fclose all;
    clear all;
end

opsize = size(file);
hdgcounter = 0;
outputdata = zeros(opsize(1,1), 4);
for i=1:opsize(1,1)
    tmpstr = char(file(i,1));
    line = strsplit(tmpstr, ' ');
    outputdata(i,1)= (str2double(line(1,2)))/1000;
    outputdata(i,2)= str2double(line(1,4));
    outputdata(i,3) = tempid;
	outputdata(i,4) = presid;
end
dlmwrite(Filename, outputdata, '-append');
end

