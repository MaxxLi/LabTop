function tchamber  = InitT( tchamber_address )
    %Initializes the temperature chamber
    %Basically, initializes the gpib and creates and object
    
	try
    tchamber = gpib('ni',0,tchamber_address);
    pause(0.5);
    fopen(tchamber);
	catch e
		errordlg('Error initialiating the Temperature Chamber');
		fclose all;
		clear all;
	end
 
end

