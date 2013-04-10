function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 22-Mar-2013 12:33:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;


handles.metricdata.temp = 0;
handles.metricdata.pressure = 0;
handles.metricdata.Manual = 0;
handles.metricdata.GPIB_CPC = 2;
handles.metricdata.GPIB_tchamber= 1;
handles.metricdata.ip= 0;
handles.metricdata.isLog= 0;
handles.metricdata.time= 0;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in MacroMenu.
function MacroMenu_Callback(hObject, eventdata, handles)
% hObject    handle to MacroMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MacroMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MacroMenu
MacroEnable(hObject, eventdata, handles);





   
        
        

function GPIB_Temp_Callback(hObject, eventdata, handles)
% hObject    handle to GPIB_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GPIB_Temp as text
%        str2double(get(hObject,'String')) returns contents of GPIB_Temp as a double
if (str_isnumeric(get(hObject,'String')))
    handles.metricdata.GPIB_tchamber = str2double(get(hObject,'String'));
else
    msgbox('Please input a number','Error','error');
    
end

    




function GPIB_CPC_Callback(hObject, eventdata, handles)
% hObject    handle to GPIB_CPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GPIB_CPC as text
%        str2double(get(hObject,'String')) returns contents of GPIB_CPC as a double
if (str_isnumeric(get(hObject,'String')))
    handles.metricdata.GPIB_CPC = str2double(get(hObject,'String'));
else
    msgbox('Please input a number','Error','error');
    
end



% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.metricdata.time = plotnpause(5,1,CPC,tchamber, handles);
%handles.metricdata.time = plotnpause(10,1,CPC,tchamber, handles);
global tchamber;
global CPC;



ip = get(handles.DeviceIP, 'String');

if (get(handles.ckLog , 'Value') ==1)
    
    switch get(handles.MacroMenu,'value')
        case 2
            disp('Beginning test for Absolute Accuracy over Temperature...\n');
            AAOT(CPC, tchamber, ip, handles);
        case 3
            disp('Beginning test for Absolute Accuracy over Temperature w/ TCO + Temperature Hysteresis...\n');
            AAOT_TCO_TH(CPC, tchamber, 100,ip, handles);
        case 4
            disp('Beginning test Linearity and Pressure Hysteresis...\n');
            Lin_PH(CPC, tchamber, 25, ip, handles);
        case 5
            disp('Temperature Hysteresys');
            Temp_H(CPC, tchamber, ip, 100, handles);
        case 6
            disp('Auto Mode Enabled');
            auto(CPC, tchamber, 100,ip, handles);
        case 7
            disp('Manual Mode Selected');
            
            switch get(handles.ManualMenu,'value')
                case 1
                    TempSweep(CPC, tchamber, str2double(get(txtConstPres, 'String')), ip, handles)
                case 2
                    Temp_H(CPC, tchamber, str2double(get(txtConstPres, 'String')), ip, handles)
                case 3
                    PresSweep(CPC, tchamber,str2double(get(txtConstTemp, 'String')), ip, handles);
                otherwise
                    Pres_H(CPC, tchamber,str2double(get(txtConstTemp, 'String')), ip, handles);
            end
        otherwise
            msgbox('Please Select a Mode');       
    end
    
    
else
    
    
    switch get(handles.MacroMenu,'value')
        case 2
            disp('Beginning test for Absolute Accuracy over Temperature WITHOUT logging...\n');
            AAOT_nolog(CPC,tchamber, 70, ip,handle);
        case 3
            disp('Beginning test for Absolute Accuracy over Temperature w/ TCO + Temperature Hysteresis WITHOUT logging...\n');
            AAOT_TCO_TH_nolog(CPC, tchamber, 70, handles);
        case 4
            disp('Beginning test Linearity and Pressure Hysteresis WITHOUT logging...\n');
            Lin_PH_nolog(CPC, tchamber, 25, ip, handles);
        case 5
            disp('Temperature Hysteresys');
            Temp_H_nolog(CPC, tchamber, ip, 100, handles);
        case 6
            disp('Auto Mode Enabled');
        case 7
            disp('Manual Mode Selected');
            
            switch get(handles.ManualMenu,'value')
                case 1
                    TempSweep_nolog(CPC, tchamber, str2double(get(txtConstPres, 'String')), ip, handles)
                case 2
                    Temp_H_nolog(CPC, tchamber, str2double(get(txtConstPres, 'String')), ip, handles)
                case 3
                    PresSweep_nolog(CPC, tchamber,str2double(get(txtConstTemp, 'String')), ip, handles);
                otherwise
                    Pres_H_nolog(CPC, tchamber,str2double(get(txtConstTemp, 'String')), ip, handles);
            end
        otherwise
            msgbox('Please Select a Mode');       
    end
    
        
