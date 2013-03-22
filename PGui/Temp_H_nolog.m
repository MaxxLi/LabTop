function [] = Temp_H_nolog (CPC, tchamber, pressure, ip, handles)

FileInit('BB10_Temp_H_UP.csv');
FileInit('BB10_Temp_H_UP_ref.csv');
FileInit('BB10_Temp_H_DOWN.csv');
FileInit('BB10_Temp_H_DOWN_ref.csv');

setPressure(CPC, tchamber, pressure, handles);

refLog = zeros(1,3);
tempID = 0;

for t = 5:5:65
    tempID = tempID + 1;
    setTemp(CPC, tchamber, t, handles);
    plotnpause(2400,10, CPC, tchamber, handles)
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = tempID;    
    dlmwrite('BB10_Temp_H_UP_ref.csv', refLog , '-append');
    
end


refLog = zeros(1,3);
tempID = 0;

for t = 65:5:5
    tempID = tempID + 1;
    setTemp(CPC, tchamber, t, handles);
    plotnpause(3600,10, CPC, tchamber, handles)
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = tempID;    
    dlmwrite('BB10_Temp_H_DOWN_ref.csv', refLog , '-append');
end
