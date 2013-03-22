function [] = TempSweep_nolog (CPC, tchamber, pressure, handles)

FileInit('BB10_stepTemp.csv');
FileInit('BB10_stepTemp_ref.csv');

setPressure(CPC, pressure,100, handles);

refLog = zeros(1,3);
tempID = 0;

for t = 5:5:65
    tempID = tempID + 1;
    setTemp(CPC, tchamber, t, handles);
    plotnpause(2400,10, CPC, tchamber, handles)
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = tempID;
    dlmwrite('BB10_stepTemp_ref.csv', refLog , '-append');

    pause(0.5); 
    
end
