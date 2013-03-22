function [time] = SetTemp( CPC, tchamber, settemp, handles )
    %Sets the temperature '01,TEMP,S ',num2str(settemp), ' \n'
    
    fprintf(tchamber, ['01,TEMP,S ',num2str(settemp), ' \n'])   
    fprintf(tchamber, '01,MODE, CONSTANT \n')
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TEMPCHECK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    temp = zeros(1,5);
	
	while(1)

		holder = GetPressure(CPC);
        holdert = GetTemp(tchamber);
        set(handles.presText,'String',num2str(holder));
        set(handles.tempText,'String',num2str(holdert));
        set(handles.timeText,'String',num2str(handles.metricdata.time));
        plot(handles.PressureAxes,handles.metricdata.time,holder, 'r.'); 
        plot(handles.TempAxes, handles.metricdata.time, holdert, 'b.'); 
        for i = 1:4
            temp(i+1)= temp(i);
        end
        temp(1) = holdert;
        
		if (((temp(1) >= settemp - 0.1) && (temp(1) <= settemp + 0.1))  && ((abs(temp(1)- temp(5)) < 0.2)))
			break;
		end
		pause(1);
        handles.metricdata.time = handles.metricdata.time + 1;
    end
    
    time = handles.metricdata.time;

end

