Function [] = VarTemp (CPC, tchamber, pressure, ip, handles)

FileInit('BB10_stepTemp.csv');
FileInit('BB10_stepTemp_ref.csv');

setPressure = (CPC, pressure, handles);

dutobj = RT_init(ip);
RT_log(dutobj);

refLog = zeros(1,3);
tempID = 0;

for t = 5:5:65
    tempID = tempID + 1;
    setTemp(tchamber, t, handles);
    pause(900);
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = tempID;    
    dlmwrite('BB10_stepTemp_ref.csv', refLog , '-append');

    pause(0.5);
    RT_startlog(dutobj);
    pause(10);
    RT_stoplog(dutobj, 1);
    values = RT_dataparse(tempID,'BB10_stepTemp.csv');

    
    
end


pause(1);
RT_stoplog(dutobj, 2); 
  