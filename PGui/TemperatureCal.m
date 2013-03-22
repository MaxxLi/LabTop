function [] = TemperatureCal(CPC,tchamber,handles)

FileInit('BB10_stepPres.csv');
FileInit('BB10_stepPres_ref.csv');


SetPressure(CPC, 100, handles);


refLog = zeros(1,3);
tempID = 0;

for t = 5:5:65
    tempID = tempID + 1;
    setTemp(tchamber, t, handles);
    pause(2400);
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = tempID;    
    dlmwrite('BB10_stepTemp_ref.csv', refLog , '-append');
    
    
end

     

Standby(tchamber);
PowerOff(tchamber);