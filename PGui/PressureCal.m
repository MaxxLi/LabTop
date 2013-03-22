function [] = PressureCal()

FileInit('BB10_stepPres.csv');
FileInit('BB10_stepPres_ref.csv');

%setTemp(tchamber, temperature, handles);

%dutobj = RT_init(ip);
%RT_log(dutobj);
% 
% try
%     CPC = gpib('ni',0,2);
%     pause(0.5);
%     fopen(CPC);
% catch e
%     errordlg('Error initialiating the Pressure Chamber');
%     fclose all;
%     clear all;
% end 
%     




refLog = zeros(1,3);
presID = 0;

for p = 85:5:115
    presID = presID + 1;
	SetPressure(CPC, p, handles);
	pause(3);	
    refLog(1,1) = GetPressure(CPC);
    %refLog(1,2) = GetTemp(tchamber);
    refLog(1,3) = presID;    
    dlmwrite('BB10_stepPres_ref.csv', refLog , '-append');   
    pause(0.5);
    %RT_startlog(dutobj);
    %pause(10);
    %RT_stoplog(dutobj, 1);
    %values = RT_dataparse(tempID,'BB10_stepPres.csv');
end


pause(1);
RT_stoplog(dutobj, 2); 
  