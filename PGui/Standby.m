function [ ] = Standby( tchamber )
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    
    fprintf(tchamber, '01,MODE, STANDBY \n')
    pause(5)

end

