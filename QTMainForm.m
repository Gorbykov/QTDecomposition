function varargout = QTMainForm(varargin)
% QTMAINFORM MATLAB code for QTMainForm.fig
%      QTMAINFORM, by itself, creates a new QTMAINFORM or raises the existing
%      singleton*.
%
%      H = QTMAINFORM returns the handle to a new QTMAINFORM or the handle to
%      the existing singleton*.
%
%      QTMAINFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QTMAINFORM.M with the given input arguments.
%
%      QTMAINFORM('Property','Value',...) creates a new QTMAINFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QTMainForm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QTMainForm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QTMainForm

% Last Modified by GUIDE v2.5 15-Nov-2016 22:17:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QTMainForm_OpeningFcn, ...
                   'gui_OutputFcn',  @QTMainForm_OutputFcn, ...
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


% --- Executes just before QTMainForm is made visible.
function QTMainForm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QTMainForm (see VARARGIN)

% Choose default command line output for QTMainForm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QTMainForm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QTMainForm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';
'*.*','All Files' },'Open Image');
global img
img = imread(fullfile(PathName, FileName));
if(ndims(img)==3)
    img = rgb2gray(img);
end
img = im2double(img);
newN = 2^(nextpow2(min(size(img)))-1);
img = imcrop(img,[0 0 min(size(img)) min(size(img))]);
img = imresize(img, [newN newN]); 
figure;
imshow(img);
title('Croped, scaled and discolored image'); 


function depthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to depthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of depthEdit as text
%        str2double(get(hObject,'String')) returns contents of depthEdit as a double


% --- Executes during object creation, after setting all properties.
function depthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to depthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
clc;
depth = str2double(handles.depthEdit.String);
threshold = str2double(handles.thresholdEdit.String);
if not( isempty(img))
    QtMain(img, depth, threshold);
end

function thresholdEdit_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdEdit as text
%        str2double(get(hObject,'String')) returns contents of thresholdEdit as a double


% --- Executes during object creation, after setting all properties.
function thresholdEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
