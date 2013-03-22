function [tchamber CPC] = EquipInit(GPIB_Pres,GPIB_Temp)

try
    tchamber = gpib('ni',0,1);
    pause(0.5);
    fopen(tchamber);
catch e
    errordlg('Error initialiating the Temperature Chamber');
    fclose all;
    clear all;
end

PowerOn(tchamber); %Turns on temperature chamber
Standby(tchamber);

try
    CPC = gpib('ni',0,2);
    pause(0.5);
    fopen(CPC);
catch e
    errordlg('Error initialiating the Pressure Chamber');
    fclose all;
    clear all;
end 
    
