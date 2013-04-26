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

% Last Modified by GUIDE v2.5 25-Apr-2013 16:25:05

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting the global variables and packaging them in handles
% This will allow all my subroutines to use these variables
% Since handles passed by all the subroutines

handles.metricdata.temp = 0;
handles.metricdata.pressure = 0;
handles.metricdata.Manual = 0;
handles.metricdata.GPIB_CPC = 2;
handles.metricdata.GPIB_tchamber= 1;
handles.metricdata.ip= 0;
handles.metricdata.isLog= 0;
handles.metricdata.time= 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mainly for UI features where specific blocks are enabled using this
% function
MacroEnable(hObject, eventdata, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





   
        
        

function GPIB_Temp_Callback(hObject, eventdata, handles)
% hObject    handle to GPIB_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GPIB_Temp as text
%        str2double(get(hObject,'String')) returns contents of GPIB_Temp as a double



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the entered value for GPIB is a number
if (str_isnumeric(get(hObject,'String')))
    handles.metricdata.GPIB_tchamber = str2double(get(hObject,'String'));
else
    msgbox('Please input a number','Error','error');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    




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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CPC and tchamber needs to be a global variable for it to be passed and
%initialized in other sequences 

global tchamber;
global CPC;

%Parsing the ip txt field
ip = get(handles.DeviceIP, 'String');
skipWait = get(handles.isSkip, 'Value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PROFILE SELECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (get(handles.ckLog , 'Value') ==1)    
    switch get(handles.MacroMenu,'value')
        case 2
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning test for Absolute Accuracy over Temperature...\n');
            AAOT(CPC, tchamber, ip, handles,skipWait);
        case 3
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning test for Absolute Accuracy over Temperature w/ TCO + Temperature Hysteresis...\n');
            AAOT_TCO_TH(CPC, tchamber, 100,ip, handles,skipWait);
        case 4
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning test Linearity and Pressure Hysteresis...\n');
            Lin_PH(CPC, tchamber, 25, ip, handles,skipWait);
        case 5
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning whole test suite');
            auto(CPC, tchamber, 100,ip, handles,skipWait);
       
        otherwise
            msgbox('Please Select a Mode');       
    end
    
    
    
else    
    
    switch get(handles.MacroMenu,'value')
        case 2
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning test for Absolute Accuracy over Temperature WITHOUT logging...\n');
            AAOT_nolog(CPC,tchamber, 70, ip,handle,skipWait);
        case 3
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning test for Absolute Accuracy over Temperature w/ TCO + Temperature Hysteresis WITHOUT logging...\n');
            AAOT_TCO_TH_nolog(CPC, tchamber, 70, handles,skipWait);
        case 4
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('Beginning test Linearity and Pressure Hysteresis WITHOUT logging...\n');
            Lin_PH_nolog(CPC, tchamber, 25, ip, handles,skipWait);
        case 5
            cla(handles.TempAxes);
            cla(handles.PressureAxes);
            disp('beginning whole test suite');
        
        otherwise
            msgbox('Please Select a Mode');       
    end
    
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%resets all the connections and objects
global tchamber;
global CPC;

PowerOff(tchamber);
CleanUp(CPC);
CleanUp(tchamber);
set(handles.initButton,'Enable','on');
set(handles.startButton,'Enable','off');
set(handles.ManualButton,'Enable','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function DeviceIP_Callback(hObject, eventdata, handles)
% hObject    handle to DeviceIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DeviceIP as text
%        str2double(get(hObject,'String')) returns contents of DeviceIP as a double
% if (str_isnumeric(get(hObject,'String')))
%     handles.metricdata.ip = get(hObject,'String');
% else
%     msgbox('Please input a number','Error','error');
%     
% end


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
axis([0,100,0,80]);


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mainly for UI purposes
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in initButton.
function initButton_Callback(hObject, eventdata, handles)
% hObject    handle to initButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization of all the GPIB objects
global tchamber;
global CPC;

handles.metricdata.ip = getIP;
set(handles.DeviceIP,'String',handles.metricdata.ip);
obj = RT_init(handles.metricdata.ip);
RT_log(obj);
RT_startlog(obj);
PutString(obj, ['cat /pps/system/nvram/deviceinfo | grep PIN:: | sed -e ''s/PIN::0x//g''' char(13)]);
RT_stoplog(obj);
pause(0.5)
set(handles.initButton,'Enable','off');
tchamber = InitT(handles.metricdata.GPIB_tchamber);
PowerOn(tchamber); %Turns on temperature chamber
%Standby(tchamber);
%handles.metricdata.tchamber = tchamber
CPC = InitP(handles.metricdata.GPIB_CPC);
%handles.metricdata.CPC = CPC
set(handles.startButton,'Enable','on');
set(handles.ManualButton,'Enable','on');
set(handles.ManualButton,'String','Set');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in ManualButton.
function ManualButton_Callback(hObject, eventdata, handles)
% hObject    handle to ManualButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileInit('scrap.csv');
SetTemp(CPC,tchamber,str2double(get(txtConstTemp, 'String')),handles,'scrap.csv');
SetPressure(CPC,tchamber,str2double(get(txtConstPres, 'String')),handles,'scrap.csv');




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in isSkip.
function isSkip_Callback(hObject, eventdata, handles)
% hObject    handle to isSkip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isSkip



% --- Executes during object creation, after setting all properties.
function PressureAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PressureAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate PressureAxes
axis([0,100,60,130]);

