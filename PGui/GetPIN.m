function [pin] = GetPIN(ip,handles)

    obj = RT_init(ip);
    obj.CaptureFile ='C:\Matlab\PGUI\BB10_ID.txt';
    pause(0.5);
    RT_startlog(obj); 
    PutString(obj, ['cat /pps/system/nvram/deviceinfo | grep PIN:: | sed -e ''s/PIN::0x//g''' char(13)]);
    pause(0.5);
    RT_stoplog(obj,2);
    
    
try
    file = textread('BB10_ID.txt', '%s', 'delimiter', '\r','whitespace', '');
catch e
    errordlg('Error opening BB10_ID text file.');
    fclose all;
    clear all;
end
pin = char(file(3));

