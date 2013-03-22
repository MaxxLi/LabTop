function [time] = SetPressure( CPC, tchamber, pressure, handles )


    
    fprintf(CPC, ['Setpt ',num2str(pressure)])   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PRESSURECHECK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	presArray = zeros(1,50);

	while(1)
			holder = GetPressure(CPC);
            holdert = GetTemp(tchamber);
            set(handles.presText,'String',num2str(holder));
            set(handles.tempText,'String',num2str(holdert));
            set(handles.timeText,'String',num2str(handles.metricdata.time));
            plot(handles.PressureAxes,handles.metricdata.time,holder, 'r.'); 
            plot(handles.TempAxes, handles.metricdata.time, holdert, 'b.'); 
            
            for i = 1:9
                presArray(i+1)= presArray(i);
            end
            presArray(1) = holdert;
            
			if ((abs( mean(presArray) - pressure)) <= 0.1)
				break;
            end
            
			pause(1);
            handles.metricdata.time = handles.metricdata.time + 1;
    end
    
    time = handles.metricdata.time;


end

