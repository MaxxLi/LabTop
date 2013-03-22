%This function is used to init communication with a BB10/QNX device via USB
%using realterm activex server (only requires realterm installation), also disables sleepmode in device to prevent any
%interruptions.
function [QNXrealterm] = RT_init(ipaddress)
try
    QNXrealterm = actxserver ('realterm.realtermintf');
catch e
    e.message;
    close all;
    clear all
end

%Serial comm params
QNXrealterm.baud =57600;
QNXrealterm.CaptureEndUnits = 'Secs';
QNXrealterm.CaptureEnd = 1;
QNXrealterm.caption = 'Matlab Realterm Server';
QNXrealterm.displayas = 1;
QNXrealterm.windowstate = 0; %minimize the realterm window.
QNXrealterm.Port = ipaddress; %DUT has to be in devel mode
QNXrealterm.PortOpen = 1;
QNXrealterm.CaptureEnd = 0;
PutString(QNXrealterm, ['root' char(13)]);
pause(.1);
PutString(QNXrealterm, ['root' char(13)]);
pause(.1);
% PutString(QNXrealterm, ['cd ..' char(13)]);
% pause(.1);
% PutString(QNXrealterm, ['slay power_brain' char(13)]);
% pause(.1);
% PutString(QNXrealterm, ['cd accounts/devuser' char(13)]);
% pause(.1);
% PutString(QNXrealterm, ['echo backlightTimeout::never >> /pps/services/power/display' char(13)]);
% pause(.1);
% PutString(QNXrealterm, ['echo backlightTimeoutCharging::never >> /pps/services/power/display' char(13)]);
% pause(.1);
% PutString(QNXrealterm, ['echo sleepTimeout::never >> /pps/services/power/display' char(13)]);
% pause(.1);
% PutString(QNXrealterm, ['echo sleepTimeoutCharging::never >> /pps/services/power/display' char(13)]);
pause(1);
end

