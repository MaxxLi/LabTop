function [] = MacroEnable(hObject, eventdata, handles)
switch get(hObject,'value')
    case 6
        set(handles.txtConstPres,'Enable','on');
        set(handles.txtConstTemp,'Enable','on');
        if (strcmp(get(handles.initButton,'Enable'),'off'))
            set(handles.ManualButton,'Enable','on');
        end
    otherwise
        set(handles.ManualButton,'Enable','off');
        set(handles.txtConstPres,'Enable','off');
        set(handles.txtConstTemp,'Enable','off');
end