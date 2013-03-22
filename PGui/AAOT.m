function [time] = AAOT(CPC, tchamber, pressure, ip, handles)

FileInit('BB10_AAOT_ref.csv');
FileInit('BB10_AAOT.csv');

dutobj = RT_init(ip);
RT_log(dutobj);

refLog = zeros(1,3);    
tempID = 0;
handles.metricdata.time = SetPressure(CPC, tchamber, 70, handles);
for t = 5:5:65
    tempID = tempID + 1;
    handles.metricdata.time = SetTemp(CPC, tchamber, t, handles);
    handles.metricdata.time = plotnpause(2400,10, CPC, tchamber, handles);
    
    
	
	for p = 70:5:125
		handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
		RT_startlog(dutobj);
		handles.metricdata.time = plotnpause(10,1, CPC, tchamber, handles);
		RT_stoplog(dutobj, 1);
		values = RT_dataparse(tempID,'BB10_AAOT.csv');
		
		refLog(1,1) = GetPressure(CPC);
		refLog(1,2) = GetTemp(tchamber);
		refLog(1,3) = tempID;
		dlmwrite('BB10_AAOT_ref.csv', refLog , '-append');		

	end
	pause(0.5);
    

    
end

time = handles.metricdata.time;
pause(1);
RT_stoplog(dutobj, 2); 
PowerOff(tchamber);
