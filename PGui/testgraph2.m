function [] = testgraph2 (handles)
% axes(handles.PressureAxes);
% hold on;
% axes(handles.TempAxes);
% hold on;
for i = 1:3:10
    plot(handles.PressureAxes,i,i,'r.');
    plot(handles.TempAxes,i,i,'r.');
    pause(1);
end