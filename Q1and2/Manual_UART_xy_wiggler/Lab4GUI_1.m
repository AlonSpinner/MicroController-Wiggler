function varargout = Lab4GUI_1(varargin)
% LAB4GUI_1 MATLAB code for Lab4GUI_1.fig
%      LAB4GUI_1, by itself, creates a new LAB4GUI_1 or raises the existing
%      singleton*.
%
%      H = LAB4GUI_1 returns the handle to a new LAB4GUI_1 or the handle to
%      the existing singleton*.
%
%      LAB4GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAB4GUI_1.M with the given input arguments.
%
%      LAB4GUI_1('Property','Value',...) creates a new LAB4GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Lab4GUI_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Lab4GUI_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Lab4GUI_1

% Last Modified by GUIDE v2.5 19-Jul-2019 18:29:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lab4GUI_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Lab4GUI_1_OutputFcn, ...
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
function Lab4GUI_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Lab4GUI_1 (see VARARGIN)

%default data
DefaultN=24;
handles.nEdit.String=num2str(DefaultN);
NewRowName=cell(DefaultN,1); for i=1:DefaultN, NewRowName{i}=['p' num2str(i)]; end
handles.CalibTable.RowName=NewRowName;


DefaultData={'-2'   '-2'    '-73'    '-100'
    '-1'    '-2'    '-74'    '-53' 
    '0'     '-2'    '-64'    '-8'  
    '1'     '-2'    '-58'    '36'  
    '2'     '-2'    '-49'    '71'  
    '2'     '-1'    '-10'    '80'  
    '2'     '0'     '28'     '85'  
    '2'     '1'     '58'     '96'  
    '2'     '2'     '100'    '100' 
    '1'     '2'     '100'    '41'  
    '0'     '2'     '88'     '-13' 
    '-1'    '2'     '85'     '-56' 
    '-2'    '2'     '69'     '-100'
    '-2'    '1'     '22'     '-100'
    '-2'    '0'     '-19'    '-100'
    '-2'    '-1'    '-51'    '-100'
    '-1'    '-1'    '-43'    '-51' 
    '0'     '-1'    '-36'    '7'   
    '1'     '-1'    '-27'    '41'  
    '1'     '0'     '18'     '46'  
    '1'     '1'     '54'     '46'  
    '0'     '1'     '43'     '-5'  
    '-1'    '1'     '37'     '-51' 
    '-1'    '0'     '-7'     '-51'};
handles.CalibTable.Data=DefaultData;

%VCxSlider Step
xmaxSliderValue = get(handles.VCxSlider, 'Max');
xminSliderValue = get(handles.VCxSlider, 'Min');
xRange = xmaxSliderValue - xminSliderValue;
xsteps = [1/xRange, 10/xRange];
set(handles.VCxSlider, 'SliderStep', xsteps);

%VCySlider Step
ymaxSliderValue = get(handles.VCySlider, 'Max');
yminSliderValue = get(handles.VCySlider, 'Min');
yRange = ymaxSliderValue - yminSliderValue;
ysteps = [1/yRange, 10/yRange];
set(handles.VCySlider, 'SliderStep', ysteps);

% Choose default command line output for Lab4GUI_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
function varargout = Lab4GUI_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%% Callbacks
%buttons and sliders
function LoadSimulinkPush_Callback(hObject, eventdata, handles)
check=exist('uart_xy_wiggler.slx','file'); %check if simulink file is in matlab path
if ~check, error('Please ensure that the current folder has the file "uart_xy_wiggler.slx" in it'); end
h=helpdlg('please wait . . .');
rtwbuild('uart_xy_wiggler'); %build simulink model
delete(h);

%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s) 
    helpdlg('Next, Please connect COM port'); 
    return
end

CircleREdit_Callback(handles.CircleREdit,[],handles);
CircFreqEdit_Callback(handles.CircFreqEdit,[],handles);
VCxSlider_Callback(handles.VCxSlider,[],handles);
VCySlider_Callback(handles.VCySlider,[],handles);
AxcEdit_Callback(handles.AxcEdit,[],handles);
AycEdit_Callback(handles.AycEdit,[],handles);
AysEdit_Callback(handles.AysEdit,[],handles);
AxsEdit_Callback(handles.AxsEdit,[],handles);
LissFreqEdit_Callback(handles.LissFreqEdit,[],handles);
A_LaserEdit_Callback(handles.A_LaserEdit,[],handles);
function ConnectCOMPush_Callback(hObject, eventdata, handles)
%connect come
s=find_com_port;
helpdlg(sprintf('Port %s is connected',s.Port));
hObject.UserData=s;

