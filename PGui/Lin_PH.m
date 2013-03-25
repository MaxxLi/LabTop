function [] = Lin_PH(CPC, tchamber,temperature, ip, handles)

FileInit('BB10_Lin_PH.csv');
FileInit('BB10_Lin_PH_ref.csv');

disp(['Setting Temperature to ', num2str(temperature), ' degrees...']);
handles.metricdata.time = SetTemp(CPC, tchamber, temperature, handles);

dutobj = RT_init(ip);
RT_log(dutobj);

refLog = zeros(1,3);
presID = 0;
disp('Beginning Pressure Steps.');
for p = 70:1:120
    %presID = presID + 1;
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
	disp(['Current pressure at ',num2str(p)]);
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_Lin_PH_ref.csv', refLog , '-append');   
    pause(0.5);
	disp('Data Streaming...');
    RT_StartLog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(presID,'BB10_Lin_PH.csv');
end


disp('Beginning Stepping Down...');
for p = 120:-1:70
    %presID = presID + 1;
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
	disp(['Current pressure at ',num2str(p)]);
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_Lin_PH_ref.csv', refLog , '-append');   
    pause(0.5);
	disp('Data Streaming...');
    RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(presID,'BB10_Lin_PH.csv');
end


pause(1);
RT_stoplog(dutobj, 2);
PowerOff(tchamber);
