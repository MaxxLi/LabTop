function [] = getIP()

[~,input] = system('ipconfig /all');
delim = input(1);
counter = strfind(input,'DHCP Server . . . . . . . . . . . : 169.254.');
counter = counter + 36;
A = input(counter);
counter = counter +1;
while (input(counter) ~= delim)
   A = [A,input(counter)];
   counter = counter +1 ;
end

disp(A);




end

