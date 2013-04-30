function [] = Lin_PH(CPC, tchamber,temperature, ip, handles, skipWait)


ModelNumber = get(handles.ModelNumber,'String');
pin = get(handles.DeviceName,'String');
FILE_LIN = [ModelNumber,'_',pin,'_Lin_PH.csv'];
FILE_LIN_ref = [ModelNumber,'_',pin,'_Lin_PH_ref.csv'];


FileInit(FILE_LIN);
FileInit(FILE_LIN_ref);
FileInit('scrap.csv');



disp(['Setting Temperature to ', num2str(temperature), ' degrees...']);
handles.metricdata.time = SetTemp(CPC, tchamber, temperature, handles,'scrap.csv');
%DUT wait time
if skipWait == 0
    handles.metricdata.time = plotnpause(3600,10,CPC,tchamber,handles);
end
PowerOff(tchamber);

dutobj = RT_init(ip);
RT_log(dutobj);

refLog = zeros(1,4);
presID = 0;
disp('Beginning Pressure Steps.');
for p = 70:1:120
    presID = presID + 1;
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
	disp(['Current pressure at ',num2str(p)]);
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;
	refLog(1,4) = 1;
    dlmwrite(FILE_LIN_ref, refLog , '-append');   
    pause(0.5);
	disp('Data Streaming...');
    RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(1,presID,FILE_LIN);
end


disp('Beginning Stepping Down...');
for p = 120:-1:70
    presID = presID + 1;
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
	disp(['Current pressure at ',num2str(p)]);
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID; 
	refLog(1,4) = 0;	
    dlmwrite(FILE_LIN_ref, refLog , '-append');   
    pause(0.5);
	disp('Data Streaming...');
    RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(0,presID,FILE_LIN);
end


pause(1);
RT_stoplog(dutobj, 2);
PowerOff(tchamber);

