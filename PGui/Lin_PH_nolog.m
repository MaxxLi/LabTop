function [] = Lin_PH_nolog(CPC, tchamber,temperature, ip, handles)

% FileInit('BB10_Lin_PH.csv');
% FileInit('BB10_Lin_PH_ref.csv');

handles.metricdata.time = SetTemp(CPC, tchamber, temperature, handles);

% dutobj = RT_init(ip);
% RT_log(dutobj);

% refLog = zeros(1,3);
% presID = 0;

for p = 70:1:120
    %presID = presID + 1;
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
    % refLog(1,1) = GetPressure(CPC);
    % refLog(1,2) = GetTemp(tchamber);
    % refLog(1,3) = presID;    
    % dlmwrite('BB10_Lin_PH_ref.csv', refLog , '-append');   
    % pause(0.5);
    % RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    % RT_stoplog(dutobj, 1);
    % values = RT_dataparse(tempID,'BB10_Lin_PH.csv');
end
for p = 120:-1:70
    %presID = presID + 1;
	handles.metricdata.time = SetPressure(CPC, tchamber, p, handles);
    % refLog(1,1) = GetPressure(CPC);
    % refLog(1,2) = GetTemp(tchamber);
    % refLog(1,3) = presID;    
    % dlmwrite('BB10_Lin_PH_ref.csv', refLog , '-append');   
    % pause(0.5);
    % RT_startlog(dutobj);
    handles.metricdata.time = plotnpause(5,1, CPC, tchamber, handles);
    % RT_stoplog(dutobj, 1);
    % values = RT_dataparse(tempID,'BB10_Lin_PH.csv');
end

% pause(1);
% RT_stoplog(dutobj, 2);
PowerOff(tchamber);
