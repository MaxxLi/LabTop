function [pressure] = Getpressure(CPC)
   

    %Gets the temperature reading from the chamber
    
    
   % a = zeros(1,30);
    for j = 1:30
       
        
        
    end
    
    fprintf(CPC, 'A?');
    pause(0.1);
    C_Pres = fscanf(CPC);
    pressure = str2num(C_Pres);
    

end

