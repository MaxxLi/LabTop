function [temp] = GetTemp( tchamber)
   

    %Gets the temperature reading from the chamber
    %a = zeros(1,10);
%     for i = 1:10
%         
%         a(1,i) = j(1);
%     end
    fprintf(tchamber, 'TEMP?');
    pause(0.2);
    j = fscanf(tchamber);
    j = str2num(j);
    temp = j(1);
end