end



% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tchamber;
global CPC;
set(handles.startButton,'Enable','off');
set(handles.resetButton,'Enable','off');
set(handles.initButton,'Enable','on');
PowerOff(tchamber);
CleanUp(CPC);
CleanUp(tchamber);



function DeviceIP_Callback(hObject, eventdata, handles)
% hObject    handle to DeviceIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DeviceIP as text
%        str2double(get(hObject,'String')) returns contents of DeviceIP as a double
if (str_isnumeric(get(hObject,'String')))
    handles.metricdata.ip = get(hObject,'String');
else
    msgbox('Please input a number','Error','error');
    
end


function txtConstTemp_Callback(hObject, eventdata, handles)
% hObject    handle to txtConstTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtConstTemp as text
%        str2double(get(hObject,'String')) returns contents of txtConstTemp as a double
if (str_isnumeric(get(hObject,'String')))
    handles.metricdata.temp = str2double(get(hObject,'String'));
else
    msgbox('Please input a number','Error','error');
    
end



function txtConstPres_Callback(hObject, eventdata, handles)
% hObject    handle to txtConstPres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtConstPres as text
%        str2double(get(hObject,'String')) returns contents of txtConstPres as a double
if (str_isnumeric(get(hObject,'String')))
    handles.metricdata.pressure = str2double(get(hObject,'String'));
else
    msgbox('Please input a number','Error','error');
    
end


% --- Executes on selection change in ManualMenu.
function ManualMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ManualMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ManualMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ManualMenu
ManualEnable(hObject, eventdata, handles);
switch (get(hObject,'value'))
    case 1
        handles.metricdata.case = 7;
        %msgbox('please input pressure');
    case 2
        handles.metricdata.case = 8;
        %msgbox('please input pressure');
    case 3
        handles.metricdata.case = 9;
        %msgbox('please input temperature');
    case 4
        handles.metricdata.case = 10;
        %msgbox('please input temperature');
end


% --- Executes during object creation, after setting all properties.
function GPIB_Temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GPIB_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function GPIB_CPC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GPIB_CPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function DeviceIP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DeviceIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function TempAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TempAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate TempAxes


% --- Executes during object creation, after setting all properties.
function startButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function resetButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ManualMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManualMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function txtConstTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtConstTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function txtConstPres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtConstPres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function PressureDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PressureDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function TempDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TempDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function MacroMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MacroMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ckLog.
function ckLog_Callback(hObject, eventdata, handles)
% hObject    handle to ckLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of ckLog
handles.metricdata.isLog = get(hObject, 'Value');
if handles.metricdata.isLog == 1
    set(handles.DeviceIP,'Enable','on');
    set(handles.GPIB_CPC,'Enable','on');
    set(handles.GPIB_Temp,'Enable','on');
else
    set(handles.DeviceIP,'Enable','off');
    set(handles.GPIB_CPC,'Enable','off');
    set(handles.GPIB_Temp,'Enable','off');
end


% --- Executes on button press in initButton.
function initButton_Callback(hObject, eventdata, handles)
% hObject    handle to initButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tchamber;
global CPC;
set(handles.initButton,'Enable','off');
tchamber = InitT(handles.metricdata.GPIB_tchamber)
PowerOn(tchamber); %Turns on temperature chamber
%Standby(tchamber);
%handles.metricdata.tchamber = tchamber
CPC = InitP(handles.metricdata.GPIB_CPC)
%handles.metricdata.CPC = CPC
set(handles.startButton,'Enable','on');
