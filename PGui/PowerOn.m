function [  ] = PowerOn( tchamber )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    fprintf(tchamber, '01,POWER,ON \n')
    
    pause(5);


end

