function [] = AAOT_TCO_TH(CPC, tchamber, pressure, ip, handles, skipWait)

%CPC - Presure chamber GPIB object
%tchamber - Temp chamber GPIB object
% pressure - pressure to be set for this test
% ip - ip address for the device
% handles - Global GUI object

% This test will set a constant pressure (defult 100kPa) and then ramp the
% Temperature from 5 degress to 65 degress, and back down to 5 degress
% However, there is an interval where the device needs to settle at the peak
% conditions. default is 3600s, 1 hour.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializing all the files needed for the test
FileInit('AAOT_TCO_TH_UP.csv');
FileInit('AAOT_TCO_TH_DOWN.csv');
FileInit('AAOT_TCO_TH_ref.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%LINEARITY TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles.metricdata.time = SetPressure(CPC, tchamber, pressure, handles);

handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles, 'AAOT_TCO_TH_ref.csv');

if skipWait == 0
    handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
end

dutobj = RT_init(ip);
pause(1);
RT_log(dutobj);
pause(1);

RT_startlog(dutobj);
handles.metricdata.time = SetTemp(CPC, tchamber, 65, handles,'AAOT_TCO_TH_ref.csv' );
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, 'AAOT_TCO_TH_UP.csv'); % technically do not need a return value, but it is useful
pause(1)


RT_startlog(dutobj);
handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles,'AAOT_TCO_TH_ref.csv');
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, 'AAOT_TCO_TH_DOWN.csv');




  