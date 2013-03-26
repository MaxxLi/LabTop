function [] = AAOT_TCO_TH(CPC, tchamber, pressure, ip, handles)



FileInit('AAOT_TCO_TH.csv');
FileInit('AAOT_TCO_TH_ref.csv');

handles.metricdata.time = SetPressure(CPC, tchamber, pressure, handles);


refLog = zeros(1,3);

handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles);
handles.metricdata.time = plotnpause(2400,10, CPC, tchamber, handles);

dutobj = RT_init(ip);
RT_log(dutobj);
RT_startlog(dutobj);


handles.metricdata.time = SetTemp(CPC, tchamber, 65, handles);

for i= 0:600:7200
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = 0; 
    dlmwrite('AAOT_TCO_TH_ref.csv', refLog , '-append');
    handles.metricdata.time = plotnpause(600,10, CPC, tchamber, handles);
end

handles.metricdata.time = plotnpause(1200,10, CPC, tchamber, handles);
handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles);

for i= 0:600:9000
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = 0; 
    dlmwrite('AAOT_TCO_TH_ref.csv', refLog , '-append');
    handles.metricdata.time = plotnpause(600,10, CPC, tchamber, handles);
end


RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, 'AAOT_TCO_TH.csv');
pause(1);
RT_stoplog(dutobj, 2);
pause(1);
PowerOff(tchamber);

  