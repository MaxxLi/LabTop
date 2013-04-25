function [] = MacroEnable(hObject, eventdata, handles)
switch get(hObject,'value')
    case 6
        set(handles.ManualMenu,'Enable','on');
        set(handles.txtConstPres,'Enable','on');
        set(handles.txtConstTemp,'Enable','off')
        set(handles.ManualMenu,'Value',1);
        
    otherwise
        set(handles.ManualMenu,'Enable','off');
        set(handles.txtConstPres,'Enable','off');
        set(handles.txtConstTemp,'Enable','off');
end