function varargout = GUItest1(varargin)
% GUITEST1 MATLAB code for GUItest1.fig
%      GUITEST1, by itself, creates a new GUITEST1 or raises the existing
%      singleton*.
%
%      H = GUITEST1 returns the handle to a new GUITEST1 or the handle to
%      the existing singleton*.
%
%      GUITEST1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITEST1.M with the given input arguments.
%
%      GUITEST1('Property','Value',...) creates a new GUITEST1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUItest1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUItest1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUItest1

% Last Modified by GUIDE v2.5 12-Feb-2019 21:17:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUItest1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUItest1_OutputFcn, ...
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


% --- Executes just before GUItest1 is made visible.
function GUItest1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUItest1 (see VARARGIN)
set(handles.Select_buttongroup,'SelectionChangeFcn', @Select_buttongroup_SelectionChangeFcn);
set(handles.display_staticText,'String','Select an Amount!');

% Choose default command line output for GUItest1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GUItest1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUItest1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in displayText_pushbutton.
function displayText_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to displayText_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton2.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton2.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
function Select_buttongroup_SelectionChangeFcn(hObject,eventdata)
handles = guidata(hObject);
switch get(eventdata.NewValue, 'Tag')   %Get Tag of selected object
    case 'radiobutton1'
        set(handles.display_staticText,'String','Select an Amount!');   
    case 'radiobutton2'
        %Displays "sml amount" in the static text component when the pushbutton is
        %pressed
        set(handles.display_staticText,'String','Small Amount being dispensed...');
    case 'radiobutton3'
        set(handles.display_staticText,'String','Medium Amount being dispensed...');
    case 'radiobutton4'
        set(handles.display_staticText,'String','Large Amount being dispensed...');
    otherwise
        %otherwise 
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
sliderValue = get(handles.slider1,'Value');
 set(handles.text10,'String',num2str(sliderValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
sliderValue = get(handles.slider3,'Value');
 set(handles.text11,'String',num2str(sliderValue));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
