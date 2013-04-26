function [] = Lin_PH(CPC, tchamber,temperature, ip, handles, skipWait)


disp(['Setting Temperature to ', num2str(temperature), ' degrees...']);
handles.metricdata.time = SetTemp(CPC, tchamber, temperature, handles,'scrap.csv');
if skipWait == 0
    handles.metricdata.time = plotnpause(3600,10,CPC,tchamber,handles);
end


disp('Beginning Pressure Steps.');
for p = 70:1:120
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
	disp(['Current pressure at ',num2str(p)]);

    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
end


disp('Beginning Stepping Down...');
for p = 120:-1:70
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
	disp(['Current pressure at ',num2str(p)]);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
end


pause(1);
RT_stoplog(dutobj, 2);
PowerOff(tchamber);
