function [] = Pres_H_nolog(CPC, tchamber, temperature, ip, handles)

FileInit('BB10_Pres_H_UP.csv');
FileInit('BB10_Pres_H_UP_ref.csv');
FileInit('BB10_Pres_H_DOWN.csv');
FileInit('BB10_Pres_H_DOWN_ref.csv');

setTemp(CPC, tchamber, temperature, handles);

refLog = zeros(1,3);
presID = 0;

for p = 85:1:115:
    presID = presID + 1;
	SetPressure(CPC, tchamber, p, handles);
	pause(3);	
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_Pres_H_UP_ref.csv', refLog , '-append');   
    
end




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
end