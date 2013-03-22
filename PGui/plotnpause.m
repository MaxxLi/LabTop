function [x] = plotnpause(time,interval,CPC,tchamber, handles)

for w = 0:interval:time
        holder = GetPressure(CPC);
        holdert = GetTemp(tchamber);
        set(handles.presText,'String',num2str(holder));
        set(handles.tempText,'String',num2str(holdert));
        set(handles.timeText,'String',num2str(handles.metricdata.time));
        plot(handles.PressureAxes,handles.metricdata.time,holder, 'r.'); 
        plot(handles.TempAxes, handles.metricdata.time, holdert, 'b.'); 
        
        pause(interval);
        handles.metricdata.time = handles.metricdata.time + interval;
end

x = handles.metricdata.time;
