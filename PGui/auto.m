function [] = auto(CPC, tchamber, pressure, ip, handles)

% This is a combination of the other 3 test portfolios
% It will run Linearity Test, TCO+TH, and AAOT Test in sequencial order

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initializing all the files needed for the test

FileInit('BB10_Lin_PH.csv');
FileInit('BB10_Lin_PH_ref.csv');
FileInit('scrap.csv');
FileInit('AAOT_TCO_TH.csv');
FileInit('AAOT_TCO_TH_ref.csv');
FileInit('BB10_AAOT_ref.csv');
FileInit('BB10_AAOT.csv');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%LINEARITY TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting to the Test initial conditions (25 degrees) (70 kPa)

disp(['Setting Temperature to ', 25, ' degrees...']);
handles.metricdata.time = SetTemp(CPC, tchamber, 25, handles,'scrap.csv');
handles.metricdata.time = SetPressure(CPC, tchamber, 70, handles);
plotnpause(7200,10,CPC,tchamber,handles);

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
    dlmwrite('BB10_Lin_PH_ref.csv', refLog , '-append');   
    pause(0.5);
	disp('Data Streaming...');
    RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(1,presID,'BB10_Lin_PH.csv');
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
    dlmwrite('BB10_Lin_PH_ref.csv', refLog , '-append');   
    pause(0.5);
	disp('Data Streaming...');
    RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    RT_stoplog(dutobj, 1);
	disp('Streaming Stopped.');
    values = RT_dataparse(0,presID,'BB10_Lin_PH.csv');
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

RT_startlog(dutobj);
handles.metricdata.time = SetTemp(CPC, tchamber, 65, handles,'AAOT_TCO_TH_ref.csv' );
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, 'AAOT_TCO_TH.csv');
pause(1)


RT_startlog(dutobj);
handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles,'AAOT_TCO_TH_ref.csv');
handles.metricdata.time = plotnpause(3600,10, CPC, tchamber, handles);
RT_stoplog(dutobj, 1);
values = RT_dataparse(0,0, 'AAOT_TCO_TH.csv');


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
		RT_startlog(dutobj);
		handles.metricdata.time = plotnpause(10,1, CPC, tchamber, handles);
		RT_stoplog(dutobj, 1);
		values = RT_dataparse(tempID,presID,'BB10_AAOT.csv');
		
		refLog(1,1) = GetPressure(CPC);
		refLog(1,2) = GetTemp(tchamber);
		refLog(1,3) = tempID;
		reflog(1,4) = presID;
		dlmwrite('BB10_AAOT_ref.csv', refLog , '-append');		

	end
	pause(0.5);
    

    
end

handles.metricdata.time = SetTemp(CPC, tchamber, 5, handles,'scrap.csv');
time = handles.metricdata.time;
pause(1);
RT_stoplog(dutobj, 2); 

  