%insert default values into stm.
%if COM was conneted before simulink loaded, load has a "insert default
%values into stm" part in it itself
CircleREdit_Callback(handles.CircleREdit,[],handles);
CircFreqEdit_Callback(handles.CircFreqEdit,[],handles);
VCxSlider_Callback(handles.VCxSlider,[],handles);
VCySlider_Callback(handles.VCySlider,[],handles);
AxcEdit_Callback(handles.AxcEdit,[],handles);
AycEdit_Callback(handles.AycEdit,[],handles);
AysEdit_Callback(handles.AysEdit,[],handles);
AxsEdit_Callback(handles.AxsEdit,[],handles);
LissFreqEdit_Callback(handles.LissFreqEdit,[],handles);
A_LaserEdit_Callback(handles.A_LaserEdit,[],handles);
function CalibratePush_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%extract data from calibration matrix
CellData=handles.CalibTable.Data;
n=size(CellData,1);
try NumData=cell2mat(reshape(cellfun(@str2num,CellData(:),'un',0),n,4));
catch, error('Calibration matrix is not filled correctly'); end
x=NumData(:,1); y=NumData(:,2); vx=NumData(:,3); vy=NumData(:,4);

%parameter extraction
A=zeros(n,5); [bx,by]=deal(zeros(n,1));
for i=1:n
    A(i,:)=[x(i),y(i),x(i)^2,y(i)^2,x(i)*y(i)];
    bx(i)=vx(i); by(i)=vy(i);
end
ab=[A\bx;A\by]; %matlab optimizes by least squares

%store parameter in hobject for circle
hObject.UserData=ab;
helpdlg('finished calibrating');
function CirclePush_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update flag in stm
Cmd=sprintf('CircleFlag=%f',1);
fwrite(s,[Cmd 13 10]);
function DrawLissaPush_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update flag in stm
Cmd=sprintf('CircleFlag=%f',2); %CircleFlag also acts as switch for lissajou
fwrite(s,[Cmd 13 10]);
function VCxSlider_Callback(hObject, eventdata, handles)
%obtain position value
x=hObject.Value;

%write to nucleo
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end
Cmd=sprintf('vcx=%f',x);
fwrite(s,[Cmd 13 10]);

%update flag in stm
Cmd=sprintf('CircleFlag=%f',0);
fwrite(s,[Cmd 13 10]);

%update Txt
handles.VCxPosTxt.String=sprintf('VoiceCoil x position: %.2g',x);
function VCySlider_Callback(hObject, eventdata, handles)
%obtain position value
y=hObject.Value;

%write to nucleo
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end
Cmd=sprintf('vcy=%f',y);
fwrite(s,[Cmd 13 10]);

%update flag in stm
Cmd=sprintf('CircleFlag=%f',0);
fwrite(s,[Cmd 13 10]);

%update Txt
handles.VCyPosTxt.String=sprintf('VoiceCoil y position: %.2g',y);
%gui edits
function nEdit_Callback(hObject, eventdata, handles)
val=str2num(hObject.String);
if val<5, error('calibration model requires at least 5 data points u fuck'); end
NewRowName=cell(val,1); for i=1:val, NewRowName{i}=['p' num2str(i)]; end
handles.CalibTable.RowName=NewRowName;
handles.CalibTable.Data=cell(val,4);
%circle editbox
function CircleREdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%obtain number
val=str2num(hObject.String);

%update flag in stm
Cmd=sprintf('CircleR=%f',val);
fwrite(s,[Cmd 13 10]);
function CircFreqEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('CircleFrequency=%f',val);
fwrite(s,[Cmd 13 10]);
%lissa edits
function AxcEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('Axc=%f',val);
fwrite(s,[Cmd 13 10]);
function AycEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('Ayc=%f',val);
fwrite(s,[Cmd 13 10]);
function AysEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('Ays=%f',val);
fwrite(s,[Cmd 13 10]);
function AxsEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('Axs=%f',val);
fwrite(s,[Cmd 13 10]);
function LissFreqEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('LissaFreq=%f',val);
fwrite(s,[Cmd 13 10]);
function A_LaserEdit_Callback(hObject, eventdata, handles)
%check COM is connected
s=handles.ConnectCOMPush.UserData;
if isempty(s), error('COM not connected u fool!'); end

%update in stm
val=str2num(hObject.String);
Cmd=sprintf('A_Laser=%f',val);
fwrite(s,[Cmd 13 10]);
%% Functions
function s=find_com_port
%find available com port
% if there's more than one, take the last one
% since COM1 is usally part of the hardwaare (old PCs)
%
%Izhak Bucher May-2015
% for the "Microprocessor based product design" course

 
s=instrfind;
if ~isempty(s)
    fclose(s);
    delete(s);
end


S=instrhwinfo('serial');
 s1=S.SerialPorts ;
  
   s1=s1{end};
  
 
 
s = serial(s1);
s.Terminator='CR/LF';
s.BaudRate=115200;
s.InputBufferSize = 2^20;

fopen(s);
%% Unimportant GUI Fcns
function VCxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VCxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function VCySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VCySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function VCxPosTxt_CreateFcn(hObject, eventdata, handles)
function VCyPosTxt_CreateFcn(hObject, eventdata, handles)
function nEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function CircleREdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CircleREdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function AxcEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxcEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function AycEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AycEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function AysEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AysEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function AxsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function LissFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LissFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function A_LaserEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A_LaserEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function CircFreqEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CircFreqEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
