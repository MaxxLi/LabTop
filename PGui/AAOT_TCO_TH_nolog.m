function [] = AAOT_TCO_TH_nolog(CPC, tchamber, pressure, ip, handles, skipWait)

handles.metricdata.time = SetPressure(CPC, tchamber, 100, handles);

handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles);

if skipWait == 0
    handles.metricdata.time = plotnpause(2400,10, CPC, tchamber, handles);
end


handles.metricdata.time = SetTemp(CPC, tchamber, 65, handles);


handles.metricdata.time = plotnpause(4800,10, CPC, tchamber, handles);


handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles);

handles.metricdata.time = plotnpause(7200,10, CPC, tchamber, handles);

pause(1);
PowerOff(tchamber);

  