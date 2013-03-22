function [] = PresSweep_nolog (CPC, tchamber,temperature, ip, handles)

FileInit('BB10_stepPres.csv');
FileInit('BB10_stepPres_ref.csv');

setTemp(CPC, tchamber, temperature, handles);

presID = 0;
refLog = zeros(1,3);

for p = 85:1:115
    presID = presID + 1;
	SetPressure(CPC, tchamber, p, handles);
	pause(3);	
    refLog(1,1) = GetPressure(CPC);
    refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_stepPres_ref.csv', refLog , '-append');   
    
end
