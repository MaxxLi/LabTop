function [val] = RT_logparse(filename)

    try
        file = textread('checklog.txt', '%s', 'delimiter', '\r','whitespace', '');
    catch e
        errordlg('Error opening BB10_mag text file.');
        fclose all;
        clear all;
    end

    opsize = size(file);
    hdgcounter = 0;
    outputdata = zeros(opsize(1,1), 1);
    % finaloutput = zeros(opsize(1,1),9);
    for i=1:opsize(1,1)
        tmpstr = char(file(i,1));
        line = strsplit(tmpstr, ' ');
        outputdata(i,1)= str2double(line(1,4));
    end
    
    val = mean(outputdata);

end

