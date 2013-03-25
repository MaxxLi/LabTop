%This function will begin the sensor data logging from a BB10/QNX device
%and start capturing to a text file
function [] = RT_log( actxobject )
QNXrealterm = actxobject;
%Commans to log (could us unit_test_api)
PutString(QNXrealterm, ['sensor pressure' char(13)]);
pause(0.5)
QNXrealterm.CaptureFile ='C:\Matlab\PGUI\BB10_pres.txt';
% invoke(QNXrealterm, 'startcapture');
end

