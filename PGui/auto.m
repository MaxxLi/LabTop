
function [time] = auto(CPC, tchamber, pressure, ip, handles, skipWait)


%CPC - Presure chamber GPIB object
%tchamber - Temp chamber GPIB object
% pressure - pressure to be set for this test
% ip - ip address for the device
% handles - Global GUI object


% This is a combination of the other 3 test portfolios
% It will run Linearity Test, TCO+TH, and AAOT Test in sequencial order

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializing all the files needed for the test
ModelNumber = get(handles.ModelNumber,'String');
pin = get(handles.DeviceName,'String');
FILE_LIN = [ModelNumber,'_',pin,'_Lin_PH.csv'];
FILE_LIN_ref = [ModelNumber,'_',pin,'_Lin_PH_ref.csv'];
FILE_TCO = [ModelNumber,'_',pin,'_TCO_TH.csv'];
FILE_TCO_ref = [ModelNumber,'_',pin,'_TCO_TH_ref.csv'];
FILE_AAOT = [ModelNumber,'_',pin,'_AAOT.csv'];
FILE_AAOT_ref = [ModelNumber,'_',pin,'_AAOT_ref.csv'];

FileInit(FILE_LIN);
FileInit(FILE_LIN_ref);
FileInit('scrap.csv');
FileInit(FILE_TCO);
FileInit(FILE_TCO_ref);
FileInit(FILE_AAOT_ref);
FileInit(FILE_AAOT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%LINEARITY TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting to the Test initial conditions (25 degrees) (70 kPa)

disp(['Setting Temperature to ', '25', ' degrees...']);
handles.metricdata.time = SetTemp(CPC, tchamber, 25, handles,'scrap.csv');
handles.metricdata.time = SetPressure(CPC, tchamber, 70, handles);
if skipWait == 0
       handles.metricdata.time = plotnpause(3600,10,CPC,tchamber,handles);
end

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
    RT_StartLog(dutobj);
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
    RT_StartLog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(0,presID,FILE_LIN);
end


pause(1);
RT_stoplog(dutobj, 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AAOT+TCO+TH%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


FileInit('scrap.csv'); %reinit because the scrap file may be too big

handles.metricdata.time = SetPressure(CPC, tchamber, pressure, handles);

handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles, 'scrap.csv');
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);


dutobj = RT_init(ip);
pause(1);
RT_log(dutobj);
pause(1);

RT_StartLog(dutobj);
handles.metricdata.time = SetTemp(CPC, tchamber, 65, handles,FILE_TCO_ref );
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, FILE_TCO);
pause(1)


RT_StartLog(dutobj);
handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles,FILE_TCO_ref);
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, FILE_TCO);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AAOT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause(2);



refLog = zeros(1,4);    
tempID = 0;
handles.metricdata.time = SetPressure(CPC, tchamber, 70, handles);
for t = 5:5:65
    tempID = tempID + 1;
    handles.metricdata.time = SetTemp(CPC, tchamber, t, handles,'scrap.csv');
    handles.metricdata.time = plotnpause(2400,10, CPC, tchamber, handles);
    
    presID = 0;
	
	for p = 70:5:125
		presID = presID + 1;
		handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
		RT_StartLog(dutobj);
		handles.metricdata.time = plotnpause(10,1, CPC, tchamber, handles);
		RT_stoplog(dutobj, 1);
		values = RT_dataparse(tempID,presID,FILE_AAOT);
		
		refLog(1,1) = GetPressure(CPC);
		refLog(1,2) = GetTemp(tchamber);
		refLog(1,3) = tempID;
		refLog(1,4) = presID;
		dlmwrite(FILE_AAOT_ref, refLog , '-append');		

	end
	pause(0.5);
    

    
end

%handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles,'scrap.csv');
time = handles.metricdata.time;
pause(1);
RT_stoplog(dutobj, 2); 
PowerOff(tchamber);

dirname = [ModelNumber,'_',pin,'_',date];
mkdir(dirname);
copyfile(FILE_LIN, dirname);
copyfile(FILE_LIN_ref, dirname);
copyfile(FILE_TCO, dirname);
copyfile(FILE_TCO_ref, dirname);
copyfile(FILE_AAOT_ref, dirname);
copyfile(FILE_AAOT, dirname);

  