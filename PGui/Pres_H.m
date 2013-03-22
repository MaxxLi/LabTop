function [] = Pres_H(CPC, tchamber, temperature, ip, handles)

FileInit('BB10_Pres_H_UP.csv');
FileInit('BB10_Pres_H_UP_ref.csv');
FileInit('BB10_Pres_H_DOWN.csv');
FileInit('BB10_Pres_H_DOWN_ref.csv');

setTemp(CPC, tchamber, temperature, handles);

dutobj = RT_init(ip);
RT_log(dutobj);

refLog = zeros(1,3);
presID = 0;

for p = 85:1:115:
    presID = presID + 1;
	SetPressure(CPC,tchamber, p, handles);
	pause(3);	
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_Pres_H_UP_ref.csv', refLog , '-append');   
    pause(0.5);
    RT_startlog(dutobj);
    pause(10);
    RT_stoplog(dutobj, 1);
    values = RT_dataparse(tempID,'BB10_Pres_H_UP.csv');
end

pause(10)


refLog = zeros(1,3);
presID = 0;
for p = 115:1:85
    presID = presID + 1;
	SetPressure(CPC,tchamber, p, handles);
	pause(3);	
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_Pres_H_DOWN_ref.csv', refLog , '-append');   
    pause(0.5);
    RT_startlog(dutobj);
    pause(10);
    RT_stoplog(dutobj, 1);
    values = RT_dataparse(tempID,'BB10_Pres_H_DOWN.csv');
end


pause(1);
RT_stoplog(dutobj, 2); 