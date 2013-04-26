function [time] = AAOT_nolog(CPC, tchamber, pressure, ip, handles, skipWait)


handles.metricdata.time = SetPressure(CPC, tchamber, 70, handles);
for t = 5:5:65

    handles.metricdata.time = SetTemp(CPC, tchamber, t, handles);
    if skipWait == 0
        handles.metricdata.time = plotnpause(2400,10, CPC, tchamber, handles);
    end
    skipWait = 0;
    
    

	for p = 70:5:125
		handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
		handles.metricdata.time = plotnpause(10,1, CPC, tchamber, handles);

	end

    
end

time = handles.metricdata.time;

PowerOff(tchamber);
