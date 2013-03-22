function [] = TempRamp_nolog(CPC, tchamber, pressure, ip, handles)

FileInit('BB10_TempRamp.csv');
FileInit('BB10_TempRamp_ref.csv');

handles.metricdata.time = SetPressure(CPC,tchamber, 100, handles);


%refLog = zeros(1,3);

handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles);
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);

%dutobj = RT _init(ip);
%RT_log(dutobj);
%RT_startlog(dutobj);


handles.metricdata.time = SetTemp(CPC, tchamber, 65, handles);
for i= 0:600:7200
    %refLog(1,1) = GetPressure(CPC);
    %refLog(1,2) = GetTemp(tchamber);
    %refLog(1,3) = 0; 
    %dlmwrite('BB10_TempRamp_ref.csv', refLog , '-append');
    handles.metricdata.time = plotnpause(600,10, CPC, tchamber, handles);
end
%RT_stoplog(dutobj, 1);
%pause(1);
%RT_stoplog(dutobj, 2);

%values = RT_dataparse(0, 'BB10_TempRamp_ref.csv');

%pause(1);
%RT_stoplog(dutobj, 2); 
  