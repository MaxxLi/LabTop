function CPC = InitP( CPC_address )
%Initializes the temperature chamber
%Basically, initializes the gpib and creates and object
    
	try
		CPC = gpib('ni',0,CPC_address);
		pause(0.5);
		fopen(CPC);
	catch e
		errordlg('Error initialiating the Pressure Chamber');
		fclose all;
		clear all;
	end 

end

