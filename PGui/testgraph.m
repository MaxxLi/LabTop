function [] = testgraph (handles)
for i = 1:2:10
    plot(handles.PressureAxes,i,i^2,'k.');
    plot(handles.TempAxes,i,i^2,'k.');
    pause(1);
end