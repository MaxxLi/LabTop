function [] = ManualEnable(hObject, eventdata, handles)
switch get(hObject,'value')
    
    case 1
        set(handles.txtConstPres,'Enable','on');
        set(handles.txtConstTemp,'Enable','off');
    case 2
        set(handles.txtConstPres,'Enable','on');
        set(handles.txtConstTemp,'Enable','off');       
    case 3
        set(handles.txtConstPres,'Enable','off');
        set(handles.txtConstTemp,'Enable','on');
    case 4
        set(handles.txtConstPres,'Enable','off');
        set(handles.txtConstTemp,'Enable','on');
end

end