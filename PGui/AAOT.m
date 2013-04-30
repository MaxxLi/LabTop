function [time] = AAOT(CPC, tchamber, ip, handles, skipWait)
%CPC - Presure chamber GPIB object
%tchamber - Temp chamber GPIB object
% ip - ip address for the device
% handles - Global GUI object
% This test will because ramping temperature from 5 to 65 degress with 5 degree
% steps. At each step it will ramp the temperature from 70 to 125 kPa in 5 kPa
% steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializing all the files needed for the test
ModelNumber = get(handles.ModelNumber,'String');
pin = get(handles.DeviceName,'String');

FILE_AAOT = [ModelNumber,'_',pin,'_AAOT.csv'];
FILE_AAOT_ref = [ModelNumber,'_',pin,'_AAOT_ref.csv'];
FileInit(FILE_AAOT_ref);
FileInit(FILE_AAOT);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializing RealTerm object
dutobj = RT_init(ip);
RT_log(dutobj);
refLog = zeros(1,4);    
tempID = 0;
handles.metricdata.time = SetPressure(CPC, tchamber, 70, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t = 5:5:65
    tempID = tempID + 1;
    handles.metricdata.time = SetTemp(CPC, tchamber, t, handles);
    if skipWait == 0
        handles.metricdata.time = plotnpause(2400,10, CPC, tchamber, handles);
    end
    skipWait = 0;
    
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

time = handles.metricdata.time;
pause(1);
RT_stoplog(dutobj, 2);
PowerOff(tchamber);
skipWait = 1;



